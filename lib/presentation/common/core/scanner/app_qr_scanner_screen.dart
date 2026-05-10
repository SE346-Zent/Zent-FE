import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'widgets/qr_scanner_overlay.dart';

class AppQrScannerScreen extends StatefulWidget {
  final void Function(String)? onScanned;

  const AppQrScannerScreen({super.key, this.onScanned});

  @override
  State<AppQrScannerScreen> createState() => _AppQrScannerScreenState();
}

class _AppQrScannerScreenState extends State<AppQrScannerScreen> {
  late MobileScannerController _controller;
  bool _isProcessing = false;
  bool _torchOn = false;

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController(
      detectionSpeed: DetectionSpeed.normal,
      facing: CameraFacing.back,
      torchEnabled: false,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_isProcessing) return;

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isNotEmpty) {
      final barcode = barcodes.first.rawValue;
      if (barcode != null && barcode.isNotEmpty) {
        setState(() {
          _isProcessing = true;
        });
        _controller.stop();

        // Fire the callback and navigate back
        widget.onScanned?.call(barcode);
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted) {
            context.pop();
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera Feed
          MobileScanner(controller: _controller, onDetect: _onDetect),

          // Cutout Overlay (The dark background + clear square + 4 white corners)
          Container(
            decoration: ShapeDecoration(
              shape: QrScannerOverlayShape(
                borderColor: AppColors.surface100,
                borderRadius: 4,
                borderLength: 30,
                borderWidth: 6,
                cutOutSize: 250,
                overlayColor: Colors.black.withValues(alpha: 0.65),
              ),
            ),
          ),

          // Top Navigation Header (<- QR SCAN)
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 16.0,
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: AppColors.surface100,
                      size: 28,
                    ),
                    onPressed: () => context.pop(),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "QR SCAN",
                    style: TextStyles.title.copyWith(
                      color: AppColors.surface100,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  // Optional Flashlight Toggle
                  IconButton(
                    icon: Icon(
                      _torchOn ? Icons.flashlight_on : Icons.flashlight_off,
                      color: _torchOn
                          ? AppColors.warning500
                          : AppColors.surface100,
                    ),
                    onPressed: () {
                      _controller.toggleTorch();
                      setState(() {
                        _torchOn = !_torchOn;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),

          // Show spinner if we successfully caught one and are transitioning
          if (_isProcessing)
            const Center(
              child: CircularProgressIndicator(color: AppColors.primary500),
            ),
        ],
      ),
    );
  }
}
