import 'package:flutter/material.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';

class PartPhotoEmptyState extends StatelessWidget {
  final VoidCallback onTap;

  const PartPhotoEmptyState({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: const ValueKey("empty"),
      onTap: onTap,
      child: Container(
        height: 115.0,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.surface600,
          border: Border.all(color: AppColors.secondary200, width: 1.0),
          borderRadius: BorderRadius.circular(AppDimens.boraSm),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.camera_alt_outlined,
              color: AppColors.secondary500,
              size: 28,
            ),
            const SizedBox(height: AppDimens.spaceXs),
            Text(
              "Tap to capture part photo",
              style: TextStyles.bodyMedium.copyWith(
                color: AppColors.secondary500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
