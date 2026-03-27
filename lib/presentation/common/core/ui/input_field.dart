import 'package:flutter/material.dart';
import '../themes/colors.dart';
import '../themes/dimens.dart';
import '../themes/text_styles.dart';
import '../themes/boxshadow.dart';

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
/// - leading [leadingIcon] for context.
/// - Supports [isReadOnly] mode with a lock icon.
/// - Supports [isPassword] (obscure text) mode.
class InputField extends StatefulWidget {
  /// The label displayed above the input field.
  final String label;

  /// Initial text to display in the field.
  final String? initialValue;

  /// Callback triggered whenever the input text changes.
  final ValueChanged<String>? onChanged;

  /// Optional icon displayed at the start of the field.
  final IconData? leadingIcon;

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

  /// Callback for tap events on the field.
  final VoidCallback? onTap;

  /// Alignment of the text within the field.
  final TextAlign textAlign;

  /// Maximum number of lines for multiline input.
  final int? maxLines;

  /// Custom color for the field label.
  final Color? labelColor;

  /// Custom child to replace the default TextFormField.
  final Widget? customInputChild;

  const InputField({
    super.key,
    required this.label,
    this.initialValue,
    this.onChanged,
    this.leadingIcon,
    this.isReadOnly = false,
    this.helperText,
    this.controller,
    this.hintText,
    this.suffixIcon,
    this.keyboardType,
    this.isPassword = false,
    this.focusNode,
    this.onTap,
    this.textAlign = TextAlign.start,
    this.maxLines = 1,
    this.labelColor,
    this.customInputChild,
  });

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        widget.controller ?? TextEditingController(text: widget.initialValue);
  }

  @override
  void didUpdateWidget(InputField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller == null &&
        widget.initialValue != oldWidget.initialValue) {
      _controller.text = widget.initialValue ?? '';
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyles.middle.copyWith(
            color: widget.labelColor ?? AppColors.secondary500,
          ),
        ),
        const SizedBox(
          height: AppDimens.spaceXs,
        ), // 8px bottom margin from label
        Container(
          constraints: const BoxConstraints(minHeight: 45.0),
          decoration: BoxDecoration(
            color: widget.isReadOnly
                ? AppColors.secondary50
                : AppColors.surface100,
            borderRadius: BorderRadius.circular(
              AppDimens.boraMd,
            ), // Assuming standard radius
            border: Border.all(color: AppColors.secondary200, width: 1.0),
            boxShadow: [BoxShadowStyles.subtle], // Added shadow
          ),
          child: Row(
            crossAxisAlignment: widget.maxLines != null && widget.maxLines! > 1
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.center,
            children: [
              if (widget.leadingIcon != null)
                Padding(
                  padding: EdgeInsets.only(
                    left: AppDimens.spaceMd,
                    right: 8.0,
                    top: widget.maxLines != null && widget.maxLines! > 1
                        ? 12.0
                        : 0.0,
                  ),
                  child: Icon(
                    widget.leadingIcon,
                    color: AppColors.secondary300,
                    size: 20.0,
                  ),
                ),
              if (widget.leadingIcon == null)
                const SizedBox(width: AppDimens.spaceMd),
              Expanded(
                child:
                    widget.customInputChild ??
                    TextFormField(
                      controller: _controller,
                      onChanged: widget.onChanged,
                      readOnly: widget.isReadOnly,
                      obscureText: widget.isPassword,
                      keyboardType: widget.keyboardType,
                      focusNode: widget.focusNode,
                      onTap: widget.onTap,
                      textAlign: widget.textAlign,
                      maxLines: widget.maxLines,
                      style: TextStyles.bodyLarge.copyWith(
                        color: AppColors.primary500,
                      ),
                      decoration: InputDecoration(
                        hintText: widget.hintText,
                        hintStyle: TextStyles.bodyLarge.copyWith(
                          color: AppColors.secondary300,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(
                          vertical:
                              widget.maxLines != null && widget.maxLines! > 1
                              ? 12.0
                              : 12.0,
                        ),
                      ),
                    ),
              ),
              if (widget.suffixIcon != null)
                Padding(
                  padding: EdgeInsets.only(
                    right: AppDimens.spaceMd,
                    top: widget.maxLines != null && widget.maxLines! > 1
                        ? 12.0
                        : 0.0,
                  ),
                  child: widget.suffixIcon,
                ),
              if (widget.isReadOnly &&
                  widget.suffixIcon == null &&
                  widget.customInputChild == null)
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
        if (widget.helperText != null) ...[
          const SizedBox(height: AppDimens.spaceXs),
          Text(
            widget.helperText!,
            style: TextStyles.bodyMedium.copyWith(
              color: AppColors.secondary500,
            ),
          ),
        ],
      ],
    );
  }
}
