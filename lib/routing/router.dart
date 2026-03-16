import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../presentation/common/intro/on_boarding_screen.dart';
import '../presentation/common/intro/splash_screen.dart';
import '../presentation/common/auth/login/login_screen.dart';
import '../presentation/common/auth/login/forgot_password_screen.dart';
import '../presentation/common/auth/login/verify_otp_screen.dart';
import '../presentation/common/auth/login/reset_password_screen.dart';
import '../presentation/common/auth/login/reset_successfully_screen.dart';
import '../presentation/admin/account/profile_screen.dart';
import '../presentation/admin/account/security_settings_screen.dart';
import '../presentation/admin/account/user_management_screen.dart';
import '../presentation/common/core/layouts/admin_main_layout.dart';

import './routes.dart' show Routes;

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: Routes.splash,
  routes: [
    // Main routes
    GoRoute(
      path: Routes.splash,
      builder: (context, state) => const AppSplashScreen(),
    ),
    GoRoute(
      path: Routes.onBoarding,
      builder: (context, state) => const OnBoardingScreen(),
    ),
    GoRoute(
      path: Routes.login,
      builder: (context, state) => const LoginScreen(),
      routes: [
        // Sub routes for password recovery flow
        GoRoute(
          path: Routes.forgetPassword,
          builder: (context, state) => const ForgotPasswordScreen(),
          routes: [
            GoRoute(
              path: Routes.verifyOtp,
              builder: (context, state) => const VerifyOtpScreen(),
              routes: [
                GoRoute(
                  path: Routes.resetPassword,
                  builder: (context, state) => const ResetPasswordScreen(),
                  routes: [
                    GoRoute(
                      path: Routes.resetSuccessfully,
                      builder: (context, state) => const ResetSuccessfullyScreen(),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    ),

    // Admin top level routes using StatefulShellRoute
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return AdminMainLayout(navigationShell: navigationShell);
      },
      branches: [
        // Branch 0: Dashboard
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.adminDashboard,
              builder: (context, state) => const Scaffold(
                body: Center(child: Text('Admin Dashboard Screen')),
              ),
            ),
          ],
        ),
        // Branch 1: Reports
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.adminReports,
              builder: (context, state) => const Scaffold(
                body: Center(child: Text('Admin Reports Screen')),
              ),
            ),
          ],
        ),
        // Branch 2: Team
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.adminTeam,
              builder: (context, state) =>
                  const Scaffold(body: Center(child: Text('Team Screen'))),
            ),
          ],
        ),
        // Branch 3: Admin (Me)
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.me, // Initial Screen
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      // SecuritySettings
      name: 'securitySettings',
      path: Routes.securitySettings,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const SecuritySettingsScreen(),
    ),
    GoRoute(
      // UserManagement
      name: 'userManagement',
      path: Routes.userManagement,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const UserManagementScreen(),
    ),
    GoRoute(
      // SystemLog
      name: 'systemLog',
      path: Routes.systemLog,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) =>
          const Scaffold(body: Center(child: Text('System Log Screen'))),
    ),
    // Technician top level routes
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        // TODO: Replace this with TechMainLayout(navigationShell: navigationShell) when the UI is implemented
        return Scaffold(body: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.techHome,
              builder: (context, state) =>
                  const Scaffold(body: Center(child: Text('Tech Home Screen'))),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.techWorkOrder,
              builder: (context, state) => const Scaffold(
                body: Center(child: Text('Tech Work Order Screen')),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.techMessage,
              builder: (context, state) => const Scaffold(
                body: Center(child: Text('Tech Message Screen')),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.techMe,
              builder: (context, state) =>
                  const Scaffold(body: Center(child: Text('Tech Me Screen'))),
            ),
          ],
        ),
      ],
    ),
  ],
);
