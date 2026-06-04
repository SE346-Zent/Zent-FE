import 'package:flutter/material.dart';
import 'package:zent_fe/presentation/common/core/utils/tap_debounce.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';

class OperationalQueueTabItem extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const OperationalQueueTabItem({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ThrottledGestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 12.0),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.tertiary500 : Colors.white,
          borderRadius: BorderRadius.circular(20.0),
          border: isSelected ? null : Border.all(color: AppColors.secondary200),
        ),
        child: Text(
          title,
          style: TextStyles.bodyLarge.copyWith(
            color: isSelected ? Colors.white : AppColors.secondary500,
          ),
        ),
      ),
    );
  }
}
