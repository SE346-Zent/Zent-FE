import 'package:flutter/material.dart';
import '../../common/core/themes/colors.dart';
import '../../common/core/themes/dimens.dart';
import '../../common/core/themes/text_styles.dart';

class RoleCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData placeholderIcon;
  final bool isSelected;
  final VoidCallback onTap;

  const RoleCard({
    super.key,
    required this.title,
    required this.description,
    required this.placeholderIcon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity, // Ép thẻ giãn hết chiều ngang
        padding: const EdgeInsets.symmetric(
          vertical: AppDimens.spaceXl, // Tăng khoảng cách trên dưới cho thẻ bớt lùn
          horizontal: AppDimens.spaceLg,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.tertiary50 : AppColors.surface50,
          borderRadius: BorderRadius.circular(AppDimens.boraMd),
          border: Border.all(
            color: isSelected ? AppColors.tertiary500 : AppColors.secondary200,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 1. Icon
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.tertiary100 : AppColors.secondary100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                placeholderIcon,
                color: isSelected ? AppColors.tertiary500 : AppColors.secondary400,
                size: 32,
              ),
            ),
            
            const SizedBox(height: AppDimens.spaceMd),
            
            // 2. Title
            Text(
              title,
              style: TextStyles.title.copyWith(
                color: isSelected ? AppColors.tertiary500 : AppColors.primary500,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: AppDimens.spaceXs),
            
            // 3. Description
            Text(
              description,
              style: TextStyles.bodyMedium.copyWith(color: AppColors.secondary400),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}