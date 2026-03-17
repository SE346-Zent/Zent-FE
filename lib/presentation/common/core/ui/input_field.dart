import 'package:flutter/material.dart';
import '../themes/colors.dart';
import '../themes/dimens.dart';
import '../themes/text_styles.dart';

/// A standardized input field with a label and leading icon.
///
/// **Usage:**
/// ```dart
/// InputField(
///   label: 'Email',
///   leadingIcon: Icons.mail_outline,
///   hintText: 'example@mail.com',
///   onChanged: (val) => print(val),
/// )
/// ```
///
/// **Features:**
/// - Includes a label above the input area.
/// - leading [icon] for context.
/// - Supports [isReadOnly] mode with a lock icon.
/// - Supports [isPassword] (obscure text) mode.
class InputField extends StatelessWidget {
  /// The label displayed above the input field.
  final String label;

  /// Initial text to display in the field.
  final String? initialValue;

  /// Callback triggered whenever the input text changes.
  final ValueChanged<String>? onChanged;

  /// Required icon displayed at the start of the field.
  final IconData leadingIcon;

  /// Whether the field is disabled for editing.
  /// Displays a lock icon and grey background.
  final bool isReadOnly;

  /// Optional text shown below the input field for additional guidance.
  final String? helperText;

  /// Optional controller for managing text state externally.
  final TextEditingController? controller;

  /// Text shown when the field is empty.
  final String? hintText;

  /// Optional widget (like visibility icon) shown at the end of the field.
  final Widget? suffixIcon;

  /// Type of keyboard to display (e.g., number, email).
  final TextInputType? keyboardType;

  /// Whether to obscure the text (for passwords).
  final bool isPassword;

  /// Optional focus node for managing keyboard focus.
  final FocusNode? focusNode;

  const InputField({
    super.key,
    required this.label,
    this.initialValue,
    this.onChanged,
    required this.leadingIcon,
    this.isReadOnly = false,
    this.helperText,
    this.controller,
    this.hintText,
    this.suffixIcon,
    this.keyboardType,
    this.isPassword = false,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyles.middle.copyWith(color: AppColors.secondary500),
        ),
        const SizedBox(
          height: AppDimens.spaceXs,
        ), // 8px bottom margin from label
        Container(
          height: 48.0,
          decoration: BoxDecoration(
            color: isReadOnly ? AppColors.secondary50 : Colors.transparent,
            borderRadius: BorderRadius.circular(
              AppDimens.boraMd,
            ), // Assuming standard radius
            border: Border.all(color: AppColors.secondary200, width: 1.0),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.spaceMd,
                ),
                child: Icon(
                  leadingIcon,
                  color: AppColors.secondary300,
                  size: 20.0,
                ),
              ),
              Expanded(
                child: TextFormField(
                  controller: controller,
                  initialValue: controller == null ? initialValue : null,
                  onChanged: onChanged,
                  readOnly: isReadOnly,
                  obscureText: isPassword,
                  keyboardType: keyboardType,
                  focusNode: focusNode,
                  style: TextStyles.bodyLarge.copyWith(
                    color: AppColors.primary500,
                  ),
                  decoration: InputDecoration(
                    hintText: hintText,
                    hintStyle: TextStyles.bodyLarge.copyWith(
                      color: AppColors.secondary300,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
                  ),
                ),
              ),
              if (suffixIcon != null)
                Padding(
                  padding: const EdgeInsets.only(right: AppDimens.spaceMd),
                  child: suffixIcon,
                ),
              if (isReadOnly && suffixIcon == null)
                const Padding(
                  padding: EdgeInsets.only(right: AppDimens.spaceMd),
                  child: SizedBox(
                    width: 17.0,
                    height: 17.0,
                    child: Icon(
                      Icons.lock_outline,
                      color: AppColors.secondary200,
                      size: 17.0,
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (helperText != null) ...[
          const SizedBox(height: AppDimens.spaceXs),
          Text(
            helperText!,
            style: TextStyles.bodyMedium.copyWith(
              color: AppColors.secondary500,
            ),
          ),
        ],
      ],
    );
  }
}
