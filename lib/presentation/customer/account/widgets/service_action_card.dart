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
      margin: const EdgeInsets.symmetric(
        horizontal: AppDimens.spaceMd,
        vertical: AppDimens.spaceSm,
      ),
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
            padding: const EdgeInsets.all(AppDimens.spaceMd),
            child: Row(
              children: [
                Container(
                  width: 50.0,
                  height: 50.0,
                  decoration: BoxDecoration(
                    color: AppColors.tertiary50,
                    borderRadius: BorderRadius.circular(AppDimens.boraSm),
                  ),
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 32.0,
                    height: 32.0,
                    child: Icon(
                      iconData,
                      color: AppColors.tertiary500,
                      size: 28.0, // Assuming Visual approximation for 32x32 bounding box
                    ),
                  ),
                ),
                const SizedBox(width: AppDimens.spaceMd),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyles.title.copyWith(color: AppColors.secondary500),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        subtitle,
                        style: TextStyles.bodyLarge.copyWith(color: AppColors.secondary500),
                      ),
                    ],
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
