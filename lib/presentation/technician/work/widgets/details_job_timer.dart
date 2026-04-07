import 'package:flutter/material.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/presentation/common/core/themes/boxshadow.dart';
import '../view_models/tech_work_order_details_viewmodel.dart';

class DetailsJobTimer extends StatelessWidget {
  final TechWorkOrderDetailsViewModel viewModel;

  const DetailsJobTimer({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Job Timer",
          style: TextStyles.middle.copyWith(color: AppColors.primary500),
        ),
        const SizedBox(height: AppDimens.spaceMd),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildTimerBox(
              viewModel.hours.toString().padLeft(2, '0'),
              "Hours",
              false,
            ),
            _buildTimerBox(
              viewModel.minutes.toString().padLeft(2, '0'),
              "Minutes",
              false,
            ),
            _buildTimerBox(
              viewModel.seconds.toString().padLeft(2, '0'),
              "Seconds",
              true,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTimerBox(String value, String label, bool isLast) {
    return Column(
      children: [
        Container(
          width: 100,
          height: 60,
          decoration: BoxDecoration(
            color: AppColors.surface100,
            borderRadius: BorderRadius.circular(AppDimens.boraXs),
            border: Border.all(
              color: isLast ? AppColors.tertiary500 : AppColors.secondary100,
            ),
            boxShadow: [BoxShadowStyles.subtle],
          ),
          alignment: Alignment.center,
          child: Text(
            value,
            style: TextStyles.headline.copyWith(
              color: isLast ? AppColors.tertiary500 : AppColors.primary500,
            ),
          ),
        ),
        const SizedBox(height: AppDimens.spaceXs),
        Text(
          label,
          style: TextStyles.bodyLarge.copyWith(
            color: isLast ? AppColors.tertiary500 : AppColors.secondary200,
          ),
        ),
      ],
    );
  }
}
