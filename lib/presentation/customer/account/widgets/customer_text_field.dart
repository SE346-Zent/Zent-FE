import 'package:flutter/material.dart';

// Core Theming
import 'package:zent_fe/presentation/common/core/themes/boxshadow.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';

class CustomerTextField extends StatelessWidget {
  final String label;
  final String hint;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final int? maxLines;
  final TextEditingController? controller;
  final bool readOnly;
  final TextStyle? labelStyle;
  final bool obscureText;

  const CustomerTextField({
    super.key,
    required this.label,
    required this.hint,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.controller,
    this.readOnly = false,
    this.labelStyle,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            bottom: AppDimens.spaceXs,
            left: AppDimens.spaceXs,
          ),
          child: Text(
            label,
            style:
                labelStyle ??
                TextStyles.title.copyWith(color: AppColors.primary500),
          ),
        ),

        Container(
          decoration: BoxDecoration(
            color: readOnly ? AppColors.secondary50 : AppColors.surface100,
            borderRadius: BorderRadius.circular(AppDimens.boraMd),
            border: Border.all(color: AppColors.secondary100, width: 1.0),
            boxShadow: [BoxShadowStyles.subtle],
          ),
          child: TextField(
            controller: controller,
            maxLines: obscureText ? 1 : maxLines,
            readOnly: readOnly,
            obscureText: obscureText,
            cursorColor: AppColors.primary500,
            style: TextStyles.bodyLarge.copyWith(
              color: readOnly ? AppColors.secondary200 : AppColors.primary500,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppDimens.spaceSm,
                vertical: 12.0,
              ),
              hintText: hint,
              hintStyle: TextStyles.bodyLarge.copyWith(
                color: AppColors.secondary200,
              ),
              prefixIcon: prefixIcon != null
                  ? Icon(prefixIcon, color: AppColors.secondary100)
                  : null,
              suffixIcon: suffixIcon != null
                  ? Icon(suffixIcon, color: AppColors.secondary100)
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}
