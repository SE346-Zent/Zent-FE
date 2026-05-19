import 'package:flutter/material.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/presentation/common/core/themes/boxshadow.dart';

class ProfileInputField extends StatelessWidget {
  final String label;
  final String? hintText;
  final TextEditingController? controller;
  final bool isMultiline;
  final double? height;
  final Color? labelColor;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final ValueChanged<String>? onChanged;
  final bool showSubtleShadow;
  final bool enabled;

  const ProfileInputField({
    super.key,
    required this.label,
    this.hintText,
    this.controller,
    this.isMultiline = false,
    this.height,
    this.labelColor,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.showSubtleShadow = false,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyles.middle.copyWith(
            color: labelColor ?? AppColors.secondary400,
          ),
        ),
        const SizedBox(height: AppDimens.spaceXs),
        Container(
          height: height ?? (isMultiline ? 101.0 : 45.0),
          decoration: BoxDecoration(
            color: enabled
                ? AppColors.surface100
                : AppColors.surface100.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(AppDimens.boraSm),
            border: Border.all(color: AppColors.primary50),
            boxShadow: showSubtleShadow ? [BoxShadowStyles.subtle] : null,
          ),
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            enabled: enabled,
            maxLines: isMultiline ? null : 1,
            expands: isMultiline,
            textAlignVertical: isMultiline
                ? TextAlignVertical.top
                : TextAlignVertical.center,
            style: TextStyles.bodyMedium.copyWith(
              color: enabled ? AppColors.primary500 : AppColors.secondary300,
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyles.bodyMedium.copyWith(
                color: AppColors.secondary100,
              ),
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.symmetric(
                horizontal: AppDimens.spaceSm,
                vertical: isMultiline ? AppDimens.spaceSm : 12.0,
              ),
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon,
            ),
          ),
        ),
      ],
    );
  }
}
