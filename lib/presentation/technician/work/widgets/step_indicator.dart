import 'package:flutter/material.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';

class StepIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const StepIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Step ${currentStep + 1} of $totalSteps",
          style: TextStyles.label.copyWith(color: AppColors.tertiary500),
        ),
        const SizedBox(height: AppDimens.spaceSm),
        Row(
          children: List.generate(totalSteps, (index) {
            final isActive = index <= currentStep;
            return Expanded(
              child: Container(
                margin: EdgeInsets.only(
                  right: index < totalSteps - 1 ? AppDimens.spaceXs : 0,
                ),
                height: 4,
                decoration: BoxDecoration(
                  color: isActive
                      ? AppColors.tertiary500
                      : AppColors.background600,
                  borderRadius: BorderRadius.circular(AppDimens.boraLg),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
