import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../presentation/common/intro/on_boarding_screen.dart';
import '../presentation/common/intro/splash_screen.dart';
import '../presentation/common/auth/login/login_screen.dart';
import '../presentation/common/auth/login/forgot_password_screen.dart';
import '../presentation/common/auth/login/verify_forgot_otp_screen.dart';
import '../presentation/common/auth/register/verify_otp_screen.dart';
import '../presentation/common/auth/login/reset_password_screen.dart';
import '../presentation/common/auth/login/reset_successfully_screen.dart';
import '../presentation/common/auth/register/register_screen.dart';
import '../presentation/admin/account/profile_screen.dart';
import '../presentation/admin/account/security_settings_screen.dart';
import '../presentation/admin/account/user_management_screen.dart';
import '../presentation/admin/account/choose_role_screen.dart';
import '../presentation/admin/account/create_account_screen.dart';
import '../presentation/admin/dashboard/admin_dashboard_screen.dart';
import '../presentation/admin/dashboard/admin_notifications_screen.dart';
import '../presentation/admin/queue/operational_queue_screen.dart';
import '../presentation/admin/queue/work_order_detail_screen.dart';
import '../presentation/admin/queue/assigned_work_order_detail_screen.dart';
import '../presentation/admin/queue/view_schedule_screen.dart';
import '../presentation/admin/queue/reassign_work_order_screen.dart';
import '../presentation/admin/reports/admin_reports_screen.dart';
import '../presentation/admin/account/part_requests_screen.dart';
import '../presentation/admin/account/inventory_assets_screen.dart';
import '../presentation/admin/account/detail_request_screen.dart';
import '../presentation/customer/work/service_screen.dart';
import '../presentation/customer/account/chat_screen.dart';
import '../presentation/customer/account/profile_screen.dart';
import '../presentation/customer/account/personal_info_screen.dart';
import '../presentation/customer/account/security_screen.dart';
import '../presentation/customer/account/notifications_screen.dart';
import '../presentation/customer/account/detailed_chat_screen.dart';
import '../presentation/customer/work/my_products_screen.dart';
import '../presentation/customer/work/my_detailed_product_screen.dart';
import '../presentation/customer/work/request_service_screen.dart';
import '../presentation/customer/work/active_repairs_screen.dart';
import '../presentation/customer/work/customer_cancel_work_order_screen.dart';
import '../presentation/customer/work/device_registration_screen.dart';
import '../presentation/customer/work/parts_screen.dart';
import '../presentation/common/core/layouts/admin_main_layout.dart';
import '../presentation/common/core/layouts/customer_main_layout.dart';
import '../presentation/technician/account/tech_profile_screen.dart';
import '../presentation/technician/account/personal_info_screen.dart';
import '../presentation/technician/account/notifications_screen.dart';
import '../presentation/technician/account/security_screen.dart';
import '../presentation/technician/work/tech_work_order_screen.dart';
import '../presentation/technician/work/complete_work_order_screen.dart';
import '../presentation/technician/work/tech_work_order_details_screen.dart';
import '../presentation/technician/work/tech_pause_work_order_screen.dart';
import '../presentation/technician/work/tech_reject_work_order_screen.dart';
import '../presentation/technician/home/technician_home_screen.dart';
import '../presentation/technician/work/add_new_part_screen.dart';
import '../presentation/common/core/layouts/tech_main_layout.dart';
import '../presentation/technician/work/widgets/app_camera_screen.dart';
import '../presentation/common/core/scanner/app_qr_scanner_screen.dart';
import '../presentation/technician/work/part_search_screen.dart';
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
        GoRoute(
          name: RouteNames.signUp,
          path: Routes.signUp,
          builder: (context, state) => const RegisterScreen(),
          routes: [
            GoRoute(
              name: RouteNames.signUpVerifyOtp,
              path: Routes.verifyOtp,
              builder: (context, state) {
                final extra = state.extra as Map<String, dynamic>? ?? {};
                final email = extra['email'] as String? ?? '';
                final isRegistration =
                    extra['isRegistration'] as bool? ?? false;
                return VerifyOtpScreen(
                  email: email,
                  isRegistration: isRegistration,
                );
              },
            ),
          ],
        ),
        GoRoute(
          name: RouteNames.forgotPassword,
          path: Routes.forgetPassword,
          builder: (context, state) => const ForgotPasswordScreen(),
        ),
        GoRoute(
          name: RouteNames.forgotPasswordVerifyOtp,
          path: '${Routes.forgetPassword}/${Routes.verifyOtp}',
          builder: (context, state) {
            final extra = state.extra;
            String email = '';
            if (extra is String) {
              email = extra;
            } else if (extra is Map<String, dynamic>) {
              email = extra['email'] as String? ?? '';
            }
            return VerifyForgotOtpScreen(email: email);
          },
        ),
        GoRoute(
          name: RouteNames.resetPassword,
          path: '${Routes.forgetPassword}/${Routes.resetPassword}',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>? ?? {};
            final email = extra['email'] as String? ?? '';
            final token = extra['token'] as String? ?? '';
            return ResetPasswordScreen(email: email, token: token);
          },
        ),
        GoRoute(
          name: RouteNames.resetSuccessfully,
          path: '${Routes.forgetPassword}/${Routes.resetSuccessfully}',
          builder: (context, state) => const ResetSuccessfullyScreen(),
        ),
      ],
    ),
    GoRoute(
      name: RouteNames.appCamera,
      path: Routes.appCamera,
      builder: (context, state) {
        final Map<String, dynamic>? extra =
            state.extra as Map<String, dynamic>?;
        final onPhotoCaptured =
            extra?['onPhotoCaptured'] as void Function(String)?;
        return AppCameraScreen(onPhotoCaptured: onPhotoCaptured);
      },
    ),
    GoRoute(
      name: RouteNames.qrScanner,
      path: Routes.qrScanner,
      builder: (context, state) {
        final Map<String, dynamic>? extra =
            state.extra as Map<String, dynamic>?;
        final onScanned = extra?['onScanned'] as void Function(String)?;
        return AppQrScannerScreen(onScanned: onScanned);
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
              builder: (context, state) => const AdminDashboardScreen(),
              routes: [
                GoRoute(
                  name: RouteNames.adminNotifications,
                  path: Routes.adminNotifications,
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) => const AdminNotificationsScreen(),
                ),
              ],
            ),
            GoRoute(
              name: RouteNames.adminOperationalQueue,
              path: Routes.adminOperationalQueue,
              builder: (context, state) => const OperationalQueueScreen(),
              routes: [
                GoRoute(
                  name: RouteNames.adminWorkOrderDetails,
                  path: Routes.adminWorkOrderDetails,
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) {
                    final id = state.pathParameters['workOrderId'] ?? '';
                    return WorkOrderDetailScreen(workOrderId: id);
                  },
                ),
                GoRoute(
                  name: RouteNames.adminAssignedWorkOrderDetails,
                  path: Routes.adminAssignedWorkOrderDetails,
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) {
                    final id = state.pathParameters['workOrderId'] ?? '';
                    return AssignedWorkOrderDetailScreen(workOrderId: id);
                  },
                ),
                GoRoute(
                  name: RouteNames.adminViewSchedule,
                  path: Routes.adminViewSchedule,
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) {
                    final id = state.pathParameters['techId'] ?? '';
                    return ViewScheduleScreen(techId: id);
                  },
                ),
                GoRoute(
                  name: RouteNames.adminReassignWorkOrder,
                  path: Routes.adminReassignWorkOrder,
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) {
                    final id = state.pathParameters['workOrderId'] ?? '';
                    return ReassignWorkOrderScreen(workOrderId: id);
                  },
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              name: RouteNames.adminReports,
              path: Routes.adminReports,
              builder: (context, state) => const AdminReportsScreen(),
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
                      parentNavigatorKey: _rootNavigatorKey,
                      builder: (context, state) => const ChooseRoleScreen(),
                      routes: [
                        GoRoute(
                          name: RouteNames.adminCreateAccount,
                          path: Routes.adminCreateAccount,
                          parentNavigatorKey: _rootNavigatorKey,
                          builder: (context, state) {
                            final extra =
                                state.extra as Map<String, dynamic>? ?? {};
                            final role =
                                extra['role'] as String? ?? 'Technicians';
                            return CreateAccountScreen(role: role);
                          },
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
                GoRoute(
                  name: RouteNames.adminPartRequests,
                  path: Routes.adminPartRequests,
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) => const PartRequestsScreen(),
                  routes: [
                    GoRoute(
                      name: RouteNames.adminDetailRequest,
                      path: Routes.adminDetailRequest,
                      parentNavigatorKey: _rootNavigatorKey,
                      builder: (context, state) => const DetailRequestScreen(),
                    ),
                  ],
                ),
                GoRoute(
                  name: RouteNames.adminInventoryAssets,
                  path: Routes.adminInventoryAssets,
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) => const InventoryAssetsScreen(),
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
                GoRoute(
                  name: RouteNames.techPartSearch,
                  path: Routes.inventorySearch,
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) => const PartSearchScreen(),
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
                  name: RouteNames.techPauseWorkOrder,
                  path: Routes.techPauseWorkOrder,
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) {
                    final workOrderId = state.pathParameters['workOrderId']!;
                    return TechPauseWorkOrderScreen(workOrderId: workOrderId);
                  },
                ),
                GoRoute(
                  name: RouteNames.techRejectWorkOrder,
                  path: Routes.techRejectWorkOrder,
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) {
                    final workOrderId = state.pathParameters['workOrderId']!;
                    return TechRejectWorkOrderScreen(workOrderId: workOrderId);
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
                  builder: (context, state) => const MyProductsScreen(),
                  routes: [
                    GoRoute(
                      name: RouteNames.customerDeviceRegistration,
                      path: 'register-device',
                      parentNavigatorKey: _rootNavigatorKey,
                      builder: (context, state) =>
                          const DeviceRegistrationScreen(),
                    ),
                    GoRoute(
                      name: RouteNames.customerDetailedProduct,
                      path: Routes.customerDetailedProduct,
                      parentNavigatorKey: _rootNavigatorKey,
                      builder: (context, state) {
                        final serialNumber =
                            state.pathParameters['serialNumber']!;
                        return MyDetailedProductScreen(
                          serialNumber: serialNumber,
                        );
                      },
                      routes: [
                        GoRoute(
                          name: RouteNames.customerDetailedProductParts,
                          path: 'parts',
                          parentNavigatorKey: _rootNavigatorKey,
                          builder: (context, state) {
                            final serialNumber =
                                state.pathParameters['serialNumber']!;
                            return PartsScreen(serialNumber: serialNumber);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                GoRoute(
                  name: RouteNames.customerRequestService,
                  path: Routes.requestService,
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) => const RequestServiceScreen(),
                ),
                GoRoute(
                  name: RouteNames.customerActiveRepairs,
                  path: Routes.activeRepairs,
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) => const ActiveRepairsScreen(),
                ),
                GoRoute(
                  name: RouteNames.customerCancelWorkOrder,
                  path: Routes.customerCancelWorkOrder,
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) {
                    final workOrderId = state.pathParameters['workOrderId']!;
                    return CustomerCancelWorkOrderScreen(
                      workOrderId: workOrderId,
                    );
                  },
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
              routes: [
                GoRoute(
                  name: RouteNames.customerDetailedChat,
                  path: 'detailed-chat/:chatId',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) {
                    final chatId = state.pathParameters['chatId']!;
                    return DetailedChatScreen(chatId: chatId);
                  },
                ),
              ],
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
                GoRoute(
                  name: RouteNames.customerSecuritySettings,
                  path: Routes.customerSecuritySettings,
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) => const CustomerSecurityScreen(),
                ),
                GoRoute(
                  name: RouteNames.customerNotifications,
                  path: Routes.customerNotifications,
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) =>
                      const CustomerNotificationsScreen(),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);
