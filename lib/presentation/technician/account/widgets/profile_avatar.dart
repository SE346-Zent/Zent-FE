import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

// Core Theming
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/presentation/common/core/themes/boxshadow.dart';
import 'package:zent_fe/presentation/common/core/ui/avatar_utils.dart';

class ProfileAvatar extends StatelessWidget {
  final String? imageUrl;
  final String name;

  const ProfileAvatar({super.key, this.imageUrl, required this.name});

  String get _initials => AvatarUtils.getInitials(name);

  Color get _randomColor => AvatarUtils.getColor(name);

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
                    image: CachedNetworkImageProvider(imageUrl!),
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
          bottom: AppDimens.spaceXs,
          right: AppDimens.spaceXs,
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
