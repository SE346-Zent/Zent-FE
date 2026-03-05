import 'package:flutter/material.dart';
import '../../../common/core/themes/colors.dart';
import '../../../common/core/themes/dimens.dart';
import '../../../common/core/themes/text_styles.dart';

class ProfileLogoutButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ProfileLogoutButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 364.0,
      height: 49.0,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.tertiary500,
          foregroundColor: AppColors.surface100,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.boraMd),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.logout, size: 24.0),
            const SizedBox(width: AppDimens.spaceSm),
            Text(
              'Sign Out',
              style: TextStyles.title.copyWith(color: AppColors.surface100),
            ),
            const SizedBox(
              width: 24.0 + AppDimens.spaceSm,
            ), // Balances the icon width and spacing so text is perfectly centered
          ],
        ),
      ),
    );
  }
}
