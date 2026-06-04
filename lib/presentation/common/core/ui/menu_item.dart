import 'package:flutter/material.dart';
import 'package:zent_fe/presentation/common/core/utils/tap_debounce.dart';
import '../../../common/core/themes/colors.dart';
import '../../../common/core/themes/dimens.dart';
import '../../../common/core/themes/text_styles.dart';
import '../../../common/core/themes/boxshadow.dart';

/// A standard navigation list item used in account menus.
///
/// **Usage:**
/// ```dart
/// MenuItem(
///   title: 'Profile info',
///   subtitle: 'Change your personal details',
///   iconData: Icons.person_outline,
///   onTap: () => print('Tapped!'),
/// )
/// ```
///
/// **Features:**
/// - Displays a leading icon with a circular background.
/// - Title and subtitle layout.
/// - Trailing chevron icon.
/// - Built-in feedback on tap.
class MenuItem extends StatelessWidget {
  /// The primary bold text for the menu item.
  final String title;

  /// The descriptive secondary text below the title.
  final String subtitle;

  /// The icon displayed on the left side.
  final IconData iconData;

  /// Callback function triggered when the item is tapped.
  final VoidCallback onTap;

  const MenuItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.iconData,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimens.boraMd),
        boxShadow: [BoxShadowStyles.subtle],
      ),
      child: Material(
        color: AppColors.surface100,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: AppColors.surface600, width: 1.0),
          borderRadius: BorderRadius.circular(AppDimens.boraMd),
        ),
        child: ThrottledInkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppDimens.boraMd),
          child: Container(
            height: 60.0,
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceMd),
            child: Row(
              children: [
                Container(
                  width: 36.0,
                  height: 36.0,
                  decoration: const BoxDecoration(
                    color: AppColors.tertiary50,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    iconData,
                    color: AppColors.tertiary500,
                    size: 20.0,
                  ),
                ),
                const SizedBox(width: AppDimens.spaceMd),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: TextStyles.middle.copyWith(
                          color: AppColors.primary500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        subtitle,
                        style: TextStyles.bodyMedium.copyWith(
                          color: AppColors.secondary300,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  color: AppColors.secondary200,
                  size: 24.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
