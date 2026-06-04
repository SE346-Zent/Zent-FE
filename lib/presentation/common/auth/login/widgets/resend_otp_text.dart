import 'package:flutter/material.dart';
import 'package:zent_fe/presentation/common/core/utils/tap_debounce.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';

class ResendOtpText extends StatelessWidget {
  final VoidCallback onResend;
  final int countdown;
  final bool canResend;

  const ResendOtpText({
    super.key,
    required this.onResend,
    required this.countdown,
    required this.canResend,
  });

  @override
  Widget build(BuildContext context) {
    return ThrottledGestureDetector(
      onTap: canResend ? onResend : null,
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: TextStyles.bodyMedium.copyWith(color: AppColors.secondary400),
          children: [
            const TextSpan(text: 'Haven\'t received OTP Code? '),
            TextSpan(
              text: canResend ? 'Resend' : 'Resend in ${countdown}s',
              style: TextStyle(
                color: canResend
                    ? AppColors.tertiary500
                    : AppColors.secondary300,
                fontWeight: FontWeight.bold,
                decoration: canResend
                    ? TextDecoration.underline
                    : TextDecoration.none,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
