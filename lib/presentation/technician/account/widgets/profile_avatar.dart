import 'package:flutter/material.dart';
import 'package:zent_fe/presentation/common/core/utils/tap_debounce.dart';
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
  final VoidCallback? onTap;

  const ProfileAvatar({
    super.key,
    this.imageUrl,
    required this.name,
    this.onTap,
  });

  String get _initials => AvatarUtils.getInitials(name);

  Color get _randomColor => AvatarUtils.getColor(name);

  @override
  Widget build(BuildContext context) {
    final resolvedUrl = AvatarUtils.getAvatarUrl(imageUrl);
    final hasImage = resolvedUrl != null && resolvedUrl.isNotEmpty;

    return ThrottledGestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            width: 100.0,
            height: 100.0,
            decoration: BoxDecoration(
              color: !hasImage ? _randomColor : AppColors.surface100,
              shape: BoxShape.circle,
              image: hasImage
                  ? DecorationImage(
                      image: CachedNetworkImageProvider(resolvedUrl),
                      fit: BoxFit.cover,
                    )
                  : null,
              border: Border.all(color: AppColors.surface100, width: 3.0),
              boxShadow: [BoxShadowStyles.raised],
            ),
            alignment: Alignment.center,
            child: !hasImage
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
      ),
    );
  }
}
