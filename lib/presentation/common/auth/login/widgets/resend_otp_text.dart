import 'package:flutter/material.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';

class ResendOtpText extends StatelessWidget {
  final VoidCallback onResend;

  const ResendOtpText({super.key, required this.onResend});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onResend,
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: TextStyles.bodyMedium.copyWith(color: AppColors.secondary400),
          children: [
            const TextSpan(text: 'Haven\'t received OTP Code? '),
            TextSpan(
              text: 'Resend',
              style: const TextStyle(
                color: AppColors.tertiary500,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
