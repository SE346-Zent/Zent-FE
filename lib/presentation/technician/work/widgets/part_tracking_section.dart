import 'package:flutter/material.dart';
import 'package:zent_fe/domain/entities/work_order_completion_draft.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/presentation/common/core/themes/boxshadow.dart';
import 'package:zent_fe/presentation/technician/work/viewmodels/complete_work_order_viewmodel.dart';
import 'package:go_router/go_router.dart';
import 'package:zent_fe/routing/route_names.dart' as import_router;

/// Display mode for the part tracking section.
enum PartTrackingMode {
  /// Show both uninstalled and installed cards (original behavior).
  both,

  /// Show only the uninstalled parts card.
  uninstalledOnly,

  /// Show only the installed parts card.
  installedOnly,
}

class PartTrackingSection extends StatelessWidget {
  final CompleteWorkOrderViewModel viewModel;
  final PartTrackingMode mode;

  const PartTrackingSection({
    super.key,
    required this.viewModel,
    this.mode = PartTrackingMode.both,
  });

  @override
  Widget build(BuildContext context) {
    switch (mode) {
      case PartTrackingMode.uninstalledOnly:
        return _buildTrackingCard(
          title: "Part Uninstalled",
          icon: _buildBoxIcon(isDown: true),
          parts: viewModel.uninstalledParts,
          onScanPressed: () => _onScanUninstalledPressed(context),
          onManualPressed: _onManualUninstalledPressed,
          isUninstalled: true,
        );
      case PartTrackingMode.installedOnly:
        return _buildTrackingCard(
          title: "Part Installed",
          icon: _buildBoxIcon(isDown: false),
          parts: viewModel.installedParts,
          onScanPressed: () => _onScanInstalledPressed(context),
          onManualPressed: _onManualInstalledPressed,
          isUninstalled: false,
        );
      case PartTrackingMode.both:
        return Column(
          children: [
            _buildTrackingCard(
              title: "Part Uninstalled",
              icon: _buildBoxIcon(isDown: true),
              parts: viewModel.uninstalledParts,
              onScanPressed: () => _onScanUninstalledPressed(context),
              onManualPressed: _onManualUninstalledPressed,
              isUninstalled: true,
            ),
            const SizedBox(height: AppDimens.spaceLg),
            _buildTrackingCard(
              title: "Part Installed",
              icon: _buildBoxIcon(isDown: false),
              parts: viewModel.installedParts,
              onScanPressed: () => _onScanInstalledPressed(context),
              onManualPressed: _onManualInstalledPressed,
              isUninstalled: false,
            ),
          ],
        );
    }
  }

  void _onScanUninstalledPressed(BuildContext context) {
    context.pushNamed(
      import_router.RouteNames.qrScanner,
      extra: {
        'onScanned': (String result) {
          debugPrint('Scanned Uninstalled Part SN: $result');
        },
      },
    );
  }

  void _onManualUninstalledPressed() {
    debugPrint("action triggered: manual add uninstalled part");
  }

  void _onScanInstalledPressed(BuildContext context) {
    context.pushNamed(
      import_router.RouteNames.qrScanner,
      extra: {
        'onScanned': (String result) {
          debugPrint('Scanned Installed Part SN: $result');
        },
      },
    );
  }

  void _onManualInstalledPressed() {
    debugPrint("action triggered: manual add installed part");
  }

  Widget _buildBoxIcon({required bool isDown}) {
    return CustomPaint(
      size: const Size(29, 29),
      painter: BoxIconPainter(color: AppColors.tertiary500, isDown: isDown),
    );
  }

