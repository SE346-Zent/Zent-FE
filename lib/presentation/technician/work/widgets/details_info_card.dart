import 'package:flutter/material.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/presentation/common/core/themes/boxshadow.dart';

class DetailsInfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;

  const DetailsInfoCard({
    super.key,
    required this.icon,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimens.spaceMd),
      decoration: BoxDecoration(
        color: AppColors.surface100,
        borderRadius: BorderRadius.circular(AppDimens.boraSm),
        boxShadow: [BoxShadowStyles.raised],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.tertiary500, size: 22),
              const SizedBox(width: AppDimens.spaceSm),
              Text(
                title,
                style: TextStyles.middle.copyWith(color: AppColors.primary500),
              ),
            ],
          ),
          const SizedBox(height: AppDimens.spaceMd),
          IntrinsicHeight(
            child: Row(
              children: [
                Container(width: 6.0, color: AppColors.tertiary500),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: AppDimens.spaceMd),
                    child: Text(
                      content.isNotEmpty ? content : 'N/A',
                      style: TextStyles.bodyLarge.copyWith(
                        color: AppColors.primary500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
