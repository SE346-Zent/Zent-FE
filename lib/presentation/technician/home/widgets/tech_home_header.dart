import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zent_fe/routing/route_names.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:provider/provider.dart';
import 'package:zent_fe/presentation/common/notifications/viewmodels/notifications_viewmodel.dart';
import 'package:zent_fe/presentation/common/core/ui/user_avatar.dart';

class TechHomeHeader extends StatelessWidget {
  final String userName;
  final VoidCallback onMenuTapped;
  final VoidCallback onProfileTapped;

  const TechHomeHeader({
    super.key,
    required this.userName,
    required this.onMenuTapped,
    required this.onProfileTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top Toolbar
        Container(
          height: 60.0,
          color: AppColors.primary500,
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceMd),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: onMenuTapped,
                    behavior: HitTestBehavior.opaque,
                    child: const Icon(
                      Icons.menu,
                      color: AppColors.surface100,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Text(
                    'Zent',
                    style: TextStyles.headline.copyWith(
                      color: AppColors.surface100,
                    ),
                  ),
                ],
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
                              context.pushNamed(RouteNames.techNotifications);
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
                  const SizedBox(width: AppDimens.spaceSm),
                  GestureDetector(
                    onTap: onProfileTapped,
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 2.0,
                        ),
                      ),
                      child: UserAvatar(name: userName, size: 30),
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
              Text(
                "Good morning, $userName",
                style: TextStyles.label.copyWith(color: AppColors.secondary300),
              ),
              const SizedBox(height: AppDimens.spaceXs),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: "Welcome to ",
                      style: TextStyles.headline.copyWith(
                        color: AppColors.primary500,
                      ),
                    ),
                    TextSpan(
                      text: "Zent",
                      style: TextStyles.headline.copyWith(
                        color: AppColors.tertiary500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppDimens.spaceLg),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Today's Schedule",
                    style: TextStyles.middle.copyWith(
                      color: AppColors.primary400,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      debugPrint("action triggered: View All");
                    },
                    child: Text(
                      "View All",
                      style: TextStyles.label.copyWith(
                        color: AppColors.tertiary500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
