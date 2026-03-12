import 'package:flutter/material.dart';
import '../themes/colors.dart';
import '../themes/dimens.dart';
import '../themes/text_styles.dart';
import '../themes/boxshadow.dart';

class PrimaryActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const PrimaryActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 364.0,
      height: 49.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimens.boraMd),
        boxShadow: [BoxShadowStyles.subtle],
      ),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 24.0),
        label: Text(
          label,
          style: TextStyles.title.copyWith(color: AppColors.surface100),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.tertiary500,
          foregroundColor: AppColors.surface100,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.boraMd),
          ),
          elevation: 0,
        ),
      ),
    );
  }
}
