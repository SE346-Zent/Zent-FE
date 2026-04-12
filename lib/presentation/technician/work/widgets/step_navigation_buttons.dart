import 'package:flutter/material.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/presentation/common/core/themes/boxshadow.dart';

class StepNavigationButtons extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final VoidCallback onBackPressed;
  final VoidCallback onNextPressed;

  const StepNavigationButtons({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.onBackPressed,
    required this.onNextPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isLastStep = currentStep == totalSteps - 1;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spaceMd,
        vertical: AppDimens.spaceMd,
      ),
      child: Row(
        children: [
          Expanded(child: _buildBackButton()),
          const SizedBox(width: AppDimens.spaceMd),
          Expanded(child: _buildNextButton(isLastStep)),
        ],
      ),
    );
  }

  Widget _buildBackButton() {
    return Container(
      height: 49,
      decoration: BoxDecoration(
        color: AppColors.surface600,
        borderRadius: BorderRadius.circular(AppDimens.boraMd),
      ),
      child: ElevatedButton(
        onPressed: onBackPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.surface600,
          foregroundColor: AppColors.secondary500,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.boraMd),
          ),
        ),
        child: Text(
          "Back",
          style: TextStyles.middle.copyWith(color: AppColors.secondary500),
        ),
      ),
    );
  }

  Widget _buildNextButton(bool isLastStep) {
    return Container(
      height: 49,
      decoration: BoxDecoration(
        color: AppColors.tertiary500,
        borderRadius: BorderRadius.circular(AppDimens.boraMd),
        boxShadow: [BoxShadowStyles.glowing],
      ),
      child: ElevatedButton(
        onPressed: onNextPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.tertiary500,
          foregroundColor: AppColors.surface50,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.boraMd),
          ),
        ),
        child: Text(
          isLastStep ? "Submit" : "Next",
          style: TextStyles.middle.copyWith(color: AppColors.surface50),
        ),
      ),
    );
  }
}
