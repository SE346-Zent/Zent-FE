import 'package:flutter/material.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/presentation/common/core/ui/avatar.dart';

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
                  const Icon(
                    Icons.notifications_none,
                    color: AppColors.surface100,
                  ),
                  const SizedBox(width: AppDimens.spaceSm),
                  GestureDetector(
                    onTap: onProfileTapped,
                    child: SizedBox(
                      width: 30,
                      height: 30,
                      child: FittedBox(
                        child: Avatar(name: userName, showEditIcon: false),
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
