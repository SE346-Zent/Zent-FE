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
import '../presentation/customer/account/service_screen.dart';
import '../presentation/customer/account/chat_screen.dart';
import '../presentation/customer/account/profile_screen.dart';
import 'package:zent_fe/presentation/customer/account/personal_info_screen.dart';
import 'package:zent_fe/presentation/common/core/layouts/admin_main_layout.dart';
import 'package:zent_fe/presentation/common/core/layouts/customer_main_layout.dart';
import '../presentation/technician/account/tech_profile_screen.dart';
import '../presentation/technician/account/personal_info_screen.dart';
import '../presentation/technician/account/notifications_screen.dart';
import '../presentation/technician/account/security_screen.dart';
import '../presentation/technician/account/tech_work_order_screen.dart';
import '../presentation/technician/work/complete_work_order_screen.dart';
import '../presentation/technician/work/tech_work_order_details_screen.dart';
import '../presentation/technician/account/technician_home_screen.dart';
import '../presentation/technician/work/add_new_part_screen.dart';
import '../presentation/common/core/layouts/tech_main_layout.dart';
import '../presentation/technician/work/widgets/app_camera_screen.dart';
import 'package:zent_fe/domain/entities/enums/user_roles.dart' show UserRoles;
import 'package:zent_fe/routing/route_names.dart';
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

UserRoles _getRoleFromToken() {
  final token = RbacTokenStore.token;
  if (token == null) return UserRoles.unauthenticated;
  try {
    final parts = token.split('.');
    if (parts.length != 3) return UserRoles.unauthenticated;
    // Base64Url-decode the payload (middle segment) and parse claims.
    final normalized = base64Url.normalize(parts[1]);
    final decoded = utf8.decode(base64Url.decode(normalized));
    final claims = jsonDecode(decoded) as Map<String, dynamic>;
    return switch (claims['role'] as String?) {
      'admin' => UserRoles.admin,
      'technician' => UserRoles.technician,
      'customer' => UserRoles.customer,
      _ => UserRoles.unauthenticated,
    };
  } catch (_) {
    return UserRoles.unauthenticated;
  }
}

const _publicPrefixes = [Routes.splash, Routes.onBoarding, Routes.login];

