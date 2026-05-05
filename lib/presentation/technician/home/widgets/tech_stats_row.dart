import 'package:flutter/material.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/presentation/common/core/themes/boxshadow.dart';

class TechStatsRow extends StatelessWidget {
  final int jobsDone;
  final double averageRating;

  const TechStatsRow({
    super.key,
    required this.jobsDone,
    required this.averageRating,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceMd),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // JOBS DONE Box
          Expanded(
            child: Container(
              height: 80.0,
              decoration: BoxDecoration(
                color: AppColors.primary500,
                borderRadius: BorderRadius.circular(AppDimens.boraSm),
              ),
              padding: const EdgeInsets.all(AppDimens.spaceSm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "JOBS DONE",
                    style: TextStyles.bodyMedium.copyWith(
                      color: AppColors.secondary200,
                    ),
                  ),
                  Text(
                    "$jobsDone",
                    style: TextStyles.display.copyWith(
                      color: AppColors.surface100,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: AppDimens.spaceMd),
          // AVG. RATING Box
          Expanded(
            child: Container(
              height: 80.0,
              decoration: BoxDecoration(
                color: AppColors.surface100, // White
                borderRadius: BorderRadius.circular(AppDimens.boraSm),
                border: Border.all(color: AppColors.surface300),
                boxShadow: [BoxShadowStyles.subtle],
              ),
              padding: const EdgeInsets.all(AppDimens.spaceSm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "AVG. RATING",
                    style: TextStyles.bodyMedium.copyWith(
                      color: AppColors.primary300,
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        averageRating.toStringAsFixed(1),
                        style: TextStyles.display.copyWith(
                          color: AppColors.primary500,
                        ),
                      ),
                      Text(
                        "/5.0",
                        style: TextStyles.title.copyWith(
                          color: AppColors.primary300,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
