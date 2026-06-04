import 'package:flutter/material.dart';
import 'package:zent_fe/presentation/common/core/utils/tap_debounce.dart';
import 'package:go_router/go_router.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';

class BackToSignInButton extends StatelessWidget {
  const BackToSignInButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ThrottledGestureDetector(
      // Navigate back to previous screen
      onTap: () => context.pop(),
      child: Text(
        '← Back to Sign In',
        style: TextStyles.bodyLarge.copyWith(
          color: Colors.transparent,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(color: AppColors.tertiary500, offset: const Offset(0, -2)),
          ],
          decoration: TextDecoration.underline,
          decorationColor: AppColors.tertiary500,
          decorationThickness: 1.5,
        ),
      ),
    );
  }
}
