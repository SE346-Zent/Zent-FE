import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/ui/image_viewer_dialog.dart';
import 'package:zent_fe/presentation/common/core/ui/avatar_utils.dart';

/// Centralized network image widget that uses CachedNetworkImage.
///
/// Usage:
/// ```dart
/// AppNetworkImage(
///   url: product.imageUrl,
///   width: 80,
///   height: 80,
///   fit: BoxFit.cover,
/// )
/// ```
///
/// Use [AppNetworkImage.avatar] for circular avatar images.
class AppNetworkImage extends StatelessWidget {
  final String? url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;
  final BorderRadius? borderRadius;
  final bool enableViewer;

  const AppNetworkImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.borderRadius,
    this.enableViewer = false,
  });

  /// Circular avatar variant. Pass [radius] to control size.
  static Widget avatar({
    required String? url,
    double radius = 20,
    Widget? fallback,
  }) {
    final resolvedUrl = AvatarUtils.getAvatarUrl(url);
    if (resolvedUrl == null || resolvedUrl.isEmpty) {
      return fallback ??
          CircleAvatar(
            radius: radius,
            backgroundColor: AppColors.secondary100,
            child: Icon(
              Icons.person,
              size: radius,
              color: AppColors.secondary400,
            ),
          );
    }
    return CachedNetworkImage(
      imageUrl: resolvedUrl,
      imageBuilder: (context, imageProvider) => CircleAvatar(
        radius: radius,
        backgroundImage: imageProvider,
      ),
      placeholder: (context, _) => CircleAvatar(
        radius: radius,
        backgroundColor: AppColors.secondary100,
        child: SizedBox(
          width: radius,
          height: radius,
          child: const CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.tertiary500,
          ),
        ),
      ),
      errorWidget: (context, urlString, error) =>
          fallback ??
          CircleAvatar(
            radius: radius,
            backgroundColor: AppColors.secondary100,
            child: Icon(
              Icons.person,
              size: radius,
              color: AppColors.secondary400,
            ),
          ),
    );
  }

  /// Background image provider (for BoxDecoration / CircleAvatar).
  static CachedNetworkImageProvider provider(String url) {
    final resolved = AvatarUtils.getAvatarUrl(url) ?? url;
    return CachedNetworkImageProvider(resolved);
  }

  @override
  Widget build(BuildContext context) {
    final resolvedUrl = AvatarUtils.getAvatarUrl(url);
    if (resolvedUrl == null || resolvedUrl.isEmpty) {
      return errorWidget ?? _buildError();
    }

    final isNetwork = resolvedUrl.startsWith('http://') || resolvedUrl.startsWith('https://');

    if (!isNetwork) {
      Widget localImage = Image.asset(
        resolvedUrl,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => errorWidget ?? _buildError(),
      );
      if (borderRadius != null) {
        localImage = ClipRRect(borderRadius: borderRadius!, child: localImage);
      }
      return localImage;
    }

    // Use Image.network for better redirect/compatibility (placehold.co, etc.)
    Widget netImage = Image.network(
      resolvedUrl,
      width: width,
      height: height,
      fit: fit,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return placeholder ??
            SizedBox(
              width: width,
              height: height,
              child: const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.tertiary500,
                ),
              ),
            );
      },
      errorBuilder: (context, error, stackTrace) => errorWidget ?? _buildError(),
    );

    Widget resultImage = netImage;
    if (borderRadius != null) {
      resultImage = ClipRRect(borderRadius: borderRadius!, child: netImage);
    }

    if (enableViewer) {
      return GestureDetector(
        onTap: () => ImageViewerDialog.show(context, resolvedUrl),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: resultImage,
        ),
      );
    }

    return resultImage;
  }

  Widget _buildError() {
    return Container(
      width: width,
      height: height,
      color: AppColors.secondary50,
      child: Icon(
        Icons.image_not_supported_outlined,
        color: AppColors.secondary300,
        size: (width != null && height != null) ? (width! * 0.4).clamp(16, 48) : 24,
      ),
    );
  }
}

