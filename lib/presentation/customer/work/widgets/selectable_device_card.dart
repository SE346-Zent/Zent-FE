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
          crossAxisAlignment: CrossAxisAlignment.center, // Center vertically
          children: [
            // Image
            RepaintBoundary(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppDimens.boraSm),
                child: Image.asset(
                  imagePath,
                  width: 64, // Slightly larger for better balance
                  height: 64,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: AppDimens.spaceMd),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min, // Hug content
                children: [
                  Text(
                    name,
                    style: TextStyles.title.copyWith(
                      color: AppColors.primary500,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'S/N: $serialNumber',
                    style: TextStyles.label.copyWith(
                      color: AppColors.secondary600,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    'MTM: $mtm',
                    style: TextStyles.label.copyWith(
                      color: AppColors.secondary600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppDimens.spaceSm),
            // Status
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  status,
                  style: TextStyles.label.copyWith(
                    color: AppColors.success500,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
