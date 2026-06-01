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
                child:
                    imagePath.startsWith('http') ||
                        imagePath.startsWith('https')
                    ? Image.network(
                        imagePath,
                        width: 64,
                        height: 64,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          debugPrint(
                            '=== [SelectableDeviceCard] Network Image Error for $imagePath: $error ===',
                          );
                          return Container(
                            width: 64,
                            height: 64,
                            color: AppColors.secondary50,
                            child: const Icon(
                              Icons.broken_image,
                              color: AppColors.secondary200,
                              size: 24,
                            ),
                          );
                        },
                      )
                    : imagePath.isNotEmpty
                    ? Image.asset(
                        imagePath,
                        width: 64,
                        height: 64,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 64,
                            height: 64,
                            color: AppColors.secondary50,
                            child: const Icon(
                              Icons.broken_image,
                              color: AppColors.secondary200,
                              size: 24,
                            ),
                          );
                        },
                      )
                    : Container(
                        width: 64,
                        height: 64,
                        color: AppColors.secondary50,
                        child: const Icon(
                          Icons.image_not_supported,
                          color: AppColors.secondary200,
                          size: 24,
                        ),
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
