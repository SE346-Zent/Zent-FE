import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../common/core/themes/colors.dart';
import '../../../common/core/themes/dimens.dart';
import '../../../common/core/themes/text_styles.dart';

/// A standardized header for account-related screens.
///
/// **Usage:**
/// ```dart
/// const AccountHeader(title: 'Settings')
/// ```
///
/// **Features:**
/// - Includes a leading widget (defaults to back button popping the navigator).
/// - Can be hidden by passing `showLeading: false`.
/// - Can be customized via `leading` and `trailing` widgets.
/// - Centered title.
/// - Optional bottom divider.
class AccountHeader extends StatelessWidget {
  /// The text displayed as the screen title.
  final String title;

  /// Optional subtitle displayed below the title.
  final String? subtitle;

  /// Optional callback for the back button.
  /// If null, defaults to `context.pop()`.
  final VoidCallback? onBackPressed;

  /// Whether to display the bottom divider line.
  final bool showDivider;

  /// Horizontal padding for the header content.
  final double horizontalPadding;

  /// Vertical padding for the header content.
  final double verticalPadding;

  /// Whether to display the leading widget (default back button).
  final bool showLeading;

  /// Optional custom leading widget. If null, a back button is used.
  final Widget? leading;

  /// Optional custom trailing widget.
  final Widget? trailing;

  const AccountHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.onBackPressed,
    this.showDivider = false,
    this.horizontalPadding = AppDimens.spaceMd,
    this.verticalPadding = AppDimens.spaceSm,
    this.showLeading = true,
    this.leading,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = Row(
      children: [
        if (showLeading)
          leading ??
              SizedBox(
                width: 40.0,
                height: 40.0,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(
                    Icons.arrow_back,
                    color: AppColors.primary500,
                  ),
                  onPressed:
                      onBackPressed ??
                      () {
                        context.pop();
                      },
                ),
              )
        else
          const SizedBox(width: 40.0), // Balance the row when no leading
        Expanded(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyles.headline.copyWith(color: AppColors.primary500),
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: TextStyles.label.copyWith(
                      color: AppColors.secondary500,
                      height: 1.1, // tighter spacing
                    ),
                  ),
              ],
            ),
          ),
        ),
        if (trailing != null)
          trailing!
        else
          const SizedBox(width: 40.0), // Balance the row
      ],
    );

    Widget result = Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      child: content,
    );

    if (showDivider) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          result,
          Container(
            width: double.infinity,
            height: 1.0,
            color: AppColors.secondary50,
          ),
        ],
      );
    }

    return result;
  }
}
