import 'package:flutter/material.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/presentation/common/core/themes/boxshadow.dart'; // Import shadow vào đây

class SocialLoginButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SocialLoginButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimens.boraSm),
        boxShadow: [BoxShadowStyles.subtle], 
      ),
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
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
            ),
            const SizedBox(width: AppDimens.spaceSm),
            Text(
              'Continue with Google',
              style: TextStyles.bodyLarge.copyWith(color: AppColors.secondary500),
            ),
          ],
        ),
      ),
    );
  }
}