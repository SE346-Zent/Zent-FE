import 'package:flutter/material.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';

class PasswordRequirementsBox extends StatelessWidget {
  final bool hasMinLength;
  final bool hasNumber;
  final bool hasSpecialChar;

  const PasswordRequirementsBox({
    super.key,
    this.hasMinLength = false,
    this.hasNumber = false,
    this.hasSpecialChar = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimens.spaceLg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimens.boraMd),
        border: Border.all(color: AppColors.secondary200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Password requirements:', style: TextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: AppDimens.spaceSm),
          _buildRequirementItem('At least 8 characters long', isMet: hasMinLength),
          const SizedBox(height: AppDimens.spaceXs),
          _buildRequirementItem('Contains at least one number', isMet: hasNumber),
          const SizedBox(height: AppDimens.spaceXs),
          _buildRequirementItem('Contains at least one special character', isMet: hasSpecialChar),
        ],
      ),
    );
  }

  Widget _buildRequirementItem(String text, {required bool isMet}) {
    return Row(
      children: [
        Icon(
          isMet ? Icons.check_circle : Icons.circle_outlined,
          size: 16,
          color: isMet ? Colors.green : AppColors.secondary400,
        ),
        const SizedBox(width: AppDimens.spaceSm),
        Text(text, style: TextStyles.label.copyWith(color: AppColors.secondary400)),
      ],
    );
  }
}