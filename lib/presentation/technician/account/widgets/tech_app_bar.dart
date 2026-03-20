import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Core Theming
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';

class TechAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final bool showBottomDivider;

  const TechAppBar({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.showBottomDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.surface100,
      elevation: 0,
      automaticallyImplyLeading: showBackButton,
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.primary500),
              onPressed: () => context.pop(),
            )
          : null,
      title: Text(
        title,
        style: TextStyles.title.copyWith(color: AppColors.primary500),
      ),
      centerTitle: true,

      flexibleSpace: Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Colors.black, width: 1.0)),
        ),
      ),

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
