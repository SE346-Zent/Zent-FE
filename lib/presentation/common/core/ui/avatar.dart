import 'package:flutter/material.dart';
import '../../../common/core/themes/colors.dart';
import '../../../common/core/themes/text_styles.dart';
import '../../../common/core/themes/boxshadow.dart';
import 'dart:math';

class Avatar extends StatelessWidget {
  final String? imageUrl;
  final String name;

  const Avatar({super.key, this.imageUrl, required this.name});

  String get _initials {
    if (name.isEmpty) return 'U';
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length > 1) {
      return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
    }
    return name.substring(0, min(2, name.length)).toUpperCase();
  }

  Color get _randomColor {
    final colors = [
      AppColors.primary300,
      AppColors.secondary400,
      AppColors.tertiary400,
      AppColors.success400,
      AppColors.error400,
    ];
    final index = name.hashCode.abs() % colors.length;
    return colors[index];
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 100.0,
          height: 100.0,
          decoration: BoxDecoration(
            color: imageUrl == null ? _randomColor : AppColors.surface100,
            shape: BoxShape.circle,
            image: imageUrl != null && imageUrl!.isNotEmpty
                ? DecorationImage(
                    image: NetworkImage(imageUrl!),
                    fit: BoxFit.cover,
                  )
                : null,
            border: Border.all(color: AppColors.surface100, width: 3.0),
            boxShadow: [BoxShadowStyles.raised],
          ),
          alignment: Alignment.center,
          child: imageUrl == null || imageUrl!.isEmpty
              ? Text(
                  _initials,
                  style: TextStyles.display.copyWith(
                    color: AppColors.surface100,
                  ),
                )
              : null,
        ),
        Positioned(
          bottom: 4.0,
          right: 4.0,
          child: Container(
            width: 20.0,
            height: 20.0,
            decoration: BoxDecoration(
              color: AppColors.tertiary500,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.surface100, width: 2.0),
            ),
            child: const Icon(
              Icons.edit_outlined,
              size: 10.0,
              color: AppColors.surface100,
            ),
          ),
        ),
      ],
    );
  }
}
