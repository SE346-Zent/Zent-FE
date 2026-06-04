import 'package:flutter/material.dart';
import 'package:zent_fe/presentation/common/core/utils/tap_debounce.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../common/core/themes/colors.dart';
import '../../../common/core/themes/text_styles.dart';
import '../../../common/core/themes/boxshadow.dart';
import 'avatar_utils.dart';

/// A circular user avatar that supports images, initials, and an edit badge.
///
/// **Usage:**
/// ```dart
/// Avatar(name: 'John Doe', imageUrl: 'https://...')
/// ```
///
/// **Features:**
/// - Displays a network image if [imageUrl] is provided.
/// - Fallback: Generates 1-2 character initials from [name].
/// - Fallback: Assigns a persistent random background color based on [name].
/// - Includes a small edit icon badge at the bottom-right.
class Avatar extends StatelessWidget {
  /// Optional URL for the profile image.
  final String? imageUrl;

  /// The user's name, used to generate initials and background color.
  final String name;

  /// Whether to show the edit badge. Defaults to true.
  final bool showEditIcon;

  /// Optional callback when avatar is tapped.
  final VoidCallback? onTap;

  const Avatar({
    super.key,
    this.imageUrl,
    required this.name,
    this.showEditIcon = true,
    this.onTap,
  });

  String get _initials => AvatarUtils.getInitials(name);

  Color get _backgroundColor => AvatarUtils.getColor(name);

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
              color: !hasImage ? _backgroundColor : AppColors.surface100,
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
          if (showEditIcon)
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
      ),
    );
  }
}
