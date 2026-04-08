import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/presentation/common/core/themes/boxshadow.dart';
import 'package:zent_fe/routing/route_names.dart';
import 'package:zent_fe/presentation/technician/work/widgets/dashed_border_container.dart';

/// A reusable, single-phase evidence photo section.
///
/// Renders one photo phase inside a card with a title icon, phase label,
/// max-photos note, and a photo capture area.
///
/// [phaseLabel] — e.g. "Pre-disassembly (Ảnh trước tháo)"
/// [photos] — current list of photo file paths for this phase
/// [phaseKey] — key used by the viewmodel to identify the phase ('pre', 'during', 'post')
/// [maxPhotos] — max number of photos allowed (default 5)
/// [maxPhotosNote] — text shown for the max note (default "Max photos: 5")
/// [maxPhotosPosition] — when `inline`, note is right-aligned next to the label;
///                        when `below`, note is centered below all photos.
/// [onPhotoAdded] — callback when a photo is captured
/// [onPhotoRemoved] — callback when a photo is removed
class SinglePhaseEvidencePhotos extends StatelessWidget {
  final String phaseLabel;
  final List<String> photos;
  final String phaseKey;
  final int maxPhotos;
  final String maxPhotosNote;
  final MaxPhotosPosition maxPhotosPosition;
  final void Function(String path) onPhotoAdded;
  final void Function(int index) onPhotoRemoved;

  const SinglePhaseEvidencePhotos({
    super.key,
    required this.phaseLabel,
    required this.photos,
    required this.phaseKey,
    this.maxPhotos = 5,
    this.maxPhotosNote = "Max photos: 5",
    this.maxPhotosPosition = MaxPhotosPosition.inline,
    required this.onPhotoAdded,
    required this.onPhotoRemoved,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimens.spaceMd),
      decoration: BoxDecoration(
        color: AppColors.surface100,
        borderRadius: BorderRadius.circular(AppDimens.boraMd),
        boxShadow: [BoxShadowStyles.subtle],
        border: Border.all(color: AppColors.secondary50),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.camera_alt_outlined,
                color: AppColors.tertiary500,
                size: 31,
              ),
              const SizedBox(width: AppDimens.spaceSm),
              Text(
                "Evidence photos",
                style: TextStyles.title.copyWith(color: AppColors.primary500),
              ),
            ],
          ),
          const SizedBox(height: AppDimens.spaceSm),
          _buildPhaseContent(context),
        ],
      ),
    );
  }

  Widget _buildPhaseContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPhaseLabel(),
        const SizedBox(height: AppDimens.spaceSm),
        _buildPhotoArea(context),
        if (maxPhotosPosition == MaxPhotosPosition.below) ...[
          const SizedBox(height: AppDimens.spaceMd),
          Align(
            alignment: Alignment.center,
            child: Text(
              maxPhotosNote,
              style: TextStyles.label.copyWith(
                color: AppColors.tertiary300,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPhaseLabel() {
    if (maxPhotosPosition == MaxPhotosPosition.inline) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              phaseLabel,
              style: TextStyles.bodyLarge.copyWith(
                color: AppColors.secondary400,
              ),
            ),
          ),
          Text(
            maxPhotosNote,
            style: TextStyles.label.copyWith(
              color: AppColors.tertiary300,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );
    }

    return Text(
      phaseLabel,
      style: TextStyles.bodyLarge.copyWith(color: AppColors.secondary400),
    );
  }

  Widget _buildPhotoArea(BuildContext context) {
    if (photos.isEmpty) {
      return GestureDetector(
        onTap: () => _onOpenCamera(context),
        child: Container(
          width: double.infinity,
          height: 100,
          decoration: BoxDecoration(
            color: AppColors.background500.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(AppDimens.boraSm),
          ),
          child: const DashedBorderContainer(
            child: Center(
              child: Text(
                "Tap to capture",
                style: TextStyle(color: AppColors.secondary300),
              ),
            ),
          ),
        ),
      );
    }

    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: photos.length + (photos.length < maxPhotos ? 1 : 0),
        separatorBuilder: (context, index) =>
            const SizedBox(width: AppDimens.spaceSm),
        itemBuilder: (context, index) {
          if (index == photos.length) {
            return GestureDetector(
              onTap: () => _onOpenCamera(context),
              child: Container(
                width: 100,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.secondary100),
                  borderRadius: BorderRadius.circular(AppDimens.boraSm),
                ),
                child: const Icon(Icons.add, color: AppColors.secondary100),
              ),
            );
          }
          return _buildPhotoItem(photos[index], index);
        },
      ),
    );
  }

  Widget _buildPhotoItem(String path, int index) {
    return Stack(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimens.boraSm),
            image: DecorationImage(
              image: FileImage(File(path)),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: () => onPhotoRemoved(index),
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, color: Colors.white, size: 16),
            ),
          ),
        ),
      ],
    );
  }

  void _onOpenCamera(BuildContext context) {
    context.pushNamed(
      RouteNames.appCamera,
      extra: {'onPhotoCaptured': (String path) => onPhotoAdded(path)},
    );
  }
}

enum MaxPhotosPosition { inline, below }
