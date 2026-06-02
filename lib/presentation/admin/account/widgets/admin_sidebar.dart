import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/presentation/common/core/app_assets.dart';
import 'package:zent_fe/routing/route_names.dart';
import 'package:zent_fe/routing/routes.dart';
import 'package:zent_fe/di/injection_container.dart';
import 'package:zent_fe/domain/usecases/auth/logout_usecase.dart';
import 'package:zent_fe/presentation/customer/account/viewmodels/detailed_chat_viewmodel.dart';
import 'sidebar_menu_item.dart';

class AdminSidebar extends StatelessWidget {
  final String userName;
  final String adminId;
  final String appVersion;

  const AdminSidebar({
    super.key,
    required this.userName,
    required this.adminId,
    this.appVersion = "Zent v1.0.0",
  });

  Future<void> _onLogoutPressed(BuildContext context) async {
    try {
      DetailedChatViewModel.clearCache();
      await sl<LogoutUseCase>().execute();
    } catch (e) {
      debugPrint("Error during logout: $e");
    } finally {
      if (context.mounted) {
        context.go(Routes.login);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.surface100,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Sidebar Header
            Container(
              height: 60.0,
              color: AppColors.primary500,
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.spaceMd,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName,
                        style: TextStyles.title.copyWith(
                          color: AppColors.surface100,
                        ),
                      ),
                      Text(
                        adminId,
                        style: TextStyles.bodyMedium.copyWith(
                          color: AppColors.secondary100,
                        ),
                      ),
                    ],
                  ),
                  Image.asset(
                    AppAssets.whiteLogo,
                    width: 25.0,
                    height: 30.0,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppDimens.spaceMd),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SidebarMenuItem(
                      title: "Add Part Request",
                      icon: const Icon(
                        Icons.local_offer_outlined,
                        color: Colors.black,
                        size: 23.0,
                      ),
                      isActive: false,
                      onTap: () {
                        Navigator.pop(context);
                        context.goNamed(RouteNames.adminPartRequests);
                      },
                    ),
                    SidebarMenuItem(
                      title: "User Management",
                      icon: const Icon(
                        Icons.person_add_alt_1_outlined,
                        color: Colors.black,
                        size: 23.0,
                      ),
                      isActive: false,
                      onTap: () {
                        Navigator.pop(context);
                        context.goNamed(RouteNames.adminUserManagement);
                      },
                    ),
                    SidebarMenuItem(
                      title: "Rejected Work Orders",
                      icon: Stack(
                        alignment: Alignment.center,
                        children: [
                          const Icon(
                            Icons.assignment_outlined,
                            color: Colors.black,
                            size: 23.0,
                          ),
                          Container(width: 10, height: 10, color: Colors.white),
                          const Icon(
                            Icons.close,
                            color: Colors.black,
                            size: 14.0,
                          ),
                        ],
                      ),
                      isActive: false,
                      onTap: () {
                        Navigator.pop(context);
                        context.goNamed(RouteNames.adminRejectedWorkOrders);
                      },
                    ),
                    SidebarMenuItem(
                      title: "Work Order History",
                      icon: const Icon(
                        Icons.history,
                        color: Colors.black,
                        size: 23.0,
                      ),
                      isActive: false,
                      onTap: () {
                        Navigator.pop(context);
                        context.goNamed(RouteNames.adminWorkOrderHistory);
                      },
                    ),
                    const SizedBox(height: AppDimens.spaceSm),
                    Container(height: 1.0, color: AppColors.secondary50),
                    const SizedBox(height: AppDimens.spaceMd),
                    // Logout Action
                    InkWell(
                      onTap: () => _onLogoutPressed(context),
                      borderRadius: BorderRadius.circular(AppDimens.boraSm),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimens.spaceMd,
                          vertical: AppDimens.spaceSm,
                        ),
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 26.0,
                              height: 26.0,
                              child: Center(
                                child: Icon(
                                  Icons.logout,
                                  color: AppColors.error500,
                                ),
                              ),
                            ),
                            const SizedBox(width: AppDimens.spaceMd),
                            Text(
                              "Logout",
                              style: TextStyles.title.copyWith(
                                color: AppColors.error500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Footer Section
            Padding(
              padding: const EdgeInsets.only(bottom: AppDimens.spaceLg),
              child: Text(
                appVersion,
                style: TextStyles.middle.copyWith(
                  color: AppColors.secondary200,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
