import 'package:flutter/material.dart';
import 'package:zent_fe/presentation/common/core/utils/tap_debounce.dart';

// Core Theming
import 'package:zent_fe/presentation/common/core/themes/boxshadow.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';

class TechTextField extends StatefulWidget {
  final String label;
  final String hint;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final int? maxLines;
  final TextEditingController? controller;
  final bool readOnly;
  final TextStyle? labelStyle;
  final TextInputType? keyboardType;
  final bool obscureText;

  const TechTextField({
    super.key,
    required this.label,
    required this.hint,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.controller,
    this.readOnly = false,
    this.labelStyle,
    this.keyboardType,
    this.obscureText = false,
  });

  @override
  State<TechTextField> createState() => _TechTextFieldState();
}

class _TechTextFieldState extends State<TechTextField> {
  late bool _obscured;

  @override
  void initState() {
    super.initState();
    _obscured = widget.obscureText;
  }

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
            widget.label,
            style:
                widget.labelStyle ??
                TextStyles.title.copyWith(color: AppColors.primary500),
          ),
        ),

        Container(
          decoration: BoxDecoration(
            color: widget.readOnly
                ? const Color(0xFFF9FAFB)
                : AppColors.surface100,
            borderRadius: BorderRadius.circular(AppDimens.boraMd),
            border: Border.all(color: AppColors.secondary100, width: 1.0),
            boxShadow: [BoxShadowStyles.subtle],
          ),
          child: TextField(
            controller: widget.controller,
            maxLines: _obscured ? 1 : widget.maxLines,
            readOnly: widget.readOnly,
            obscureText: _obscured,
            keyboardType: widget.keyboardType,
            cursorColor: AppColors.primary500,
            style: TextStyles.bodyLarge.copyWith(
              color: widget.readOnly
                  ? AppColors.secondary700
                  : AppColors.primary500,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppDimens.spaceSm,
                vertical: 12.0,
              ),
              hintText: widget.hint,
              hintStyle: TextStyles.bodyLarge.copyWith(
                color: AppColors.secondary200,
              ),
              prefixIcon: widget.prefixIcon != null
                  ? Icon(widget.prefixIcon, color: AppColors.secondary100)
                  : null,
              suffixIcon: widget.obscureText
                  ? ThrottledGestureDetector(
                      onTap: () {
                        setState(() {
                          _obscured = !_obscured;
                        });
                      },
                      child: Icon(
                        _obscured
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: AppColors.secondary200,
                      ),
                    )
                  : (widget.suffixIcon != null
                        ? Icon(widget.suffixIcon, color: AppColors.secondary100)
                        : null),
            ),
          ),
        ),
      ],
    );
  }
}
