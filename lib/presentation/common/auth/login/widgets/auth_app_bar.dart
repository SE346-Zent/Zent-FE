import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';

class AuthAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const AuthAppBar({
    super.key, 
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.primary500),
        onPressed: () => context.pop(), // GoRouter back navigation
      ),
      title: Text(
        title,
        style: TextStyles.title.copyWith(
          color: AppColors.primary500,
        ),
      ),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}