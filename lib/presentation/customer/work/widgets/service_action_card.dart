import 'package:flutter/material.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/presentation/common/core/themes/boxshadow.dart';

class ServiceActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData iconData;
  final VoidCallback onTap;

  const ServiceActionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.iconData,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppDimens.spaceMd),
      constraints: const BoxConstraints(minHeight: 88.0),
      decoration: BoxDecoration(
        color: AppColors.surface100,
        borderRadius: BorderRadius.circular(AppDimens.boraMd),
        boxShadow: [BoxShadowStyles.raised],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppDimens.boraMd),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.spaceMd,
              vertical: 8.0, // Reduced from 12.0
            ),
            child: Row(
              children: [
                Container(
                  width: 60.0,
                  height: 60.0,
                  decoration: BoxDecoration(
                    color: AppColors.tertiary50,
                    borderRadius: BorderRadius.circular(AppDimens.boraSm),
                  ),
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 40.0,
                    height: 40.0,
                    child: Icon(
                      iconData,
                      color: AppColors.tertiary500,
                      size: 40.0,
                    ),
                  ),
                ),
                const SizedBox(width: AppDimens.spaceMd),
                Expanded(
                  child: Container(
                    constraints: const BoxConstraints(minHeight: 60.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyles.title.copyWith(
                            color: AppColors.secondary500,
                          ),
                        ),
                        const SizedBox(height: 2.0),
                        Text(
                          subtitle,
                          style: TextStyles.bodyLarge.copyWith(
                            color: AppColors.secondary500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: AppDimens.spaceSm),
                RotatedBox(
                  quarterTurns: 0,
                  child: SizedBox(
                    width: 15.0,
                    height: 15.0,
                    child: Icon(
                      Icons.chevron_right,
                      color: AppColors.secondary400,
                      size: 20.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
