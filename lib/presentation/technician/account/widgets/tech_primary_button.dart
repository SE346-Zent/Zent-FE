import 'package:flutter/material.dart';

// Core Theming
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';

class TechPrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool isLoading;

  const TechPrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final buttonChild = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null && !isLoading)
          Padding(
            padding: const EdgeInsets.only(right: AppDimens.spaceSm),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
        isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(text, style: TextStyles.title.copyWith(color: Colors.white)),
      ],
    );

    return Container(
      width: double.infinity,
      height: 50.0,
      decoration: BoxDecoration(
        color: AppColors.tertiary500,
        borderRadius: BorderRadius.circular(AppDimens.boraMd),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(AppDimens.boraMd),
          child: Center(child: buttonChild),
        ),
      ),
    );
  }
}
