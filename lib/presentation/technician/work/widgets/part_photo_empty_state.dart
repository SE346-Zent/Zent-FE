import 'package:flutter/material.dart';
import 'package:zent_fe/presentation/common/core/utils/tap_debounce.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'dashed_border_container.dart';

class PartPhotoEmptyState extends StatelessWidget {
  final VoidCallback onTap;
  final String hintText;

  const PartPhotoEmptyState({
    super.key,
    required this.onTap,
    this.hintText = "Tap to capture part photo",
  });

  @override
  Widget build(BuildContext context) {
    return ThrottledGestureDetector(
      key: const ValueKey("empty"),
      onTap: onTap,
      child: DashedBorderContainer(
        height: 115.0,
        color: AppColors.secondary200,
        backgroundColor: AppColors.surface600,
        borderRadius: AppDimens.boraSm,
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
              hintText,
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
