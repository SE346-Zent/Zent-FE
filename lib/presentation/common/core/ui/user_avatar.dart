import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'avatar_utils.dart';

/// A reusable circular avatar that generates initials + color from [name].
///
/// **Behavior:**
/// - If [avatarUrl] is provided and non-empty → shows network image.
/// - Otherwise → generates 1-2 character initials from [name] with a
///   deterministic background color (same name always → same color).
///
/// **Future-proof:** When the backend adds `avatar_url`, just pass it in.
/// If `null`, the fallback initials are shown automatically.
class UserAvatar extends StatelessWidget {
  /// Optional avatar URL from the backend (null = use initials fallback).
  final String? avatarUrl;

  /// The user's display name, used to generate initials and background color.
  final String name;

  /// Diameter of the avatar in logical pixels.
  final double size;

  const UserAvatar({
    super.key,
    this.avatarUrl,
    required this.name,
    this.size = 40,
  });

  String get _initials => AvatarUtils.getInitials(name);

  /// Deterministic color from stable hash – same name always produces the same color
  /// on every device, isolate, and app restart.
  Color get _backgroundColor => AvatarUtils.getColor(name);

  @override
  Widget build(BuildContext context) {
    final resolvedUrl = AvatarUtils.getAvatarUrl(avatarUrl);
    final hasImage = resolvedUrl != null && resolvedUrl.isNotEmpty;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: hasImage ? const Color(0xFFFAFAFA) : _backgroundColor,
        shape: BoxShape.circle,
        image: hasImage
            ? DecorationImage(
                image: CachedNetworkImageProvider(resolvedUrl),
                fit: BoxFit.cover,
              )
            : null,
      ),
      alignment: Alignment.center,
      child: hasImage
          ? null
          : Text(
              _initials,
              style: TextStyles.middle.copyWith(
                color: Colors.white,
                fontSize: size * 0.38,
                fontWeight: FontWeight.w600,
              ),
            ),
    );
  }
}
