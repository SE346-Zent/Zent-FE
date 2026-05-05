import 'package:flutter/material.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/presentation/common/core/themes/boxshadow.dart';

class RecentCompletedList extends StatelessWidget {
  final List<dynamic> recentCompleted; // Or specific type

  const RecentCompletedList({super.key, required this.recentCompleted});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimens.boraMd),
        boxShadow: [BoxShadowStyles.subtle],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.spaceMd,
              vertical: AppDimens.spaceSm,
            ),
            child: Text('Recent Completed', style: TextStyles.middle),
          ),
          const Divider(height: 1, color: AppColors.secondary50),

          // List item
          Column(
            children: [
              for (int i = 0; i < recentCompleted.length; i++) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimens.spaceMd,
                    vertical: AppDimens.spaceSm,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            recentCompleted[i].title,
                            style: TextStyles.bodyLarge.copyWith(
                              color: AppColors.secondary500,
                            ),
                          ),
                          Text(
                            recentCompleted[i].woNumber,
                            style: TextStyles.label.copyWith(
                              color: AppColors.secondary300,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        recentCompleted[i].date,
                        style: TextStyles.label.copyWith(
                          color: AppColors.secondary500,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                if (i < recentCompleted.length - 1)
                  const Divider(height: 1, color: AppColors.secondary50),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
