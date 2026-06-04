import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

class AppCameraScreen extends StatefulWidget {
  final void Function(String)? onPhotoCaptured;
  const AppCameraScreen({super.key, this.onPhotoCaptured});

  @override
  State<AppCameraScreen> createState() => _AppCameraScreenState();
}

class _AppCameraScreenState extends State<AppCameraScreen> {
  String? _capturedFilePath;
  bool _isPressed = false;
  bool _hasError = false;
  bool _permissionChecked = false;

  @override
  void initState() {
    super.initState();
    _checkCameraPermission();
  }

  Future<void> _checkCameraPermission() async {
    final status = await Permission.camera.status;
    if (!status.isGranted) {
      final requestStatus = await Permission.camera.request();
      if (mounted) {
        setState(() {
          _hasError = !requestStatus.isGranted;
          _permissionChecked = true;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _hasError = false;
          _permissionChecked = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_permissionChecked) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    if (_hasError) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.camera_alt_outlined,
                color: Colors.white54,
                size: 64,
              ),
              const SizedBox(height: 16),
              const Text(
                'Camera is unavailable',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 24),
              TextButton(
                onPressed: () => context.pop(),
                child: const Text(
                  'Go Back',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          if (_capturedFilePath == null) ...[
            Transform.translate(
              offset: const Offset(
                0,
                -60,
              ), // Shifting up further to minimize top black bar
              child: CameraAwesomeBuilder.awesome(
                saveConfig: SaveConfig.photo(
                  pathBuilder: (sensors) async {
                    final Directory extDir = await getTemporaryDirectory();
                    final testDir = await Directory(
                      '${extDir.path}/camerawesome',
                    ).create(recursive: true);
                    final String filePath =
                        '${testDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
                    return SingleCaptureRequest(filePath, sensors.first);
                  },
                ),
                onMediaTap: (media) {},
                sensorConfig: SensorConfig.single(
                  aspectRatio: CameraAspectRatios.ratio_16_9,
                ),
                previewFit: CameraPreviewFit.cover,
                topActionsBuilder: (state) => const SizedBox.shrink(),
                middleContentBuilder: (state) => const SizedBox.shrink(),
                bottomActionsBuilder: (state) {
                  return StreamBuilder<MediaCapture?>(
                    stream: state.captureState$,
                    builder: (context, snapshot) {
                      // Check if a capture just finished
                      final media = snapshot.data;
                      if (media != null &&
                          media.status == MediaCaptureStatus.success) {
                        media.captureRequest.when(
                          single: (single) {
                            if (single.file != null &&
                                _capturedFilePath == null) {
                              Future.microtask(() {
                                if (!mounted) return;
                                setState(
                                  () => _capturedFilePath = single.file!.path,
                                );
                              });
                            }
                          },
                        );
                      }

                      return Transform.translate(
                        offset: const Offset(
                          0,
                          30,
                        ), // Compensate for the top shift to keep button at bottom
                        child: Padding(
                          padding: const EdgeInsets.only(
                            bottom: 30,
                          ), // Positioned in the middle of black bar
                          child: Center(
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTapDown: (_) =>
                                  setState(() => _isPressed = true),
                              onTapUp: (_) =>
                                  setState(() => _isPressed = false),
                              onTapCancel: () =>
                                  setState(() => _isPressed = false),
                              onTap: () {
                                state.when(
                                  onPhotoMode: (photoState) =>
                                      photoState.takePhoto(),
                                );
                              },
                              child: AnimatedScale(
                                scale: _isPressed ? 0.9 : 1.0,
                                duration: const Duration(milliseconds: 100),
                                child: Container(
                                  width: 65,
                                  height: 65,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white.withValues(
                                        alpha: 0.3,
                                      ),
                                      width: 6,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.3,
                                        ),
                                        blurRadius: 10,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ] else ...[
            // Post-Capture State (Stage 2)
            Positioned.fill(
              child: Image.file(File(_capturedFilePath!), fit: BoxFit.cover),
            ),
            Positioned(
              bottom: 30, // Centered in black bar area
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Retake Button
                  _buildActionCircle(
                    icon: Icons.close_rounded,
                    onTap: () => setState(() => _capturedFilePath = null),
                    color: Colors.black54,
                  ),
                  _buildActionCircle(
                    icon: Icons.check_rounded,
                    onTap: () {
                      if (widget.onPhotoCaptured != null) {
                        widget.onPhotoCaptured!(_capturedFilePath!);
                      }
                      context.pop(_capturedFilePath);
                    },
                    color: Colors.black54,
                  ),
                ],
              ),
            ),
          ],
          // Back button (Always visible)
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 20,
            child: GestureDetector(
              onTap: () => context.pop(),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCircle({
    required IconData icon,
    required VoidCallback onTap,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: Icon(icon, color: Colors.white, size: 32),
      ),
    );
  }
}
