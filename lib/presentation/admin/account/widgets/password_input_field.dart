import 'package:flutter/material.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';

class PasswordInputField extends StatefulWidget {
  final String label;

  const PasswordInputField({super.key, required this.label});

  @override
  State<PasswordInputField> createState() => _PasswordInputFieldState();
}

class _PasswordInputFieldState extends State<PasswordInputField> {
  bool _obscureText = true;

  void _onToggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
    debugPrint("action triggered: _onToggleVisibility");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyles.bodyLarge.copyWith(color: AppColors.primary500),
        ),
        const SizedBox(height: AppDimens.spaceXs),
        Container(
          width: double.infinity,
          height: 45.0,
          decoration: BoxDecoration(
            color: AppColors.background500,
            borderRadius: BorderRadius.circular(AppDimens.boraMd),
            border: Border.all(color: AppColors.secondary200, width: 1.0),
          ),
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceSm),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                    hintText: '........',
                    hintStyle: TextStyles.bodyMedium.copyWith(
                      color: AppColors.secondary200,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  style: TextStyles.bodyMedium.copyWith(
                    color: AppColors.primary500,
                  ),
                ),
              ),
              GestureDetector(
                onTap: _onToggleVisibility,
                child: Icon(
                  _obscureText
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: AppColors.secondary200,
                  size: 20.0,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
