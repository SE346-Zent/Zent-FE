import 'package:flutter/material.dart';
import '../../../common/core/themes/colors.dart';
import '../../../common/core/themes/text_styles.dart';

class AddUserFab extends StatelessWidget {
  final VoidCallback onPressed;

  const AddUserFab({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 61.0,
      height: 61.0,
      margin: const EdgeInsets.only(bottom: 24.0, right: 8.0),
      decoration: BoxDecoration(
        color: AppColors.tertiary400,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary800.withValues(alpha: 0.25),
            blurRadius: 10.0,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: onPressed,
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Text(
          '+',
          style: TextStyles.display.copyWith(
            color: AppColors.surface100,
            height: 1.0,
          ),
        ),
      ),
    );
  }
}