  Widget _buildTrackingCard({
    required String title,
    required Widget icon,
    required List<TechWorkOrderPart> parts,
    required VoidCallback onScanPressed,
    required VoidCallback onManualPressed,
    required bool isUninstalled,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppDimens.spaceMd),
      decoration: BoxDecoration(
        color: AppColors.surface100,
        borderRadius: BorderRadius.circular(AppDimens.boraMd),
        boxShadow: [BoxShadowStyles.subtle],
        border: Border.all(color: AppColors.secondary50),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              icon,
              const SizedBox(width: AppDimens.spaceSm),
              Text(
                title,
                style: TextStyles.title.copyWith(color: AppColors.primary500),
              ),
            ],
          ),
          const SizedBox(height: AppDimens.spaceMd),
          ...parts.map((part) => _buildPartListItem(part, isUninstalled)),
          const SizedBox(height: AppDimens.spaceLg),
          Row(
            children: [
              Expanded(
                child: _buildButton(
                  label: "Scanner",
                  icon: Icons.qr_code_scanner,
                  onPressed: onScanPressed,
                  isPrimary: true,
                ),
              ),
              const SizedBox(width: AppDimens.spaceMd),
              Expanded(
                child: _buildButton(
                  label: "Manual",
                  icon: Icons.add,
                  onPressed: onManualPressed,
                  isPrimary: false,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPartListItem(TechWorkOrderPart part, bool isUninstalled) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimens.spaceSm),
      padding: const EdgeInsets.only(
        left: AppDimens.spaceMd,
        top: AppDimens.spaceSm,
        bottom: AppDimens.spaceSm,
      ),
      decoration: BoxDecoration(
        color: AppColors.background500,
        borderRadius: BorderRadius.circular(AppDimens.boraSm),
        border: Border.all(color: AppColors.secondary50),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  part.name,
                  style: TextStyles.bodyLarge.copyWith(
                    color: AppColors.secondary500,
                  ),
                ),
                if (part.serialNumber != null)
                  Text(
                    "S/N: ${part.serialNumber}",
                    style: TextStyles.label.copyWith(
                      color: AppColors.secondary300,
                    ),
                  ),
              ],
            ),
          ),
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            icon: const Icon(
              Icons.delete_outline,
              color: AppColors.error500,
              size: 29,
            ),
            onPressed: () {
              if (isUninstalled) {
                viewModel.removeUninstalledPart(part.id);
              } else {
                viewModel.removeInstalledPart(part.id);
              }
            },
          ),
          const SizedBox(width: AppDimens.spaceXs),
        ],
      ),
    );
  }

  Widget _buildButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
    required bool isPrimary,
  }) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: isPrimary
            ? AppColors.tertiary500
            : AppColors.tertiary50.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppDimens.boraSm),
        boxShadow: isPrimary ? [BoxShadowStyles.glowing] : null,
        border: isPrimary ? null : Border.all(color: AppColors.tertiary100),
      ),
      child: TextButton.icon(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.boraSm),
          ),
        ),
        icon: Icon(
          icon,
          size: 31,
          color: isPrimary ? AppColors.surface100 : AppColors.tertiary500,
        ),
        label: Text(
          label,
          style: TextStyles.middle.copyWith(
            color: isPrimary ? AppColors.surface100 : AppColors.tertiary500,
          ),
        ),
      ),
    );
  }
}

class BoxIconPainter extends CustomPainter {
  final Color color;
  final bool isDown;

  BoxIconPainter({required this.color, required this.isDown});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final w = size.width;
    final h = size.height;

    // 1. Box Sides and Gap (65% gap)
    final shellPath = Path();

    shellPath.moveTo(w * 0.08, h * 0.41);
    shellPath.lineTo(w * 0.08, h * 0.83);
    shellPath.quadraticBezierTo(w * 0.08, h * 0.91, w * 0.16, h * 0.91);
    shellPath.lineTo(w * 0.23, h * 0.91);

    shellPath.moveTo(w * 0.91, h * 0.41);
    shellPath.lineTo(w * 0.91, h * 0.83);
    shellPath.quadraticBezierTo(w * 0.91, h * 0.91, w * 0.83, h * 0.91);
    shellPath.lineTo(w * 0.77, h * 0.91);

    // 2. Widened Top Flaps
    shellPath.moveTo(w * 0.08, h * 0.41);
    shellPath.lineTo(w * 0.29, h * 0.16);
    shellPath.lineTo(w * 0.70, h * 0.16);
    shellPath.lineTo(w * 0.91, h * 0.41);

    shellPath.moveTo(w * 0.08, h * 0.41);
    shellPath.lineTo(w * 0.91, h * 0.41);

    shellPath.moveTo(w * 0.5, h * 0.16);
    shellPath.lineTo(w * 0.5, h * 0.41);

    canvas.drawPath(shellPath, paint);

    // 3. Arrow
    if (isDown) {
      canvas.drawLine(
        Offset(w * 0.5, h * 0.56),
        Offset(w * 0.5, h * 0.91),
        paint,
      );
      canvas.drawLine(
        Offset(w * 0.5, h * 0.91),
        Offset(w * 0.38, h * 0.75),
        paint,
      );
      canvas.drawLine(
        Offset(w * 0.5, h * 0.91),
        Offset(w * 0.62, h * 0.75),
        paint,
      );
    } else {
      canvas.drawLine(
        Offset(w * 0.5, h * 0.91),
        Offset(w * 0.5, h * 0.55),
        paint,
      );
      canvas.drawLine(
        Offset(w * 0.5, h * 0.55),
        Offset(w * 0.38, h * 0.71),
        paint,
      );
      canvas.drawLine(
        Offset(w * 0.5, h * 0.55),
        Offset(w * 0.62, h * 0.71),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
