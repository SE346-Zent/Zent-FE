import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../di/injection_container.dart'; // 🚀 Nhúng DI vào để gọi Local Datasource
import '../data/datasources/local/auth_local_datasource.dart'; // 🚀 Import đúng Datasource chuẩn

// ... (Giữ nguyên các dòng import màn hình của ông ở đây) ...
import '../presentation/common/intro/on_boarding_screen.dart';
import '../presentation/common/intro/splash_screen.dart';
import '../presentation/common/auth/login/login_screen.dart';
import '../presentation/common/auth/login/forgot_password_screen.dart';
import '../presentation/common/auth/login/verify_forgot_otp_screen.dart';
import '../presentation/common/auth/register/verify_otp_screen.dart';
import '../presentation/common/auth/login/reset_password_screen.dart';
import '../presentation/common/auth/login/reset_successfully_screen.dart';
import '../presentation/common/auth/register/register_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../presentation/admin/account/profile_screen.dart';
import '../presentation/admin/account/security_settings_screen.dart';
import '../presentation/admin/account/user_management_screen.dart';
import '../presentation/admin/account/choose_role_screen.dart';
import '../presentation/admin/account/create_account_screen.dart';
import '../presentation/admin/account/personal_info_screen.dart';
import '../presentation/admin/work/admin_dashboard_screen.dart';
import '../presentation/admin/work/operational_queue_screen.dart';
import '../presentation/admin/work/work_order_detail_screen.dart';
import '../presentation/admin/work/assigned_work_order_detail_screen.dart';
import '../presentation/admin/work/rejected_work_orders_screen.dart';
import '../presentation/admin/work/rejection_detail_screen.dart';
import '../presentation/admin/work/view_schedule_screen.dart';
import '../presentation/admin/work/reassign_work_order_screen.dart';
import '../presentation/admin/work/admin_reports_screen.dart';
import '../presentation/admin/account/part_requests_screen.dart';
import '../presentation/admin/account/inventory_assets_screen.dart';
import '../presentation/admin/account/detail_request_screen.dart';
import '../presentation/admin/work/work_orders_history_screen.dart';
import '../presentation/admin/work/detailed_history_screen.dart';
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
import '../presentation/customer/work/edit_work_order_screen.dart';
import '../presentation/customer/work/customer_work_order_details_screen.dart';
import '../presentation/customer/work/active_repairs_screen.dart';
import '../presentation/customer/work/customer_cancel_work_order_screen.dart';
import '../presentation/customer/work/device_registration_screen.dart';
import '../presentation/customer/work/parts_screen.dart';
import '../presentation/common/core/layouts/admin_main_layout.dart';
import '../presentation/common/core/layouts/customer_main_layout.dart';
import '../presentation/technician/account/tech_profile_screen.dart';
import '../presentation/technician/account/personal_info_screen.dart';
import '../presentation/technician/account/security_screen.dart';
import '../presentation/common/notifications/notifications_list_screen.dart';
import '../presentation/technician/work/tech_work_order_screen.dart';
import '../presentation/technician/work/complete_work_order_screen.dart';
import '../presentation/technician/work/tech_work_order_details_screen.dart';
import '../presentation/technician/work/tech_detailed_history_screen.dart';
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

Future<UserRoles> _getRoleFromToken() async {
  try {
    final localAuthDs = sl<AuthLocalDataSource>();
    final user = await localAuthDs.getUser();
    return user?.role ?? UserRoles.unauthenticated;
  } catch (e) {
    debugPrint("Get Role Error: $e");
    return UserRoles.unauthenticated;
  }
}

const _publicPrefixes = [Routes.splash, Routes.onBoarding, Routes.login];

