import 'package:flutter/material.dart';
import '../themes/colors.dart';
import '../themes/dimens.dart';
import '../themes/text_styles.dart';
import '../themes/boxshadow.dart';

class PrimaryActionButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback onPressed;

  // Size
  final double? width;
  final double height;
  final double iconSize;

  // Style
  final Color backgroundColor;
  final Color foregroundColor;
  final TextStyle? textStyle;
  final double borderRadius;
  final BoxShadow? shadow;

  const PrimaryActionButton({
    super.key,
    required this.label,
    required this.onPressed,
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
    final resolvedShadow = shadow ?? BoxShadowStyles.subtle;
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadius),
    );

    final buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      shape: shape,
      elevation: 0,
    );

    final child = icon != null
        ? ElevatedButton.icon(
            onPressed: onPressed,
            icon: Icon(icon, size: iconSize),
            label: Text(label, style: resolvedTextStyle),
            style: buttonStyle,
          )
        : ElevatedButton(
            onPressed: onPressed,
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
