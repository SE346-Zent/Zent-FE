import 'package:flutter/material.dart';

// Core Theming
import 'package:zent_fe/presentation/common/core/themes/boxshadow.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';

class CustomerTextField extends StatefulWidget {
  final String label;
  final String hint;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final int? maxLines;
  final TextEditingController? controller;
  final bool readOnly;
  final TextStyle? labelStyle;
  final bool obscureText;
  final TextInputType? keyboardType;

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
    this.keyboardType,
  });

  @override
  State<CustomerTextField> createState() => _CustomerTextFieldState();
}

class _CustomerTextFieldState extends State<CustomerTextField> {
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
                ? AppColors.secondary50
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
                  ? AppColors.secondary200
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
                  ? GestureDetector(
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
