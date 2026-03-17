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
import './routes.dart' show Routes;

// ---------------------------------------------------------------------------

// ---------------------------------------------------------------------------

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: Routes.customerMe,
  //redirect: _rbacRedirect,
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
        return CustomerMainLayout(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              name: 'customerServices',
              path: Routes.customerServices,
              builder: (context, state) => const CustomerServiceScreen(),
              routes: [
                GoRoute(
                  name: 'customerMyProducts',
                  path: Routes.myProducts,
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) => const Scaffold(
                    body: Center(child: Text('Customer My Products Screen')),
                  ),
                ),
                GoRoute(
                  name: 'customerRequestService',
                  path: Routes.requestService,
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) => const Scaffold(
                    body: Center(
                      child: Text('Customer Request Service Screen'),
                    ),
                  ),
                ),
                GoRoute(
                  name: 'customerActiveRepairs',
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
              name: 'customerMessages',
              path: Routes.customerMessages,
              builder: (context, state) => const CustomerChatScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              name: 'customerMe',
              path: Routes.customerMe,
              builder: (context, state) => const CustomerProfileScreen(),
              routes: [
                GoRoute(
                  name: 'customerPersonalInfo',
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
