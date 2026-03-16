import 'package:flutter/material.dart';
import '../../../core/themes/colors.dart';
import '../../../core/themes/dimens.dart';
import '../../../core/themes/text_styles.dart';

class AuthPrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const AuthPrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0), 
      child: Container(
        width: double.infinity,
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.tertiary500,
          borderRadius: BorderRadius.circular(AppDimens.boraSm),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 2.0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            elevation: 0, 
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimens.boraSm),
            ),
          ),
          child: Text(
            text,
            style: TextStyles.title.copyWith(
              color: AppColors.surface50,
            ),
          ),
        ),
      ),
    );
  }
}