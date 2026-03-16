import 'dart:convert';

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
import 'package:zent_fe/domain/entities/enums/user_role.dart' show UserRole;
import './routes.dart' show Routes;

// ---------------------------------------------------------------------------
// RBAC — Role-Based Access Control
// ---------------------------------------------------------------------------

/// Token store.
/// Call [RbacTokenStore.setToken] from your auth datasource after login and
/// [RbacTokenStore.clearToken] on logout.
class RbacTokenStore {
  RbacTokenStore._();

  static String? _token;

  static void setToken(String token) => _token = token;
  static void clearToken() => _token = null;
  static String? get token => _token;
}

UserRole _getRoleFromToken() {
  final token = RbacTokenStore.token;
  if (token == null) return UserRole.unauthenticated;
  try {
    final parts = token.split('.');
    if (parts.length != 3) return UserRole.unauthenticated;
    // Base64Url-decode the payload (middle segment) and parse claims.
    final normalized = base64Url.normalize(parts[1]);
    final decoded = utf8.decode(base64Url.decode(normalized));
    final claims = jsonDecode(decoded) as Map<String, dynamic>;
    return switch (claims['role'] as String?) {
      'admin' => UserRole.admin,
      'technician' => UserRole.technician,
      'customer' => UserRole.customer,
      _ => UserRole.unauthenticated,
    };
  } catch (_) {
    return UserRole.unauthenticated;
  }
}

const _publicPrefixes = [Routes.splash, Routes.onBoarding, Routes.login];

String? _rbacRedirect(BuildContext context, GoRouterState state) {
  final location = state.matchedLocation;
  final role = _getRoleFromToken();

  final isPublic = _publicPrefixes.any(
    (p) => location == p || location.startsWith('$p/'),
  );

  // ── Unauthenticated ─────────────────────────────────────────────────────
  if (role == UserRole.unauthenticated) {
    // Allow public routes; everything else goes to login.
    return isPublic ? null : Routes.login;
  }

  // ── Authenticated on a public / auth route ───────────────────────────────
  // Redirect straight to the role's home screen.
  if (isPublic) {
    return switch (role) {
      UserRole.admin => Routes.adminDashboard,
      UserRole.technician => Routes.techHome,
      UserRole.customer => Routes.customerServices,
      UserRole.unauthenticated => null,
    };
  }

  // ── Guard role-specific route sections ──────────────────────────────────
  final isAdminRoute = location.startsWith('/admin');
  final isTechRoute = location.startsWith('/tech');
  final isCustomerRoute = location.startsWith('/customer');

  if (isAdminRoute && role != UserRole.admin) {
    return switch (role) {
      UserRole.technician => Routes.techHome,
      UserRole.customer => Routes.customerServices,
      _ => Routes.login,
    };
  }

  if (isTechRoute && role != UserRole.technician) {
    return switch (role) {
      UserRole.admin => Routes.adminDashboard,
      UserRole.customer => Routes.customerServices,
      _ => Routes.login,
    };
  }

  if (isCustomerRoute && role != UserRole.customer) {
    return switch (role) {
      UserRole.admin => Routes.adminDashboard,
      UserRole.technician => Routes.techHome,
      _ => Routes.login,
    };
  }

  return null; // No redirect needed.
}

