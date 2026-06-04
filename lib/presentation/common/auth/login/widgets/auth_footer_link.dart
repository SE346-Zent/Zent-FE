import 'package:flutter/material.dart';
import 'package:zent_fe/presentation/common/core/utils/tap_debounce.dart';
import '../../../core/themes/colors.dart';
import '../../../core/themes/text_styles.dart';

class AuthFooterLink extends StatelessWidget {
  final String text;
  final String linkText;
  final VoidCallback onTap;

  const AuthFooterLink({
    super.key,
    required this.text,
    required this.linkText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          text,
          style: TextStyles.bodyMedium.copyWith(color: AppColors.secondary400),
        ),
        ThrottledGestureDetector(
          onTap: onTap,
          child: Text(
            ' $linkText',
            style: TextStyles.bodyMedium.copyWith(
              color: AppColors.tertiary500,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
