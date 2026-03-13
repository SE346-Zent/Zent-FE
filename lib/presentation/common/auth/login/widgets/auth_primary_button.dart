import 'package:flutter/material.dart';
import '../../../core/themes/boxshadow.dart';
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
    return Container(
      width: double.infinity, 
      height: 48, 
      decoration: BoxDecoration(
        boxShadow: [BoxShadowStyles.subtle], 
        borderRadius: BorderRadius.circular(AppDimens.boraSm), 
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.tertiary500, 
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.boraSm),
          ),
          elevation: 0, 
        ),
        child: Text(
          text,
          style: TextStyles.title.copyWith(
            color: AppColors.surface50,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
    );
  }
}