// ---------------------------------------------------------------------------

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: Routes.splash,
  redirect: _rbacRedirect,
  routes: [
    // Main routes
    GoRoute(
      name: 'splash',
      path: Routes.splash,
      builder: (context, state) => const AppSplashScreen(),
    ),
    GoRoute(
      name: 'onBoarding',
      path: Routes.onBoarding,
      builder: (context, state) => const OnBoardingScreen(),
    ),
    GoRoute(
      name: 'login',
      path: Routes.login,
      builder: (context, state) => const LoginScreen(),
      routes: [
        // Sub routes for password recovery flow
        GoRoute(
          name: 'forgotPassword',
          path: Routes.forgetPassword,
          builder: (context, state) => const ForgotPasswordScreen(),
          routes: [
            GoRoute(
              name: 'forgotPasswordVerifyOtp',
              path: Routes.verifyOtp,
              builder: (context, state) => const VerifyOtpScreen(),
              routes: [
                GoRoute(
                  name: 'resetPassword',
                  path: Routes.resetPassword,
                  builder: (context, state) => const ResetPasswordScreen(),
                  routes: [
                    GoRoute(
                      name: 'resetSuccessfully',
                      path: Routes.resetSuccessfully,
                      builder: (context, state) =>
                          const ResetSuccessfullyScreen(),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          name: 'signUp',
          path: Routes.signUp,
          builder: (context, state) =>
              const Scaffold(body: Center(child: Text('Sign Up Screen'))),
          routes: [
            GoRoute(
              name: 'signUpVerifyOtp',
              path: Routes.verifyOtp,
              builder: (context, state) => const Scaffold(
                body: Center(child: Text('Sign Up Verify OTP Screen')),
              ),
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
        StatefulShellBranch(
          routes: [
            GoRoute(
              name: 'adminDashboard',
              path: Routes.adminDashboard,
              builder: (context, state) => const Scaffold(
                body: Center(child: Text('Admin Dashboard Screen')),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              name: 'adminReports',
              path: Routes.adminReports,
              builder: (context, state) => const Scaffold(
                body: Center(child: Text('Admin Reports Screen')),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              name: 'adminTeam',
              path: Routes.adminTeam,
              builder: (context, state) =>
                  const Scaffold(body: Center(child: Text('Team Screen'))),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              name: 'adminMe',
              path: Routes.adminMe,
              builder: (context, state) => const ProfileScreen(),
              routes: [
                GoRoute(
                  name: 'securitySettings',
                  path: Routes.securitySettings,
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) => const SecuritySettingsScreen(),
                ),
                GoRoute(
                  name: 'userManagement',
                  path: Routes.userManagement,
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) => const UserManagementScreen(),
                  routes: [
                    GoRoute(
                      name: 'chooseRoleCreateAccount',
                      path: Routes.chooseRoleCreateAccount,
                      builder: (context, state) => const Scaffold(
                        body: Center(
                          child: Text('Choose Role Create Account Screen'),
                        ),
                      ),
                      routes: [
                        GoRoute(
                          name: 'createAccount',
                          path: Routes.createAccount,
                          builder: (context, state) => const Scaffold(
                            body: Center(child: Text('Create Account Screen')),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                GoRoute(
                  name: 'systemLog',
                  path: Routes.systemLog,
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) => const Scaffold(
                    body: Center(child: Text('System Log Screen')),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    ),

    // Technician top level routes
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return Scaffold(body: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              name: 'techHome', //
              path: Routes.techHome,
              builder: (context, state) =>
                  const Scaffold(body: Center(child: Text('Tech Home Screen'))),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              name: 'techWorkOrder',
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
              name: 'techMessage',
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
              name: 'techMe',
              path: Routes.techMe,
              builder: (context, state) =>
                  const Scaffold(body: Center(child: Text('Tech Me Screen'))),
            ),
          ],
        ),
      ],
    ),

    // Customer top level routes
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return Scaffold(body: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              name: 'customerServices',
              path: Routes.customerServices,
              builder: (context, state) => const Scaffold(
                body: Center(child: Text('Customer Services Screen')),
              ),
              routes: [
                GoRoute(
                  name: 'customerMyProducts',
                  path: Routes.myProducts,
                  builder: (context, state) => const Scaffold(
                    body: Center(child: Text('Customer My Products Screen')),
                  ),
                ),
                GoRoute(
                  name: 'customerRequestService',
                  path: Routes.requestService,
                  builder: (context, state) => const Scaffold(
                    body: Center(
                      child: Text('Customer Request Service Screen'),
                    ),
                  ),
                ),
                GoRoute(
                  name: 'customerActiveRepairs',
                  path: Routes.activeRepairs,
                  builder: (context, state) => const Scaffold(
                    body: Center(child: Text('Customer Active Repairs Screen')),
                  ),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              name: 'customerMessages',
              path: Routes.customerMessages,
              builder: (context, state) => const Scaffold(
                body: Center(child: Text('Customer Messages Screen')),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              name: 'customerMe',
              path: Routes.customerMe,
              builder: (context, state) => const Scaffold(
                body: Center(child: Text('Customer Me Screen')),
              ),
            ),
          ],
        ),
      ],
    ),
  ],
);
