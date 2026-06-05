import 'dart:io';
import 'package:flutter/material.dart';
import 'package:zent_fe/presentation/common/core/utils/tap_debounce.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';

class PartPhotoFilledState extends StatelessWidget {
  final List<String> photos;
  final VoidCallback onAddTap;
  final Function(int) onRemoveTap;

  const PartPhotoFilledState({
    super.key,
    required this.photos,
    required this.onAddTap,
    required this.onRemoveTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey("filled"),
      height: 115.0,
      alignment: Alignment.centerLeft,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: photos.length < 5 ? photos.length + 1 : 5,
        separatorBuilder: (_, index) =>
            const SizedBox(width: AppDimens.spaceSm),
        itemBuilder: (context, index) {
          if (index == photos.length) {
            // Add more button
            return Center(
              child: ThrottledGestureDetector(
                onTap: onAddTap,
                child: Container(
                  width: 90.0,
                  height: 90.0,
                  decoration: BoxDecoration(
                    color: AppColors.surface600,
                    border: Border.all(color: AppColors.secondary200),
                    borderRadius: BorderRadius.circular(AppDimens.boraSm),
                  ),
                  child: const Center(
                    child: Icon(Icons.add, color: AppColors.secondary500),
                  ),
                ),
              ),
            );
          }
          final photoPath = photos[index];
          return Center(
            child: Stack(
              children: [
                Container(
                  width: 90.0,
                  height: 90.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppDimens.boraSm),
                    image: DecorationImage(
                      image: FileImage(File(photoPath)),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: ThrottledGestureDetector(
                    onTap: () => onRemoveTap(index),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(4),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
