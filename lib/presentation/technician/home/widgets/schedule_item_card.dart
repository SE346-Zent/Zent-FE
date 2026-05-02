import 'package:flutter/material.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/presentation/common/core/themes/boxshadow.dart';
import '../viewmodels/technician_home_viewmodel.dart';

class ScheduleItemCard extends StatelessWidget {
  final TechScheduleItem item;
  final VoidCallback onTap;

  const ScheduleItemCard({super.key, required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 364.0,
      height: 76.0,
      margin: const EdgeInsets.only(bottom: AppDimens.spaceSm),
      decoration: BoxDecoration(
        color: AppColors.surface100,
        borderRadius: BorderRadius.circular(AppDimens.boraSm),
        boxShadow: [BoxShadowStyles.subtle],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppDimens.boraSm),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceMd),
            child: Row(
              children: [
                // Left Block (Time)
                SizedBox(
                  width: 50.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        item.time,
                        style: TextStyles.middle.copyWith(
                          color: AppColors.secondary500,
                        ),
                      ),
                      Text(
                        item.ampm,
                        style: TextStyles.label.copyWith(
                          color: AppColors.secondary300,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppDimens.spaceSm),
                // Divider
                Container(
                  width: 1.0,
                  height: 40.0,
                  color: AppColors.secondary100,
                ),
                const SizedBox(width: AppDimens.spaceSm),
                // Center Block (Details)
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: TextStyles.title.copyWith(
                          color: AppColors.primary500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2.0),
                      Text(
                        item.address,
                        style: TextStyles.label.copyWith(
                          color: AppColors.secondary400,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppDimens.spaceSm),
                // Trailing
                const Icon(Icons.chevron_right, color: AppColors.secondary300),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
