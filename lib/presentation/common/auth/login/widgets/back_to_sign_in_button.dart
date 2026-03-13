import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';

class BackToSignInButton extends StatelessWidget {
  const BackToSignInButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Navigate back to previous screen
      onTap: () => context.pop(),
      child: Text(
        '← Back to Sign In',
        style: TextStyles.label.copyWith(
          color: AppColors.tertiary500,
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.underline,
          decorationColor: AppColors.tertiary500,
        ),
      ),
    );
  }
}