import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../presentation/admin/account/profile_screen.dart';
import '../presentation/admin/account/company_settings_screen.dart';
import '../presentation/admin/account/security_settings_screen.dart';
import '../presentation/admin/account/user_management_screen.dart';
import '../presentation/common/core/layouts/admin_main_layout.dart';

import './routes.dart' show Routes;

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: Routes.me, // Set Profile as initial route for testing
  routes: [
    // Main routes
    GoRoute(
      path: Routes.splash,
      builder: (context, state) =>
          const Scaffold(body: Center(child: Text('Splash Screen'))),
    ),
    GoRoute(
      path: Routes.onBoarding,
      builder: (context, state) =>
          const Scaffold(body: Center(child: Text('OnBoarding Screen'))),
    ),
    GoRoute(
      path: Routes.login,
      builder: (context, state) =>
          const Scaffold(body: Center(child: Text('Login Screen'))),
      routes: [
        // Sub routes for password recovery flow
        GoRoute(
          path: Routes.forgetPassword,
          builder: (context, state) => const Scaffold(
            body: Center(child: Text('Forget Password Screen')),
          ),
          routes: [
            GoRoute(
              path: Routes.verifyOtp,
              builder: (context, state) => const Scaffold(
                body: Center(child: Text('Verify OTP Screen')),
              ),
              routes: [
                GoRoute(
                  path: Routes.resetPassword,
                  builder: (context, state) => const Scaffold(
                    body: Center(child: Text('Reset Password Screen')),
                  ),
                  routes: [
                    GoRoute(
                      path: Routes.resetSuccessfully,
                      builder: (context, state) => const Scaffold(
                        body: Center(child: Text('Reset Successfully Screen')),
                      ),
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
              path: Routes.adminTeam, // Profile Menu: User Management
              builder: (context, state) => const UserManagementScreen(),
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
      // CompanySettings
      name: 'companySettings',
      path: '/admin/company-settings',
      builder: (context, state) => const CompanySettingsScreen(),
    ),
    GoRoute(
      // SecuritySettings
      name: 'securitySettings',
      path: '/admin/security-settings',
      builder: (context, state) => const SecuritySettingsScreen(),
    ),

    // Technician top level routes
    GoRoute(
      path: Routes.techHome,
      builder: (context, state) =>
          const Scaffold(body: Center(child: Text('Tech Home Screen'))),
    ),
    GoRoute(
      path: Routes.techWorkOrder,
      builder: (context, state) =>
          const Scaffold(body: Center(child: Text('Tech Work Order Screen'))),
    ),
    GoRoute(
      path: Routes.techMessage,
      builder: (context, state) =>
          const Scaffold(body: Center(child: Text('Tech Message Screen'))),
    ),
    GoRoute(
      path: Routes.techMe,
      builder: (context, state) =>
          const Scaffold(body: Center(child: Text('Tech Me Screen'))),
    ),
  ],
);
