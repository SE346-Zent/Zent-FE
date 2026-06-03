import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/ui/image_viewer_dialog.dart';

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
    if (url == null || url.isEmpty) {
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
      imageUrl: url,
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
    return CachedNetworkImageProvider(url);
  }

  @override
  Widget build(BuildContext context) {
    if (url == null || url!.isEmpty) {
      return _buildError();
    }

    final image = CachedNetworkImage(
      imageUrl: url!,
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, _) =>
          placeholder ??
          SizedBox(
            width: width,
            height: height,
            child: const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.tertiary500,
              ),
            ),
          ),
      errorWidget: (context, urlString, error) => errorWidget ?? _buildError(),
    );

    Widget resultImage = image;
    if (borderRadius != null) {
      resultImage = ClipRRect(borderRadius: borderRadius!, child: image);
    }

    if (enableViewer) {
      return GestureDetector(
        onTap: () => ImageViewerDialog.show(context, url!),
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

