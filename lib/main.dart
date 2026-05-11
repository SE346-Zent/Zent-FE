import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:zent_fe/di/injection_container.dart' as di;
import 'package:zent_fe/presentation/common/auth/auth_view_model.dart';
import 'package:zent_fe/routing/router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:developer' as developer; // <-- Tech Lead Tip: Use this instead of print()

// 1. MUST BE A TOP-LEVEL FUNCTION
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  developer.log("Handling a background message: ${message.messageId}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  await dotenv.load(fileName: ".env");
  await di.init();
  
  // Initialize Firebase First
  await Firebase.initializeApp();

  // 2. Register the background handler immediately
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // 3. Setup permissions and fetch the token
  await _setupFCMForTesting();

  runApp(const MyApp());
}

// 4. Extract logic to keep main() clean
Future<void> _setupFCMForTesting() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // Request permission from the user
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  developer.log('User granted permission: ${settings.authorizationStatus}');

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    // Fetch the token!
    String? token = await messaging.getToken();
    
    // Using formatting to make it stand out in your debug console
    developer.log('====================================');
    developer.log('FCM TOKEN: $token');
    developer.log('====================================');

    // 5. Best Practice: Listen for token changes
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      developer.log('FCM TOKEN REFRESHED: $newToken');
      // In production, this is where you would send the new token to your backend API!
    });
  } else {
    developer.log('User declined or has not accepted notification permissions');
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
        debugShowCheckedModeBanner: false, // Hides the debug banner
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        routerConfig: appRouter,
      ),
    );
  }
}