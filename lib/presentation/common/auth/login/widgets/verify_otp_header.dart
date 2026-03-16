import 'package:flutter/material.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import '../../../core/app_assets.dart';

class VerifyOtpHeader extends StatelessWidget {
  final String email;

  const VerifyOtpHeader({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(AppAssets.verifyOtpImage, height: 180),
        const SizedBox(height: AppDimens.spaceXl),
        Text(
          'Verify OTP',
          style: TextStyles.display.copyWith(color: AppColors.primary500),
        ),
        const SizedBox(height: AppDimens.spaceSm),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: TextStyles.bodyMedium.copyWith(
              color: AppColors.secondary400,
            ),
            children: [
              const TextSpan(text: 'The OTP code has been sent to\n'),
              TextSpan(
                text: email,
                style: const TextStyle(
                  color: AppColors.tertiary500,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