// ignore: unused_element
String? _rbacRedirect(BuildContext context, GoRouterState state) {
  final location = state.matchedLocation;
  final role = _getRoleFromToken();

  final isPublic = _publicPrefixes.any(
    (p) => location == p || location.startsWith('$p/'),
  );

  // ── Unauthenticated ─────────────────────────────────────────────────────
  if (role == UserRoles.unauthenticated) {
    // Allow public routes; everything else goes to login.
    return isPublic ? null : Routes.login;
  }

  // ── Authenticated on a public / auth route ───────────────────────────────
  // Redirect straight to the role's home screen.
  if (isPublic) {
    return switch (role) {
      UserRoles.admin => Routes.adminDashboard,
      UserRoles.technician => Routes.techHome,
      UserRoles.customer => Routes.customerServices,
      UserRoles.unauthenticated => null,
    };
  }

  // ── Guard role-specific route sections ──────────────────────────────────
  final isAdminRoute = location.startsWith('/admin');
  final isTechRoute = location.startsWith('/tech');
  final isCustomerRoute = location.startsWith('/customer');

  if (isAdminRoute && role != UserRoles.admin) {
    return switch (role) {
      UserRoles.technician => Routes.techHome,
      UserRoles.customer => Routes.customerServices,
      _ => Routes.login,
    };
  }

  if (isTechRoute && role != UserRoles.technician) {
    return switch (role) {
      UserRoles.admin => Routes.adminDashboard,
      UserRoles.customer => Routes.customerServices,
      _ => Routes.login,
    };
  }

  if (isCustomerRoute && role != UserRoles.customer) {
    return switch (role) {
      UserRoles.admin => Routes.adminDashboard,
      UserRoles.technician => Routes.techHome,
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
  //redirect: _rbacRedirect,
  routes: [
    // Main routes
    GoRoute(
      name: RouteNames.splash,
      path: Routes.splash,
      builder: (context, state) => const AppSplashScreen(),
    ),
    GoRoute(
      name: RouteNames.onBoarding,
      path: Routes.onBoarding,
      builder: (context, state) => const OnBoardingScreen(),
    ),
    GoRoute(
      name: RouteNames.login,
      path: Routes.login,
      builder: (context, state) => const LoginScreen(),
      routes: [
        // Sub routes for password recovery flow
        GoRoute(
          name: RouteNames.forgotPassword,
          path: Routes.forgetPassword,
          builder: (context, state) => const ForgotPasswordScreen(),
          routes: [
            GoRoute(
              name: RouteNames.forgotPasswordVerifyOtp,
              path: Routes.verifyOtp,
              builder: (context, state) => const VerifyOtpScreen(),
              routes: [
                GoRoute(
                  name: RouteNames.resetPassword,
                  path: Routes.resetPassword,
                  builder: (context, state) => const ResetPasswordScreen(),
                  routes: [
                    GoRoute(
                      name: RouteNames.resetSuccessfully,
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
          name: RouteNames.signUp,
          path: Routes.signUp,
          builder: (context, state) =>
              const Scaffold(body: Center(child: Text('Sign Up Screen'))),
          routes: [
            GoRoute(
              name: RouteNames.signUpVerifyOtp,
              path: Routes.verifyOtp,
              builder: (context, state) => const Scaffold(
                body: Center(child: Text('Sign Up Verify OTP Screen')),
              ),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      name: RouteNames.appCamera,
      path: '/app-camera',
      builder: (context, state) {
        final Map<String, dynamic>? extra =
            state.extra as Map<String, dynamic>?;
        final onPhotoCaptured =
            extra?['onPhotoCaptured'] as void Function(String)?;
        return AppCameraScreen(onPhotoCaptured: onPhotoCaptured);
      },
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
              name: RouteNames.adminDashboard,
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
              name: RouteNames.adminReports,
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
              name: RouteNames.adminTeam,
              path: Routes.adminTeam,
              builder: (context, state) =>
                  const Scaffold(body: Center(child: Text('Team Screen'))),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              name: RouteNames.adminMe,
              path: Routes.adminMe,
              builder: (context, state) => const ProfileScreen(),
              routes: [
                GoRoute(
                  name: RouteNames.adminSecuritySettings,
                  path: Routes.adminSecuritySettings,
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) => const SecuritySettingsScreen(),
                ),
                GoRoute(
                  name: RouteNames.adminUserManagement,
                  path: Routes.adminUserManagement,
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) => const UserManagementScreen(),
                  routes: [
                    GoRoute(
                      name: RouteNames.adminChooseRoleCreateAccount,
                      path: Routes.adminChooseRoleCreateAccount,
                      builder: (context, state) => const Scaffold(
                        body: Center(
                          child: Text('Choose Role Create Account Screen'),
                        ),
                      ),
                      routes: [
                        GoRoute(
                          name: RouteNames.adminCreateAccount,
                          path: Routes.adminCreateAccount,
                          builder: (context, state) => const Scaffold(
                            body: Center(child: Text('Create Account Screen')),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                GoRoute(
                  name: RouteNames.adminSystemLog,
                  path: Routes.adminSystemLog,
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
        return TechMainLayout(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              name: RouteNames.techHome, //
              path: Routes.techHome,
              builder: (context, state) => const TechnicianHomeScreen(),
              routes: [
                GoRoute(
                  name: RouteNames.techAddNewPart,
                  path: Routes.addNewPart,
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) => const AddNewPartScreen(),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              name: RouteNames.techWorkOrder,
              path: Routes.techWorkOrder,
              builder: (context, state) => const TechWorkOrderScreen(),
              routes: [
                GoRoute(
                  name: RouteNames.techWorkOrderDetails,
                  path: Routes.techWorkOrderDetails,
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) {
                    final workOrderId = state.pathParameters['workOrderId']!;
                    return TechWorkOrderDetailsScreen(workOrderId: workOrderId);
                  },
                ),
                GoRoute(
                  name: RouteNames.techCompleteWorkOrder,
                  path: Routes.completeWorkOrder,
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) {
                    final workOrderId = state.pathParameters['workOrderId']!;
                    return CompleteWorkOrderScreen(workOrderId: workOrderId);
                  },
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              name: RouteNames.techMessage,
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
              name: RouteNames.techMe,
              path: Routes.techMe,
              builder: (context, state) => const TechProfileScreen(),
              routes: [
                GoRoute(
                  name: 'techPersonalInfo',
                  path: Routes.personalInfo,
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) => const TechPersonalInfoScreen(),
                ),
                GoRoute(
                  name: 'techNotifications',
                  path: Routes.notifications,
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) => const TechNotificationsScreen(),
                ),
                GoRoute(
                  name: 'techSecuritySettings',
                  path: Routes.techSecuritySettings,
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) => const TechSecurityScreen(),
                ),
              ],
            ),
          ],
        ),
      ],
    ),

    // Customer top level routes
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return CustomerMainLayout(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              name: RouteNames.customerServices,
              path: Routes.customerServices,
              builder: (context, state) => const CustomerServiceScreen(),
              routes: [
                GoRoute(
                  name: RouteNames.customerMyProducts,
                  path: Routes.myProducts,
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) => const Scaffold(
                    body: Center(child: Text('Customer My Products Screen')),
                  ),
                ),
                GoRoute(
                  name: RouteNames.customerRequestService,
                  path: Routes.requestService,
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) => const Scaffold(
                    body: Center(
                      child: Text('Customer Request Service Screen'),
                    ),
                  ),
                ),
                GoRoute(
                  name: RouteNames.customerActiveRepairs,
                  path: Routes.activeRepairs,
                  parentNavigatorKey: _rootNavigatorKey,
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
              name: RouteNames.customerMessages,
              path: Routes.customerMessages,
              builder: (context, state) => const CustomerChatScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              name: RouteNames.customerMe,
              path: Routes.customerMe,
              builder: (context, state) => const CustomerProfileScreen(),
              routes: [
                GoRoute(
                  name: RouteNames.customerPersonalInfo,
                  path: Routes.personalInfo,
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) =>
                      const CustomerPersonalInfoScreen(),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);
