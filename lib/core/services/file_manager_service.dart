import 'dart:io';
import 'package:flutter/services.dart';

/// Bridges to the native [MethodChannel] defined in MainActivity.kt
/// to open a folder in the system file manager app.
class FileManagerService {
  static const _channel = MethodChannel('zent_fe/file_manager');

  /// Opens the directory at [folderPath] in the system Files app.
  /// On Android this launches DocumentsUI pointing at the Downloads directory.
  /// On other platforms it falls back to a no-op (iOS has no general file browser).
  static Future<void> openFolder(String folderPath) async {
    if (Platform.isAndroid) {
      await _channel.invokeMethod<void>('openFolder', {'path': folderPath});
    }
    // iOS: nothing to do — files are accessible via the Files app automatically
  }
}
