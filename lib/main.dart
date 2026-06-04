import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:zent_fe/di/injection_container.dart' as di;
import 'package:zent_fe/presentation/common/auth/auth_view_model.dart';
import 'package:zent_fe/presentation/common/notifications/notification_navigator.dart';
import 'package:zent_fe/routing/router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_app_installations/firebase_app_installations.dart';
import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:zent_fe/presentation/common/core/ui/chat_banner_listener.dart';
import 'package:geolocator/geolocator.dart';
import 'package:zent_fe/presentation/common/notifications/viewmodels/notifications_viewmodel.dart';

// 1. Create a GlobalKey to control SnackBars from anywhere
final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description:
      'This channel is used for important notifications.', // description
  importance: Importance.max, // MUST be max for heads-up banner
);

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  developer.log("Handling a background message: ${message.messageId}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();

  try {
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    await dotenv.load(fileName: ".env");
    await di.init();

    // Request location permission asynchronously on startup
    Geolocator.checkPermission()
        .then((permission) {
          if (permission == LocationPermission.denied) {
            Geolocator.requestPermission();
          }
        })
        .catchError((e) {
          developer.log("Error requesting location permission on startup: $e");
        });
  } catch (e) {
    developer.log("Local initialization failed: $e");
  }

  try {
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  } catch (e) {
    developer.log("Firebase initialization failed: $e");
  }

  try {
    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: AndroidInitializationSettings(
            '@mipmap/ic_launcher',
          ), // Use your app icon
        );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle foreground notification tap
        final payload = response.payload;
        if (payload != null && payload.isNotEmpty) {
          developer.log('Foreground notification tapped: $payload');
          try {
            // First decode the Map string representation (which is not valid JSON)
            // But actually we serialized it as: payload: jsonEncode(message.data)
            // Let's just pass it as jsonDecode(payload)
            final dynamic decoded = jsonDecode(payload);
            if (decoded is Map<String, dynamic>) {
              // We need to make sure the categoryName is carried over if it's not in the payload
              NotificationNavigator.savePendingNotification(decoded);
            }
          } catch (e) {
            developer.log('Error parsing foreground notification payload: $e');
            // Fallback for old naive format if it wasn't JSON encoded
            try {
              final data = <String, dynamic>{};
              final cleaned = payload.replaceAll('{', '').replaceAll('}', '');
              for (final pair in cleaned.split(', ')) {
                final kv = pair.split(': ');
                if (kv.length == 2) {
                  data[kv[0].trim()] = kv[1].trim();
                }
              }
              if (data.isNotEmpty) {
                NotificationNavigator.savePendingNotification(data);
              }
            } catch (_) {}
          }
        }
      },
    );

    // 4. Create the channel on the device
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  } catch (e) {
    developer.log("Local Notifications initialization failed: $e");
  }

  try {
    await _setupFCMForTesting();
  } catch (e) {
    developer.log("FCM Setup failed: $e");
  }

  try {
    _setupForegroundMessaging();
    _setupNotificationTapHandler();
    fetchInstallationId();
  } catch (e) {
    developer.log("Foreground messaging initialization failed: $e");
  }

  runApp(const MyApp());
}

// 3. The new Foreground Handler logic
void _setupForegroundMessaging() {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    developer.log('Got a message whilst in the foreground!');

    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    // If it's a chat message, let the WebSocket banner handle it
    final isChatMessage =
        message.data.containsKey('room_id') ||
        message.data.containsKey('roomId') ||
        (message.data.containsKey('payload') &&
            message.data['payload'].toString().contains('room_id'));
    if (isChatMessage) {
      developer.log(
        'Suppressing native FCM banner because it is a chat message handled by in-app banner',
      );
      return;
    }

    // If the message has a notification and we are on Android
    if (notification != null && android != null) {
      developer.log('Triggering native Android foreground banner');

      // Use jsonEncode so we can properly parse it in onDidReceiveNotificationResponse
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            icon: '@mipmap/ic_launcher',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
        payload: message.data.isNotEmpty ? jsonEncode(message.data) : null,
      );
    }
  });
}

/// Handle notification taps when app is opened from background state only.
/// Killed-state taps intentionally do NOT navigate — they only open the app.
void _setupNotificationTapHandler() {
  // App was in background, user tapped notification
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    developer.log(
      'App opened from background via notification: ${message.data}',
    );
    NotificationNavigator.processNotificationDataDirectly(message.data);
  });

  // Intentionally do NOT handle getInitialMessage (killed-state) here.
  // Tapping a notification when the app is fully killed should only open
  // the app to the home screen, not deep-link into a specific chat.
}

Future<void> fetchInstallationId() async {
  try {
    // Fetch the Firebase Installation ID
    String id = await FirebaseInstallations.instance.getId();

    developer.log('====================================');
    developer.log('FIREBASE INSTALLATION ID (FID): $id');
    developer.log('====================================');

    // Copy this ID from your console and paste it into the
    // "Test on Device" section of the Firebase In-App Messaging console.
  } catch (e) {
    developer.log('Error fetching Installation ID: $e');
  }
}

Future<void> _setupFCMForTesting() async {
  try {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      String? token = await messaging.getToken();
      developer.log('FCM TOKEN: $token');

      FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
        developer.log('FCM TOKEN REFRESHED: $newToken');
      });
    }
  } catch (e) {
    developer.log("Error during FCM setup: $e");
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => di.sl<AuthViewModel>()),
        ChangeNotifierProvider(
          create: (_) => di.sl<NotificationsViewModel>()..fetchUnreadCount(),
        ),
      ],
      child: MaterialApp.router(
        title: 'Zent FE',
        debugShowCheckedModeBanner: false,
        // 5. Attach the GlobalKey to the MaterialApp
        scaffoldMessengerKey: rootScaffoldMessengerKey,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        routerConfig: appRouter,
        builder: (context, child) {
          return ChatBannerListener(child: child ?? const SizedBox.shrink());
        },
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
