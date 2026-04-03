import 'package:flutter/material.dart';
import '../../../../presentation/common/core/themes/colors.dart';
import '../../../../presentation/common/core/themes/dimens.dart';
import '../../../../presentation/common/core/themes/text_styles.dart';
import '../../../../presentation/common/core/themes/boxshadow.dart';

class SelectableServiceCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const SelectableServiceCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppDimens.spaceMd),
        decoration: BoxDecoration(
          color: AppColors.surface50,
          borderRadius: BorderRadius.circular(AppDimens.boraMd),
          border: Border.all(
            color: isSelected ? AppColors.primary500 : AppColors.secondary100,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [BoxShadowStyles.subtle],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppDimens.spaceSm),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary50 : AppColors.surface100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isSelected
                    ? AppColors.primary500
                    : AppColors.secondary500,
                size: 24,
              ),
            ),
            const SizedBox(width: AppDimens.spaceMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyles.title.copyWith(
                      color: isSelected ? AppColors.primary500 : Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppDimens.spaceXs),
                  Text(
                    description,
                    style: TextStyles.bodyMedium.copyWith(
                      color: AppColors.secondary500,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Container(
                margin: const EdgeInsets.only(left: AppDimens.spaceSm),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary500,
                ),
                child: const Icon(
                  Icons.check,
                  color: AppColors.surface50,
                  size: 16,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
