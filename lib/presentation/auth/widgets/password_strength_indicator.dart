import 'package:flutter/material.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';

class PasswordStrengthIndicator extends StatelessWidget {
  final int strengthLevel; // 0: None, 1: Weak, 2: Fair, 3: Good, 4: Strong

  const PasswordStrengthIndicator({
    super.key,
    this.strengthLevel = 1, // Default to weak if not provided
  });

  @override
  Widget build(BuildContext context) {
    String strengthText = 'weak';
    Color strengthColor = Colors.red;

    // Determine strength text and color based on the level
    if (strengthLevel == 2) {
      strengthText = 'fair';
      strengthColor = Colors.orange;
    } else if (strengthLevel >= 3) {
      strengthText = 'strong';
      strengthColor = Colors.green;
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Password Strength', style: TextStyles.label.copyWith(color: AppColors.secondary400)),
            Text(strengthText, style: TextStyles.label.copyWith(color: strengthColor, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: AppDimens.spaceXs),
        Row(
          children: [
            _buildStrengthBar(isActive: strengthLevel >= 1, color: strengthColor),
            const SizedBox(width: 8),
            _buildStrengthBar(isActive: strengthLevel >= 2, color: strengthColor),
            const SizedBox(width: 8),
            _buildStrengthBar(isActive: strengthLevel >= 3, color: strengthColor),
            const SizedBox(width: 8),
            _buildStrengthBar(isActive: strengthLevel >= 4, color: strengthColor),
          ],
        ),
      ],
    );
  }

  Widget _buildStrengthBar({required bool isActive, required Color color}) {
    return Expanded(
      child: Container(
        height: 4,
        decoration: BoxDecoration(
          color: isActive ? color : AppColors.secondary200,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}