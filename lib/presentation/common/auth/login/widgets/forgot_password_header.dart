import 'package:flutter/material.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';

class ForgotPasswordHeader extends StatelessWidget {
  const ForgotPasswordHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Forgot Password?',
          style: TextStyles.display.copyWith(color: AppColors.primary500),
        ),
        const SizedBox(height: AppDimens.spaceSm),
        Text(
          'Enter your email address to receive password reset instructions',
          style: TextStyles.bodyMedium.copyWith(color: AppColors.secondary400),
        ),
      ],
    );
  }
}
