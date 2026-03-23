import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class AppCameraScreen extends StatefulWidget {
  const AppCameraScreen({super.key});

  @override
  State<AppCameraScreen> createState() => _AppCameraScreenState();
}

class _AppCameraScreenState extends State<AppCameraScreen> {
  String? _capturedFilePath;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          if (_capturedFilePath == null)
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
                              Future.microtask(
                                () => setState(
                                  () => _capturedFilePath = single.file!.path,
                                ),
                              );
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
            )
          else
            // Post-Capture State (Stage 2)
            Stack(
              children: [
                Positioned.fill(
                  child: Image.file(
                    File(_capturedFilePath!),
                    fit: BoxFit.cover,
                  ),
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
                      // Approve Button
                      _buildActionCircle(
                        icon: Icons.check_rounded,
                        onTap: () => context.pop(_capturedFilePath),
                        color: Colors.black54,
                      ),
                    ],
                  ),
                ),
              ],
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
