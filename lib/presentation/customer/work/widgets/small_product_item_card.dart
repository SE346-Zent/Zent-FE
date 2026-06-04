import 'package:flutter/material.dart';
import 'package:zent_fe/presentation/common/core/utils/tap_debounce.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/presentation/common/core/themes/boxshadow.dart';
import 'package:zent_fe/presentation/common/core/ui/app_network_image.dart';

class SmallProductItemCard extends StatelessWidget {
  final String name;
  final String status;
  final String imagePath;
  final bool isSelected;
  final VoidCallback onTap;

  const SmallProductItemCard({
    super.key,
    required this.name,
    required this.status,
    required this.imagePath,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isExpiring = status.toLowerCase() == 'expiring';
    final badgeColor = isExpiring ? AppColors.error50 : AppColors.success50;
    final badgeTextColor = isExpiring
        ? AppColors.error500
        : AppColors.success500;
    final borderColor = isSelected
        ? AppColors.tertiary500
        : AppColors.secondary100;

    return ThrottledGestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 138,
        height: 99,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppDimens.boraSm),
          boxShadow: [BoxShadowStyles.raised],
          border: Border.all(color: borderColor, width: isSelected ? 2.0 : 1.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Expanded(
              child: AppNetworkImage(
                url: imagePath,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppDimens.boraSm - 1),
                  topRight: Radius.circular(AppDimens.boraSm - 1),
                ),
              ),
            ),
            // Details
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Status Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 1,
                    ),
                    decoration: BoxDecoration(
                      color: badgeColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      status,
                      style: TextStyles.label.copyWith(
                        color: badgeTextColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 8,
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  // Name
                  Text(
                    name,
                    style: TextStyles.bodyMedium.copyWith(
                      color: Colors.black,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
