import 'dart:io';
import 'package:flutter/material.dart';
import 'package:zent_fe/presentation/common/core/utils/tap_debounce.dart';
import 'package:go_router/go_router.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/presentation/common/core/themes/boxshadow.dart';
import 'package:zent_fe/routing/route_names.dart';
import 'dashed_border_container.dart';
import '../viewmodels/complete_work_order_viewmodel.dart';
import 'package:zent_fe/presentation/common/core/ui/image_viewer_dialog.dart';

class EvidencePhotosSection extends StatelessWidget {
  final CompleteWorkOrderViewModel viewModel;

  const EvidencePhotosSection({super.key, required this.viewModel});

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

          _buildPhotoPhase(
            "Pre-disassembly (Ảnh trước tháo)",
            viewModel.prePhotos,
            'pre',
            context,
          ),
          const SizedBox(height: AppDimens.spaceMd),
          _buildPhotoPhase(
            "Disassembled (Ảnh đang tháo)",
            viewModel.duringPhotos,
            'during',
            context,
          ),
          const SizedBox(height: AppDimens.spaceMd),
          _buildPhotoPhase(
            "Post-assembly (Ảnh hoàn thiện)",
            viewModel.postPhotos,
            'post',
            context,
          ),

          const SizedBox(height: AppDimens.spaceMd),
          Align(
            alignment: Alignment.center,
            child: Text(
              "Max photos for each phase: 5 photos",
              style: TextStyles.label.copyWith(
                color: AppColors.tertiary300,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoPhase(
    String label,
    List<String> photos,
    String phase,
    BuildContext context,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyles.bodyLarge.copyWith(color: AppColors.secondary400),
        ),
        const SizedBox(height: AppDimens.spaceSm),
        if (photos.isEmpty)
          ThrottledGestureDetector(
            onTap: () => _openCamera(context, phase),
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
          )
        else
          SizedBox(
            height: 100,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: photos.length + (photos.length < 5 ? 1 : 0),
              separatorBuilder: (_, _) =>
                  const SizedBox(width: AppDimens.spaceSm),
              itemBuilder: (context, index) {
                if (index == photos.length) {
                  return ThrottledGestureDetector(
                    onTap: () => _openCamera(context, phase),
                    child: Container(
                      width: 100,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.secondary100),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.add,
                        color: AppColors.secondary100,
                      ),
                    ),
                  );
                }
                return _buildPhotoItem(context, photos[index], index, phase);
              },
            ),
          ),
      ],
    );
  }

  Widget _buildPhotoItem(
    BuildContext context,
    String path,
    int index,
    String phase,
  ) {
    return Stack(
      children: [
        ThrottledGestureDetector(
          onTap: () => ImageViewerDialog.show(context, path),
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: FileImage(File(path)),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: ThrottledGestureDetector(
            onTap: () => viewModel.removePhoto(index, phase),
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

  void _openCamera(BuildContext context, String phase) {
    context.pushNamed(
      RouteNames.appCamera,
      extra: {
        'onPhotoCaptured': (String path) => viewModel.addPhoto(path, phase),
      },
    );
  }
}
