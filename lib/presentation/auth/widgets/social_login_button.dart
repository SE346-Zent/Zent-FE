import 'package:flutter/material.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';

class SocialLoginButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SocialLoginButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        side: BorderSide(color: AppColors.secondary200),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.boraSm),
        ),
        elevation: 0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/GoogleIcon.webp',
            width: 24,
            height: 24,
            cacheWidth: 48,
            cacheHeight: 48,
          ),
          const SizedBox(width: AppDimens.spaceSm),
          Text(
            'Continue with Google',
            style: TextStyles.bodyLarge.copyWith(color: AppColors.secondary500),
          ),
        ],
      ),
    );
  }
}