import 'package:flutter/material.dart';
import '../../../core/themes/colors.dart';
import '../../../core/themes/dimens.dart';
import '../../../core/themes/text_styles.dart';

class AuthTextField extends StatefulWidget {
  final String? label;
  final String hintText;
  final IconData? prefixIcon;
  final bool isPassword;
  final TextEditingController? controller;
  final TextInputType? keyboardType;

  const AuthTextField({
    super.key,
    this.label,
    required this.hintText,
    this.prefixIcon,
    this.isPassword = false,
    this.controller,
    this.keyboardType,
  });

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: TextStyles.middle.copyWith(
              color: AppColors.primary500,
            ),
          ),
          const SizedBox(height: AppDimens.spaceXs),
        ],

        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppDimens.boraSm),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.30),
                blurRadius: 1.0,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: TextField(
            controller: widget.controller,
            obscureText: widget.isPassword ? _obscureText : false,
            keyboardType: widget.keyboardType,
            style: TextStyles.bodyMedium.copyWith(color: AppColors.primary500),
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: TextStyles.bodyMedium.copyWith(color: AppColors.secondary200),
              prefixIcon: widget.prefixIcon != null ? Icon(widget.prefixIcon, color: AppColors.secondary400) : null,
              suffixIcon: widget.isPassword
                  ? IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                        size: 20,
                        color: AppColors.secondary400,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimens.boraSm),
                borderSide: const BorderSide(color: Colors.transparent),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimens.boraSm),
                borderSide: const BorderSide(
                  color: AppColors.secondary200,
                  width: 1.0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimens.boraSm),
                borderSide: const BorderSide(color: AppColors.tertiary500, width: 1.5),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppDimens.spaceMd,
                vertical: AppDimens.spaceMd,
              ),
            ),
          ),
        ),
      ],
    );
  }
}