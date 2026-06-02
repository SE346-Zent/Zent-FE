import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Core Theming
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';

class CustomerAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final bool showBackButton;
  final bool showBottomDivider;

  const CustomerAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.showBackButton = true,
    this.showBottomDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.background500,
      scrolledUnderElevation: 0,
      elevation: 0,
      automaticallyImplyLeading: showBackButton,
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.primary500),
              onPressed: () => context.pop(),
            )
          : null,
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: TextStyles.title.copyWith(color: AppColors.primary500),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 2.0),
            Text(
              subtitle!,
              style: TextStyles.bodyMedium.copyWith(
                color: AppColors.secondary500,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ],
      ),
      centerTitle: true,

      bottom: showBottomDivider
          ? const PreferredSize(
              preferredSize: Size.fromHeight(1.0),
              child: Divider(
                color: AppColors.surface600,
                height: 1.0,
                thickness: 1.0,
              ),
            )
          : null,
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (showBottomDivider ? 1.0 : 0.0));
}
