import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Core Theming
import 'package:zent_fe/presentation/common/core/themes/boxshadow.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';

class CustomerTextField extends StatelessWidget {
  final String label;
  final String hint;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final int? maxLines;
  final TextEditingController? controller;
  final bool readOnly;
  final TextStyle? labelStyle;
  final bool isRequired;
  final VoidCallback? onTap;
  final FocusNode? focusNode;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType keyboardType;

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
    this.isRequired = false,
    this.onTap,
    this.focusNode,
    this.inputFormatters,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: AppDimens.spaceXs),
          child: RichText(
            text: TextSpan(
              text: label,
              style:
                  labelStyle ??
                  TextStyles.title.copyWith(color: AppColors.primary500),
              children: isRequired
                  ? [
                      TextSpan(
                        text: '*',
                        style: (labelStyle ?? TextStyles.title).copyWith(
                          color: AppColors.error500,
                        ),
                      ),
                    ]
                  : null,
            ),
          ),
        ),

        Container(
          decoration: BoxDecoration(
            color: readOnly ? AppColors.secondary50 : AppColors.surface100,
            borderRadius: BorderRadius.circular(AppDimens.boraMd),
            border: Border.all(color: AppColors.secondary200, width: 1.0),
            boxShadow: [BoxShadowStyles.subtle],
          ),
          child: TextField(
            focusNode: focusNode,
            controller: controller,
            maxLines: maxLines,
            readOnly: readOnly,
            onTap: onTap,
            inputFormatters: inputFormatters,
            keyboardType: keyboardType,
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
              suffixIcon: suffixIcon,
            ),
          ),
        ),
      ],
    );
  }
}
