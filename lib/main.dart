import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:zent_fe/di/injection_container.dart' as di;
import 'package:zent_fe/presentation/common/auth/auth_view_model.dart';
import 'package:zent_fe/routing/router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:developer' as developer;

// 1. Create a GlobalKey to control SnackBars from anywhere
final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  developer.log("Handling a background message: ${message.messageId}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  await dotenv.load(fileName: ".env");
  await di.init();

  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await _setupFCMForTesting();

  // 2. Add the Foreground Listener here!
  _setupForegroundMessaging();

  runApp(const MyApp());
}

// 3. The new Foreground Handler logic
void _setupForegroundMessaging() {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    developer.log('Got a message whilst in the foreground!');
    developer.log('Message data: ${message.data}');

    if (message.notification != null) {
      developer.log(
        'Message also contained a notification: ${message.notification}',
      );

      // 4. Trigger an In-App SnackBar safely using the GlobalKey
      rootScaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text(
            '${message.notification?.title}: ${message.notification?.body}',
          ),
          backgroundColor: Colors.deepPurple,
          behavior:
              SnackBarBehavior.floating, // Makes it look like an in-app banner
          duration: const Duration(seconds: 4),
        ),
      );
    }
  });
}

Future<void> _setupFCMForTesting() async {
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
