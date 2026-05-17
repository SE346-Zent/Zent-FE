import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/routing/route_names.dart';
import 'package:provider/provider.dart';
import 'package:zent_fe/presentation/common/notifications/viewmodels/notifications_viewmodel.dart';
import 'package:zent_fe/presentation/common/core/app_assets.dart'
    show AppAssets;

class ServiceHeader extends StatelessWidget {
  final String userName;
  final String? avatarUrl;

  const ServiceHeader({super.key, required this.userName, this.avatarUrl});

  void _onAvatarTap(BuildContext context) {
    context.goNamed('customerMe');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top Toolbar
        Container(
          height: 60.0,
          color: AppColors.primary500, // Zent dark blue header from the image
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceMd),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Zent',
                style: TextStyles.headline.copyWith(
                  color: AppColors.surface100,
                ),
              ),
              Row(
                children: [
                  Consumer<NotificationsViewModel>(
                    builder: (context, viewModel, _) {
                      final hasUnread = viewModel.unreadCount > 0;
                      return Stack(
                        children: [
                          GestureDetector(
                            onTap: () {
                              context.pushNamed(
                                RouteNames.customerNotifications,
                              );
                            },
                            child: const Icon(
                              Icons.notifications_none,
                              color: AppColors.surface100,
                            ),
                          ),
                          if (hasUnread)
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: AppColors.tertiary500,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.primary500,
                                    width: 1.5,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(width: AppDimens.spaceMd),
                  InkWell(
                    onTap: () => _onAvatarTap(context),
                    child: Container(
                      width: 32.0,
                      height: 32.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.surface100,
                        border: Border.all(
                          color: AppColors.surface100,
                          width: 1.5,
                        ),
                        image: avatarUrl != null
                            ? DecorationImage(
                                image: NetworkImage(avatarUrl!),
                                fit: BoxFit.cover,
                              )
                            : const DecorationImage(
                                image: AssetImage(AppAssets.onboarding1),
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Greeting Text
        Padding(
          padding: const EdgeInsets.all(AppDimens.spaceMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: "Good morning!\n",
                      style: TextStyles.title.copyWith(
                        color: AppColors.secondary300,
                      ),
                    ),
                    TextSpan(
                      text: "Welcome back to ",
                      style: TextStyles.headline.copyWith(
                        color: AppColors.primary500, // Dark grey/blue
                      ),
                    ),
                    TextSpan(
                      text: userName,
                      style: TextStyles.headline.copyWith(
                        color: AppColors.tertiary500, // Highlight blue
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppDimens.spaceLg),
              Text(
                "Your available services",
                style: TextStyles.middle.copyWith(color: AppColors.primary500),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
