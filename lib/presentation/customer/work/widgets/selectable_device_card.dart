import 'package:flutter/material.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/presentation/common/core/themes/boxshadow.dart';

class SelectableDeviceCard extends StatelessWidget {
  final String imagePath;
  final String name;
  final String serialNumber;
  final String mtm;
  final String status;
  final bool isSelected;
  final VoidCallback onTap;

  const SelectableDeviceCard({
    super.key,
    required this.imagePath,
    required this.name,
    required this.serialNumber,
    required this.mtm,
    required this.status,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = isSelected ? AppColors.tertiary500 : Colors.transparent;
    final shadow = isSelected
        ? [BoxShadowStyles.subtle]
        : [BoxShadowStyles.raised];

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppDimens.boraMd),
          border: Border.all(color: borderColor, width: 2.0),
          boxShadow: shadow,
        ),
        padding: const EdgeInsets.all(AppDimens.spaceMd),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            RepaintBoundary(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppDimens.boraSm),
                child: Image.asset(
                  imagePath,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: AppDimens.spaceMd),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyles.title.copyWith(
                      color: AppColors.primary500,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'S/N: $serialNumber',
                    style: TextStyles.label.copyWith(
                      color: AppColors.secondary600,
                    ),
                  ),
                  Text(
                    'MTM: $mtm',
                    style: TextStyles.label.copyWith(
                      color: AppColors.secondary600,
                    ),
                  ),
                ],
              ),
            ),
            // Status
            Text(
              status,
              style: TextStyles.label.copyWith(
                color: AppColors.success500,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
