import 'package:go_router/go_router.dart';
import 'routes.dart';

// Common screens
import '../presentation/common/intro/screens/splash_screen.dart';
import '../presentation/common/intro/screens/on_boarding_screen.dart';

// Auth screens
import '../../presentation/auth/screens/login_screen.dart';
import '../../presentation/auth/screens/forgot_password_screen.dart'; 
import '../../presentation/auth/screens/verify_otp_screen.dart';
import '../../presentation/auth/screens/create_new_password_screen.dart';
import '../../presentation/auth/screens/reset_successfully_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: Routes.splash,
    routes: [
      // 1. Splash & Onboarding
      GoRoute(
        path: Routes.splash,
        builder: (context, state) => const AppSplashScreen(),
      ),
      GoRoute(
        path: Routes.onBoarding,
        builder: (context, state) => const OnBoardingScreen(),
      ),

      // 2. Auth Flow 
      GoRoute(
        path: Routes.login,
        builder: (context, state) => const LoginScreen(),
        routes: [
          GoRoute(
            path: Routes.forgetPassword,
            builder: (context, state) => const ForgotPasswordScreen(),
          ),
          GoRoute(
            path: Routes.verifyOtp,
            builder: (context, state) => const VerifyOtpScreen(),
          ),
          GoRoute(
            path: Routes.resetPassword,
            builder: (context, state) => const CreateNewPasswordScreen(),
          ),
          GoRoute(
            path: Routes.resetSuccessfully,
            builder: (context, state) => const ResetSuccessfullyScreen(),
          )
        ],
      ),

      // 3. Admin Flow (to be added)

      // 4. Technician Flow (to be added)
    ],
  );
}