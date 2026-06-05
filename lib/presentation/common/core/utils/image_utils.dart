import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;

class ImageUtils {
  /// Compresses the image at [path] and writes it back to the same path.
  /// If the image is wider than [maxWidth], it will be resized maintaining aspect ratio.
  /// Uses JPEG compression with [quality] (default 80).
  static Future<void> compressImage(
    String path, {
    int maxWidth = 1080,
    int quality = 80,
  }) async {
    try {
      final file = File(path);
      if (!await file.exists()) {
        debugPrint("Image file does not exist at $path");
        return;
      }
      final bytes = await file.readAsBytes();
      final image = img.decodeImage(bytes);
      if (image == null) {
        debugPrint("Failed to decode image at $path");
        return;
      }

      img.Image resized;
      if (image.width > maxWidth) {
        resized = img.copyResize(image, width: maxWidth);
      } else {
        resized = image;
      }

      final compressedBytes = img.encodeJpg(resized, quality: quality);
      await file.writeAsBytes(compressedBytes);
      debugPrint(
        "Image compressed successfully: ${bytes.length} -> ${compressedBytes.length} bytes",
      );
    } catch (e) {
      debugPrint("Error compressing image at $path: $e");
    }
  }
}
