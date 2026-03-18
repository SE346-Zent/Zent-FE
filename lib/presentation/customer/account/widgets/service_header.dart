import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';

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
                  const Icon(
                    Icons.notifications_none,
                    color: AppColors.surface100,
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
                                image: AssetImage(
                                  "assets/images/OnBoarding1.webp",
                                ), // Fallback mock image
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
