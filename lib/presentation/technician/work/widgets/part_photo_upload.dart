import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/routing/route_names.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'part_photo_empty_state.dart';
import 'part_photo_filled_state.dart';

class PartPhotoUpload extends StatelessWidget {
  final List<String> photos;
  final Function(String) onPhotoAdded;
  final Function(int) onPhotoRemoved;
  final String title;

  const PartPhotoUpload({
    super.key,
    required this.photos,
    required this.onPhotoAdded,
    required this.onPhotoRemoved,
    this.title = "Part Photo",
  });

  void _navigateToCamera(BuildContext context) {
    context.goNamed(
      RouteNames.appCamera,
      extra: {'onPhotoCaptured': (String path) => onPhotoAdded(path)},
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasPhotos = photos.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyles.middle.copyWith(color: AppColors.primary500),
            ),
            Text(
              "MAX: 5 PHOTOS",
              style: TextStyles.label.copyWith(color: AppColors.secondary500),
            ),
          ],
        ),
        const SizedBox(height: AppDimens.spaceSm),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeOut,
          child: hasPhotos
              ? PartPhotoFilledState(
                  photos: photos,
                  onAddTap: () => _navigateToCamera(context),
                  onRemoveTap: onPhotoRemoved,
                )
              : PartPhotoEmptyState(onTap: () => _navigateToCamera(context)),
        ),
      ],
    );
  }
}
