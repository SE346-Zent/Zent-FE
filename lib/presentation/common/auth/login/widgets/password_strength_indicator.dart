import 'package:flutter/material.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';

class PasswordStrengthIndicator extends StatelessWidget {
  final int strengthLevel;

  const PasswordStrengthIndicator({super.key, this.strengthLevel = 0});

  @override
  Widget build(BuildContext context) {
    String strengthText = '';
    Color strengthColor = AppColors.surface600;

    switch (strengthLevel) {
      case 1:
        strengthText = 'Weak';
        strengthColor = AppColors.error500;
        break;
      case 2:
        strengthText = 'Medium';
        strengthColor = AppColors.warning500;
        break;
      case 3:
        strengthText = 'Strong';
        strengthColor = AppColors.success300;
        break;
      case 4:
        strengthText = 'Very Strong';
        strengthColor = AppColors.success600;
        break;
      case 0:
      default:
        strengthText = '';
        strengthColor = AppColors.surface600;
        break;
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Password Strength',
              style: TextStyles.label.copyWith(color: AppColors.secondary400),
            ),
            Text(
              strengthText,
              style: TextStyles.label.copyWith(
                color: strengthColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimens.spaceXs),
        Row(
          children: [
            _buildStrengthBar(
              isActive: strengthLevel >= 1,
              color: strengthColor,
            ),
            const SizedBox(width: 8),
            _buildStrengthBar(
              isActive: strengthLevel >= 2,
              color: strengthColor,
            ),
            const SizedBox(width: 8),
            _buildStrengthBar(
              isActive: strengthLevel >= 3,
              color: strengthColor,
            ),
            const SizedBox(width: 8),
            _buildStrengthBar(
              isActive: strengthLevel >= 4,
              color: strengthColor,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStrengthBar({required bool isActive, required Color color}) {
    return Expanded(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: 4,
        decoration: BoxDecoration(
          color: isActive ? color : AppColors.secondary200,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}
