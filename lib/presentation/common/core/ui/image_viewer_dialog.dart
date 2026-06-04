import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gal/gal.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:zent_fe/main.dart';
import 'package:zent_fe/presentation/common/core/utils/tap_debounce.dart';

class ImageViewerDialog extends StatefulWidget {
  final String imagePath;

  const ImageViewerDialog({super.key, required this.imagePath});

  static void show(BuildContext context, String imagePath) {
    showGeneralDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.9),
      barrierDismissible: true,
      barrierLabel: 'Close Image',
      pageBuilder: (context, anim1, anim2) =>
          ImageViewerDialog(imagePath: imagePath),
      transitionDuration: const Duration(milliseconds: 200),
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1,
          child: ScaleTransition(
            scale: anim1.drive(Tween(begin: 0.95, end: 1.0)),
            child: child,
          ),
        );
      },
    );
  }

  @override
  State<ImageViewerDialog> createState() => _ImageViewerDialogState();
}

class _ImageViewerDialogState extends State<ImageViewerDialog> {
  final TransformationController _transformationController =
      TransformationController();
  TapDownDetails? _doubleTapDetails;
  bool _isDownloading = false;

  void _handleDoubleTap() {
    if (_transformationController.value != Matrix4.identity()) {
      _transformationController.value = Matrix4.identity();
    } else {
      final position = _doubleTapDetails!.localPosition;
      _transformationController.value = Matrix4.identity()
        ..translateByDouble(-position.dx * 1.5, -position.dy * 1.5, 0.0, 0.0)
        ..scaleByDouble(2.5, 2.5, 1.0, 1.0);
    }
  }

  Future<void> _downloadImage() async {
    if (_isDownloading) return;

    setState(() {
      _isDownloading = true;
    });

    final messenger = rootScaffoldMessengerKey.currentState;

    try {
      final isNetwork =
          widget.imagePath.startsWith('http://') ||
          widget.imagePath.startsWith('https://');

      // Check and request access permission using gal
      final hasAccess = await Gal.hasAccess();
      if (!hasAccess) {
        final granted = await Gal.requestAccess();
        if (!granted) {
          throw Exception("Quyền truy cập thư viện ảnh bị từ chối");
        }
      }

      final tempDir = await getTemporaryDirectory();

      String fileName;
      if (isNetwork) {
        final uri = Uri.parse(widget.imagePath);
        fileName = uri.pathSegments.isNotEmpty ? uri.pathSegments.last : '';
      } else {
        fileName = widget.imagePath.split(Platform.pathSeparator).last;
      }

      if (fileName.contains('?')) {
        fileName = fileName.split('?').first;
      }

      if (fileName.isEmpty) {
        fileName = 'image_${DateTime.now().millisecondsSinceEpoch}';
      }

      if (!fileName.contains('.')) {
        fileName = '$fileName.jpg';
      }

      final nameWithoutExt = fileName.contains('.')
          ? fileName.substring(0, fileName.lastIndexOf('.'))
          : fileName;
      final ext = fileName.contains('.')
          ? fileName.substring(fileName.lastIndexOf('.'))
          : '.jpg';
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final finalFileName = '${nameWithoutExt}_$timestamp$ext';
      final tempFilePath = '${tempDir.path}/$finalFileName';

      List<int> bytes;
      if (isNetwork) {
        final response = await http.get(Uri.parse(widget.imagePath));
        if (response.statusCode == 200) {
          bytes = response.bodyBytes;
        } else {
          throw Exception("HTTP status ${response.statusCode}");
        }
      } else {
        final file = File(widget.imagePath);
        if (await file.exists()) {
          bytes = await file.readAsBytes();
        } else {
          throw Exception("Local file not found");
        }
      }

      final tempFile = File(tempFilePath);
      await tempFile.writeAsBytes(bytes);

      // Save image to the device gallery
      await Gal.putImage(tempFilePath);

      // Delete the temporary file
      try {
        await tempFile.delete();
      } catch (_) {}

      messenger?.showSnackBar(
        SnackBar(
          content: const Text('Đã lưu ảnh vào thư viện thiết bị!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      debugPrint("Error downloading image: $e");
      messenger?.showSnackBar(
        SnackBar(
          content: Text('Không thể tải ảnh: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isDownloading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isNetwork =
        widget.imagePath.startsWith('http://') ||
        widget.imagePath.startsWith('https://');

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Dismiss on tapping outside the image (only if scale is 1.0)
          ThrottledGestureDetector(
            onTap: () {
              if (_transformationController.value == Matrix4.identity()) {
                Navigator.of(context).pop();
              }
            },
            onDoubleTapDown: (details) => _doubleTapDetails = details,
            onDoubleTap: _handleDoubleTap,
            child: Container(color: Colors.transparent),
          ),
          // Zoomable Interactive Viewer
          Center(
            child: InteractiveViewer(
              transformationController: _transformationController,
              minScale: 0.8,
              maxScale: 4.0,
              clipBehavior: Clip.none,
              child: Hero(
                tag: widget.imagePath,
                child: isNetwork
                    ? CachedNetworkImage(
                        imageUrl: widget.imagePath,
                        fit: BoxFit.contain,
                        placeholder: (context, _) => const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        ),
                        errorWidget: (context, urlString, error) =>
                            const Center(
                              child: Icon(
                                Icons.broken_image,
                                color: Colors.white,
                                size: 48,
                              ),
                            ),
                      )
                    : Image.file(
                        File(widget.imagePath),
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            const Center(
                              child: Icon(
                                Icons.broken_image,
                                color: Colors.white,
                                size: 48,
                              ),
                            ),
                      ),
              ),
            ),
          ),
          // Top Bar with Close and Download Buttons
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            right: 16,
            child: SafeArea(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Material(
                    color: Colors.black.withValues(alpha: 0.5),
                    shape: const CircleBorder(),
                    clipBehavior: Clip.antiAlias,
                    child: _isDownloading
                        ? const SizedBox(
                            width: 48,
                            height: 48,
                            child: Padding(
                              padding: EdgeInsets.all(12.0),
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            ),
                          )
                        : IconButton(
                            icon: const Icon(
                              Icons.download,
                              color: Colors.white,
                              size: 24,
                            ),
                            onPressed: _downloadImage,
                            tooltip: 'Tải về',
                          ),
                  ),
                  const SizedBox(width: 12),
                  Material(
                    color: Colors.black.withValues(alpha: 0.5),
                    shape: const CircleBorder(),
                    clipBehavior: Clip.antiAlias,
                    child: IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 24,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      tooltip: 'Đóng',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
