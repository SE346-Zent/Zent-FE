import 'package:flutter/material.dart';
import '../../common/core/themes/colors.dart';
import '../../common/core/themes/text_styles.dart';

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
        GestureDetector(
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