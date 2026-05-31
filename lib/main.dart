import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:zent_fe/di/injection_container.dart' as di;
import 'package:zent_fe/presentation/common/auth/auth_view_model.dart';
import 'package:zent_fe/routing/router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_app_installations/firebase_app_installations.dart';
import 'dart:developer' as developer;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

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

    // If the message has a notification and we are on Android
    if (notification != null && android != null) {
      developer.log('Triggering native Android foreground banner');

      // Trigger the native system notification instead of a SnackBar
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
            // These two properties force the heads-up banner
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
      );
    }
  });
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
    return ChangeNotifierProvider(
      create: (_) => di.sl<AuthViewModel>(),
      child: MaterialApp.router(
        title: 'Zent FE',
        debugShowCheckedModeBanner: false,
        // 5. Attach the GlobalKey to the MaterialApp
        scaffoldMessengerKey: rootScaffoldMessengerKey,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        routerConfig: appRouter,
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
