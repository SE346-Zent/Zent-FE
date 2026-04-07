import 'package:flutter/material.dart';
import 'package:zent_fe/domain/entities/work_order_completion_draft.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/presentation/common/core/themes/boxshadow.dart';
import '../view_models/complete_work_order_viewmodel.dart';

class PartTrackingSection extends StatelessWidget {
  final CompleteWorkOrderViewModel viewModel;

  const PartTrackingSection({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTrackingCard(
          title: "Part Uninstalled",
          icon: _buildBoxIcon(isDown: true),
          parts: viewModel.uninstalledParts,
          onScanPressed: () {},
          onManualPressed: () {},
          isUninstalled: true,
        ),
        const SizedBox(height: AppDimens.spaceLg),
        _buildTrackingCard(
          title: "Part Installed",
          icon: _buildBoxIcon(isDown: false),
          parts: viewModel.installedParts,
          onScanPressed: () {},
          onManualPressed: () {},
          isUninstalled: false,
        ),
      ],
    );
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

    // Proportional coordinates based on a 24x24 grid
    // x: 2/24=0.083, 5.5/24=0.23, 12/24=0.5, 18.5/24=0.77, 22/24=0.91
    // y: 4/24=0.166, 10/24=0.41, 11.5/24=0.48, 14.8/24=0.62, 18.7/24=0.78, 22/24=0.91

    // 1. Box Sides and Gap (65% gap)
    final shellPath = Path();

    // Left side + bottom part (35% bars total -> 17.5% each)
    shellPath.moveTo(w * 0.08, h * 0.41); // (2, 10)
    shellPath.lineTo(w * 0.08, h * 0.83); // (2, 20)
    shellPath.quadraticBezierTo(
      w * 0.08,
      h * 0.91,
      w * 0.16,
      h * 0.91,
    ); // Corner to (4, 22)
    shellPath.lineTo(w * 0.23, h * 0.91); // To (~5.5, 22) - 3.5 units bar

    // Right side + bottom part
    shellPath.moveTo(w * 0.91, h * 0.41); // (22, 10)
    shellPath.lineTo(w * 0.91, h * 0.83); // (22, 20)
    shellPath.quadraticBezierTo(
      w * 0.91,
      h * 0.91,
      w * 0.83,
      h * 0.91,
    ); // Corner to (20, 22)
    shellPath.lineTo(w * 0.77, h * 0.91); // To (~18.5, 22) - 3.5 units bar

    // 2. Widened Top Flaps
    shellPath.moveTo(w * 0.08, h * 0.41);
    shellPath.lineTo(w * 0.29, h * 0.16);
    shellPath.lineTo(w * 0.70, h * 0.16);
    shellPath.lineTo(w * 0.91, h * 0.41);

    // Horizontal divider
    shellPath.moveTo(w * 0.08, h * 0.41);
    shellPath.lineTo(w * 0.91, h * 0.41);

    // Vertical flap divider
    shellPath.moveTo(w * 0.5, h * 0.16);
    shellPath.lineTo(w * 0.5, h * 0.41);

    canvas.drawPath(shellPath, paint);

    // 3. Medium-Short & Narrow Arrow
    if (isDown) {
      // Uninstall: Down arrow
      // Stem starts at h*0.56 (middle ground) and ends at bottom line (h*0.91)
      canvas.drawLine(
        Offset(w * 0.5, h * 0.56),
        Offset(w * 0.5, h * 0.91),
        paint,
      );
      // Narrow head at (12, 22)
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
      // Install: Up arrow
      // Stem starts at h*0.91 (exactly in the gap) and ends at h*0.55
      canvas.drawLine(
        Offset(w * 0.5, h * 0.91),
        Offset(w * 0.5, h * 0.55),
        paint,
      );
      // Narrow head at h*0.55
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
