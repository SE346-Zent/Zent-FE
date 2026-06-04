import 'package:flutter/material.dart';
import '../themes/colors.dart';
import '../themes/dimens.dart';
import '../themes/text_styles.dart';
import '../themes/boxshadow.dart';
import '../utils/tap_debounce.dart';

/// The primary call-to-action button used across the application.
///
/// **Usage:**
/// ```dart
/// PrimaryActionButton(
///   label: 'Save Changes',
///   onPressed: () => print('Saved!'),
///   icon: Icons.save,
/// )
/// ```
///
/// **Features:**
/// - Standardized elevation and shadows.
/// - Support for optional leading [icon].
/// - Consistent branding via [backgroundColor] (tertiary500 by default).
class PrimaryActionButton extends StatelessWidget {
  /// The text displayed inside the button.
  final String label;

  /// Optional icon displayed before the label.
  final IconData? icon;

  /// Callback function triggered on tap. If null, the button will be disabled.
  final VoidCallback? onPressed;

  /// Custom width for the button. Defaults to `364.0`.
  final double? width;

  /// Height of the button. Defaults to `49.0`.
  final double height;

  /// Size of the [icon]. Defaults to `24.0`.
  final double iconSize;

  /// Background color of the button. Defaults to `AppColors.tertiary500`.
  final Color backgroundColor;

  /// Color of the text and icon. Defaults to `AppColors.surface100`.
  final Color foregroundColor;

  /// Optional custom style for the label text.
  final TextStyle? textStyle;

  /// Corner radius for the button. Defaults to `AppDimens.boraMd`.
  final double borderRadius;

  /// Optional custom shadow for the button.
  final BoxShadow? shadow;

  const PrimaryActionButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    // Size defaults
    this.width = 364.0,
    this.height = 49.0,
    this.iconSize = 24.0,
    // Style defaults
    this.backgroundColor = AppColors.tertiary500,
    this.foregroundColor = AppColors.surface100,
    this.textStyle,
    this.borderRadius = AppDimens.boraMd,
    this.shadow,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedTextStyle =
        textStyle ?? TextStyles.title.copyWith(color: foregroundColor);
    final isTertiary500 = backgroundColor == AppColors.tertiary500;
    final resolvedShadow =
        shadow ??
        (isTertiary500 ? BoxShadowStyles.glowing : BoxShadowStyles.subtle);
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadius),
    );

    final buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      shape: shape,
      elevation: 0,
    );

    final debouncedOnPressed = TapDebounce.call(onPressed);

    final child = icon != null
        ? ElevatedButton.icon(
            onPressed: debouncedOnPressed,
            icon: Icon(icon, size: iconSize),
            label: Text(label, style: resolvedTextStyle),
            style: buttonStyle,
          )
        : ElevatedButton(
            onPressed: debouncedOnPressed,
            style: buttonStyle,
            child: Text(label, style: resolvedTextStyle),
          );

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [resolvedShadow],
      ),
      child: child,
    );
  }
}