Future<String?> _rbacRedirect(BuildContext context, GoRouterState state) async {
  try {
    final location = state.matchedLocation;
    final role = await _getRoleFromToken();
    if (role == UserRoles.admin ||
        role == UserRoles.superAdmin ||
        role == UserRoles.technician) {
      try {
        final settings = await FirebaseMessaging.instance.requestPermission();
        if (settings.authorizationStatus != AuthorizationStatus.authorized) {
          return Routes.login;
        }
      } catch (e) {
        debugPrint(
          "Firebase Messaging permission request failed in redirect: $e",
        );
        // Cứ tiếp tục điều hướng nếu lỗi Firebase cấu hình ở môi trường Release
      }
    }
    final isPublic = _publicPrefixes.any(
      (p) => location == p || location.startsWith('$p/'),
    );

    // ── Unauthenticated ─────────────────────────────────────────────────────
    if (role == UserRoles.unauthenticated) {
      return isPublic ? null : Routes.login;
    }

    // ── Authenticated on a public / auth route ───────────────────────────────
    final isAuthFlow =
        location.contains(Routes.verifyOtp) ||
        location.contains(Routes.resetPassword) ||
        location.contains(Routes.resetSuccessfully);

    if (isPublic && !isAuthFlow) {
      return switch (role) {
        UserRoles.superAdmin => Routes.adminDashboard,
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

    if (isAdminRoute &&
        role != UserRoles.admin &&
        role != UserRoles.superAdmin) {
      return switch (role) {
        UserRoles.technician => Routes.techHome,
        UserRoles.customer => Routes.customerServices,
        _ => Routes.login,
      };
    }

    if (isTechRoute &&
        role != UserRoles.technician &&
        role != UserRoles.superAdmin) {
      return switch (role) {
        UserRoles.admin => Routes.adminDashboard,
        UserRoles.customer => Routes.customerServices,
        _ => Routes.login,
      };
    }

    if (isCustomerRoute &&
        role != UserRoles.customer &&
        role != UserRoles.superAdmin) {
      return switch (role) {
        UserRoles.admin => Routes.adminDashboard,
        UserRoles.technician => Routes.techHome,
        _ => Routes.login,
      };
    }

    return null; // No redirect needed.
  } catch (e, stack) {
    debugPrint("GoRouter RBAC Redirect Exception: $e");
    debugPrint(stack.toString());
    // Trả về Routes.login hoặc null thay vì để sập cả app khi sập GoRouter
    return Routes.login;
  }
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
            bool useRecoveryEmail = false;
            if (extra is String) {
              email = extra;
            } else if (extra is Map<String, dynamic>) {
              email = extra['email'] as String? ?? '';
              useRecoveryEmail = extra['useRecoveryEmail'] as bool? ?? false;
            }
            return VerifyForgotOtpScreen(
              email: email,
              useRecoveryEmail: useRecoveryEmail,
            );
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
                  builder: (context, state) => const NotificationsListScreen(),
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
                  name: RouteNames.adminPartRequests,
                  path: Routes.adminPartRequests,
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) => const PartRequestsScreen(),
                  routes: [
                    GoRoute(
                      name: RouteNames.adminDetailRequest,
                      path: Routes.adminDetailRequest,
                      parentNavigatorKey: _rootNavigatorKey,
                      builder: (context, state) {
                        final partId = state.pathParameters['partId'] ?? '';
                        return DetailRequestScreen(partId: partId);
                      },
                    ),
                  ],
                ),
                GoRoute(
                  name: RouteNames.adminInventoryAssets,
                  path: Routes.adminInventoryAssets,
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) => const InventoryAssetsScreen(),
                ),
                GoRoute(
                  name: RouteNames.adminRejectedWorkOrders,
                  path: Routes.adminRejectedWorkOrders,
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) => const RejectedWorkOrdersScreen(),
                  routes: [
                    GoRoute(
                      name: RouteNames.adminRejectionDetail,
                      path: Routes.adminRejectionDetail,
                      parentNavigatorKey: _rootNavigatorKey,
                      builder: (context, state) {
                        final id = state.pathParameters['id'] ?? '';
                        return RejectionDetailScreen(workOrderId: id);
                      },
                    ),
                  ],
                ),
                GoRoute(
                  name: RouteNames.adminWorkOrderHistory,
                  path: Routes.adminWorkOrderHistory,
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) => const WorkOrdersHistoryScreen(),
                  routes: [
                    GoRoute(
                      name: RouteNames.adminDetailedHistory,
                      path: Routes.adminDetailedHistory,
                      parentNavigatorKey: _rootNavigatorKey,
                      builder: (context, state) {
                        final id = state.pathParameters['workOrderId'] ?? '';
                        return DetailedHistoryScreen(workOrderId: id);
                      },
                    ),
                  ],
                ),
              ],
            ),
            GoRoute(
              name: RouteNames.adminOperationalQueue,
              path: Routes.adminOperationalQueue,
              builder: (context, state) {
                final tabStr = state.uri.queryParameters['tab'];
                final tab = int.tryParse(tabStr ?? '0') ?? 0;
                return OperationalQueueScreen(initialTab: tab);
              },
              routes: [
                GoRoute(
                  name: RouteNames.adminAssignWorkOrder,
                  path: Routes.adminAssignWorkOrder,
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) {
                    final id = state.pathParameters['workOrderId'] ?? '';
                    return AssignWorkOrderScreen(workOrderId: id);
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
              builder: (context, state) => const CustomerChatScreen(),
              routes: [
                GoRoute(
                  name: 'adminDetailedChat',
                  path: 'detailed-chat/:chatId',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) {
                    final chatId = state.pathParameters['chatId']!;
                    final name = state.uri.queryParameters['name'];
                    return DetailedChatScreen(
                      chatId: chatId,
                      partnerName: name,
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
                  name: RouteNames.adminPersonalInfo,
                  path: Routes.personalInfo,
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) => const AdminPersonalInfoScreen(),
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
                  builder: (context, state) {
                    final extra = state.extra as Map<String, dynamic>? ?? {};
                    final workOrderId = extra['workOrderId'] as String? ?? '';
                    final workOrderNumber =
                        extra['workOrderNumber'] as String? ?? '';
                    return AddNewPartScreen(
                      workOrderId: workOrderId,
                      workOrderNumber: workOrderNumber,
                    );
                  },
                ),
                GoRoute(
                  name: RouteNames.techPartSearch,
                  path: Routes.inventorySearch,
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) => const PartSearchScreen(),
                ),
                GoRoute(
                  name: RouteNames.techWorkOrderHistory,
                  path: Routes.techWorkOrderHistory,
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) => const WorkOrdersHistoryScreen(),
                  routes: [
                    GoRoute(
                      name: RouteNames.techDetailedHistory,
                      path: Routes.techDetailedHistory,
                      parentNavigatorKey: _rootNavigatorKey,
                      builder: (context, state) {
                        final id = state.pathParameters['workOrderId'] ?? '';
                        return TechDetailedHistoryScreen(workOrderId: id);
                      },
                    ),
                  ],
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
              builder: (context, state) => const CustomerChatScreen(),
              routes: [
                GoRoute(
                  name: RouteNames.techDetailedChat,
                  path: 'detailed-chat/:chatId',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) {
                    final chatId = state.pathParameters['chatId']!;
                    final name = state.uri.queryParameters['name'];
                    return DetailedChatScreen(
                      chatId: chatId,
                      partnerName: name,
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
                  name: RouteNames.techNotifications,
                  path: Routes.notifications,
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) => const NotificationsListScreen(),
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
                  builder: (context, state) {
                    final workOrderId = state.uri.queryParameters['workOrderId'];
                    return ActiveRepairsScreen(workOrderId: workOrderId);
                  },
                ),
                GoRoute(
                  name: RouteNames.customerWorkOrderHistory,
                  path: Routes.customerWorkOrderHistory,
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) => const WorkOrdersHistoryScreen(),
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
                GoRoute(
                  name: RouteNames.customerEditWorkOrder,
                  path: Routes.customerEditWorkOrder,
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) {
                    final workOrderId = state.pathParameters['workOrderId']!;
                    final workOrderNumber =
                        state.pathParameters['workOrderNumber']!;
                    return EditWorkOrderScreen(
                      workOrderId: workOrderId,
                      workOrderNumber: workOrderNumber,
                    );
                  },
                ),
                GoRoute(
                  name: RouteNames.customerWorkOrderDetails,
                  path: Routes.customerWorkOrderDetails,
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) {
                    final workOrderId = state.pathParameters['workOrderId']!;
                    return CustomerWorkOrderDetailsScreen(
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
                    final name = state.uri.queryParameters['name'];
                    return DetailedChatScreen(
                      chatId: chatId,
                      partnerName: name,
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
                GoRoute(
                  name: RouteNames.customerNotificationsList,
                  path: Routes.customerNotificationsList,
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) => const NotificationsListScreen(),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);
