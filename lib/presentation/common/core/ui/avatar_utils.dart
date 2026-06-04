import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';

/// Shared avatar utilities for deterministic initials and background color.
///
/// Why not String.hashCode?
/// Dart's String.hashCode is not guaranteed stable across different
/// isolates, VM restarts, or devices. Two phones running the same app can
/// produce different hashCode values for the same string, resulting in
/// different avatar background colors.
///
/// This file uses the djb2 hash algorithm which is simple, fast, and
/// most importantly deterministic everywhere.
class AvatarUtils {
  AvatarUtils._();

  /// Default color palette for avatar backgrounds.
  static const List<Color> defaultPalette = [
    AppColors.primary300,
    AppColors.secondary400,
    AppColors.tertiary400,
    AppColors.success400,
    AppColors.error400,
    Color(0xFF7E57C2), // deep purple
    Color(0xFF26A69A), // teal
    Color(0xFF5C6BC0), // indigo
  ];

  /// Extract 1-2 character initials from [name].
  static String getInitials(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return '?';

    // Split on one or more whitespace characters
    final whitespace = RegExp(r'\s+');
    final parts = trimmed.split(whitespace);
    if (parts.length > 1) {
      return '${parts[0][0]}${parts.last[0]}'.toUpperCase();
    }
    return trimmed
        .substring(0, trimmed.length < 2 ? trimmed.length : 2)
        .toUpperCase();
  }

  /// Stable djb2 hash: same input always produces the same output regardless
  /// of platform, isolate, or device.
  static int stableHash(String input) {
    int hash = 5381;
    for (int i = 0; i < input.length; i++) {
      hash = ((hash << 5) + hash) + input.codeUnitAt(i); // hash * 33 + c
      hash &= 0x7FFFFFFF; // keep positive 31-bit
    }
    return hash;
  }

  /// Pick a deterministic color from [palette] based on [name].
  static Color getColor(String name, [List<Color>? palette]) {
    final colors = palette ?? defaultPalette;
    final index = stableHash(name) % colors.length;
    return colors[index];
  }

  /// Convert a relative path, filename, or object storage name to a full OCI URL.
  /// If it already starts with http/https or is an asset, it is returned as is.
  /// Also rewrites SVG-by-default placeholder service URLs to PNG so that
  /// Flutter's image decoder (which does not support SVG) can render them.
  static String? getAvatarUrl(String? nameOrUrl) {
    if (nameOrUrl == null || nameOrUrl.trim().isEmpty) return null;
    final trimmed = nameOrUrl.trim();
    if (trimmed.startsWith('http')) return _fixSvgPlaceholderUrl(trimmed);
    if (trimmed.startsWith('assets/')) return trimmed;

    try {
      // Fetch OCI Storage base URL
      final ociBase = dotenv.get("OCI_STORAGE_URL", fallback: "");
      if (ociBase.isEmpty) return trimmed;

      String cleanName = trimmed;
      if (cleanName.startsWith('/')) {
        cleanName = cleanName.substring(1);
      }

      return '$ociBase$cleanName';
    } catch (e) {
      debugPrint("Error resolving avatar url: $e");
      return trimmed;
    }
  }

  /// Rewrites placeholder image service URLs that return SVG by default to
  /// explicitly request PNG format, which Flutter can decode natively.
  ///
  /// Supported services:
  ///  - placehold.co  (e.g. https://placehold.co/600x400/red/white?text=X)
  ///  - via.placeholder.com
  ///  - dummyimage.com
  static String _fixSvgPlaceholderUrl(String url) {
    const svgHosts = ['placehold.co', 'via.placeholder.com', 'dummyimage.com'];

    Uri uri;
    try {
      uri = Uri.parse(url);
    } catch (_) {
      return url;
    }

    final host = uri.host.toLowerCase();
    if (!svgHosts.any((h) => host == h || host.endsWith('.$h'))) {
      return url; // Not a known SVG placeholder — leave unchanged
    }

    // Already has a raster extension → no action needed
    final path = uri.path.toLowerCase();
    if (path.endsWith('.png') ||
        path.endsWith('.jpg') ||
        path.endsWith('.jpeg') ||
        path.endsWith('.webp')) {
      return url;
    }

    // Insert .png before the query string by appending to the path
    final pngUri = uri.replace(path: '${uri.path}.png');
    return pngUri.toString();
  }
}
