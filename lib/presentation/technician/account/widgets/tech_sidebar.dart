import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/presentation/common/core/app_assets.dart';
import 'package:zent_fe/routing/route_names.dart';
import 'sidebar_menu_item.dart';

import 'package:zent_fe/di/injection_container.dart';
import 'package:zent_fe/domain/usecases/auth/logout_usecase.dart';
import 'package:zent_fe/routing/routes.dart';

class TechSidebar extends StatelessWidget {
  final String userName;
  final String employeeId;
  final String appVersion;

  const TechSidebar({
    super.key,
    required this.userName,
    required this.employeeId,
    this.appVersion = "Zent v1.0.0",
  });

  Future<void> _onLogoutPressed(BuildContext context) async {
    try {
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
                        employeeId,
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
                      title: "QR Code Scanner",
                      icon: const Icon(
                        Icons.qr_code_scanner,
                        color: AppColors.surface100,
                      ),
                      isActive: true,
                      onTap: () {
                        Navigator.pop(context); // Close the drawer first
                        context.pushNamed(
                          RouteNames.qrScanner,
                          extra: {
                            'onScanned': (String result) {
                              debugPrint('Sidebar QR Scanned: $result');
                            },
                          },
                        );
                      },
                    ),

                    SidebarMenuItem(
                      title: "Part Search",
                      icon: const Icon(
                        Icons.inventory_2_outlined,
                        color: AppColors.primary500,
                      ),
                      isActive: false,
                      onTap: () {
                        Navigator.pop(context);
                        context.goNamed(RouteNames.techPartSearch);
                      },
                    ),
                    SidebarMenuItem(
                      title: "Work Order History",
                      icon: const Icon(
                        Icons.history,
                        color: AppColors.primary500,
                      ),
                      isActive: false,
                      onTap: () {
                        Navigator.pop(context);
                        context.goNamed(RouteNames.techWorkOrderHistory);
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
