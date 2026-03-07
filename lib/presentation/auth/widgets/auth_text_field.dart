import 'package:flutter/material.dart';
import '../../common/core/themes/colors.dart';
import '../../common/core/themes/dimens.dart';
import '../../common/core/themes/text_styles.dart';

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
        // 1. Label
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: TextStyles.title.copyWith(
              color: AppColors.primary500,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppDimens.spaceSm),
        ],
        
        const SizedBox(height: AppDimens.spaceSm),
        
        // 2. Text Field
        TextField(
          controller: widget.controller,
          obscureText: widget.isPassword ? _obscureText : false,
          keyboardType: widget.keyboardType,
          style: TextStyles.bodyMedium.copyWith(color: AppColors.primary500),
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: TextStyles.bodyMedium.copyWith(color: AppColors.secondary300),
            prefixIcon: widget.prefixIcon != null 
                ? Icon(widget.prefixIcon, color: AppColors.secondary400) 
                : null,
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
              borderSide: const BorderSide(color: AppColors.secondary200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimens.boraSm),
              borderSide: const BorderSide(color: AppColors.secondary200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimens.boraSm),
              borderSide: const BorderSide(color: AppColors.tertiary500, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppDimens.spaceMd, 
              vertical: AppDimens.spaceMd, 
            ),
          ),
        ),
      ],
    );
  }
}