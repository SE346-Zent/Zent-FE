import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:zent_fe/presentation/common/core/ui/zent_error_popup.dart';
import 'profile_input_field.dart';
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
          onManualPressed: () => _onManualUninstalledPressed(context),
          isUninstalled: true,
        );
      case PartTrackingMode.installedOnly:
        return _buildTrackingCard(
          title: "Part Installed",
          icon: _buildBoxIcon(isDown: false),
          parts: viewModel.installedParts,
          onScanPressed: () => _onScanInstalledPressed(context),
          onManualPressed: () => _onManualInstalledPressed(context),
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
              onManualPressed: () => _onManualUninstalledPressed(context),
              isUninstalled: true,
            ),
            const SizedBox(height: AppDimens.spaceLg),
            _buildTrackingCard(
              title: "Part Installed",
              icon: _buildBoxIcon(isDown: false),
              parts: viewModel.installedParts,
              onScanPressed: () => _onScanInstalledPressed(context),
              onManualPressed: () => _onManualInstalledPressed(context),
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
          try {
            final decoded = jsonDecode(result);
            if (decoded is Map && decoded.length == 3) {
              String? partIdVal;
              String? partNameVal;
              String? snVal;
              decoded.forEach((k, v) {
                final keyLower = k.toString().toLowerCase();
                if (keyLower == 'part_id' || keyLower == 'partid') {
                  partIdVal = v.toString();
                }
                if (keyLower == 'part_name' || keyLower == 'partname') {
                  partNameVal = v.toString();
                }
                if (keyLower == 'sn') {
                  snVal = v.toString();
                }
              });
              if (partIdVal != null && partNameVal != null && snVal != null) {
                viewModel.addUninstalledPart(partIdVal!, partNameVal!, snVal!);
                return;
              }
            }
            ZentErrorPopup.show(context, 'QR không hỗ trợ');
          } catch (e) {
            ZentErrorPopup.show(context, 'QR không hỗ trợ');
          }
        },
      },
    );
  }

  void _onManualUninstalledPressed(BuildContext context) {
    _showAddPartDialog(context, isUninstalled: true);
  }

  void _onScanInstalledPressed(BuildContext context) {
    context.pushNamed(
      import_router.RouteNames.qrScanner,
      extra: {
        'onScanned': (String result) {
          try {
            final decoded = jsonDecode(result);
            if (decoded is Map && decoded.length == 3) {
              String? partIdVal;
              String? partNameVal;
              String? snVal;
              decoded.forEach((k, v) {
                final keyLower = k.toString().toLowerCase();
                if (keyLower == 'part_id' || keyLower == 'partid') {
                  partIdVal = v.toString();
                }
                if (keyLower == 'part_name' || keyLower == 'partname') {
                  partNameVal = v.toString();
                }
                if (keyLower == 'sn') {
                  snVal = v.toString();
                }
              });
              if (partIdVal != null && partNameVal != null && snVal != null) {
                viewModel.addInstalledPart(partIdVal!, partNameVal!, snVal!);
                return;
              }
            }
            ZentErrorPopup.show(context, 'QR không hỗ trợ');
          } catch (e) {
            ZentErrorPopup.show(context, 'QR không hỗ trợ');
          }
        },
      },
    );
  }

  void _onManualInstalledPressed(BuildContext context) {
    _showAddPartDialog(context, isUninstalled: false);
  }

  void _showAddPartDialog(BuildContext context, {required bool isUninstalled}) {
    final idController = TextEditingController();
    final snController = TextEditingController();
    final nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(
            isUninstalled ? "Add Uninstalled Part" : "Add Installed Part",
            style: TextStyles.title.copyWith(color: AppColors.primary500),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ProfileInputField(
                label: "Part ID",
                hintText: "e.g. 11111111-2222-3333-4444-555555555551",
                controller: idController,
                labelColor: AppColors.secondary400,
                showSubtleShadow: true,
              ),
              const SizedBox(height: AppDimens.spaceMd),
              ProfileInputField(
                label: "Serial Number",
                hintText: "e.g. SN-123456",
                controller: snController,
                labelColor: AppColors.secondary400,
                showSubtleShadow: true,
              ),
              const SizedBox(height: AppDimens.spaceMd),
              ProfileInputField(
                label: "Part Name",
                hintText: "e.g. WiFi Adapter",
                controller: nameController,
                labelColor: AppColors.secondary400,
                showSubtleShadow: true,
              ),
            ],
          ),
          actionsPadding: const EdgeInsets.symmetric(
            horizontal: AppDimens.spaceMd,
            vertical: AppDimens.spaceSm,
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.secondary200),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () => Navigator.pop(ctx),
                    child: Text(
                      'Cancel',
                      style: TextStyles.bodyLarge.copyWith(
                        color: AppColors.primary500,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppDimens.spaceMd),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.tertiary500,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () {
                      final partId = idController.text.trim();
                      final sn = snController.text.trim();
                      final partName = nameController.text.trim();
                      if (partId.isEmpty) {
                        ScaffoldMessenger.of(ctx).showSnackBar(
                          const SnackBar(
                            content: Text("Part ID cannot be empty"),
                            backgroundColor: AppColors.error500,
                          ),
                        );
                        return;
                      }
                      if (partName.isEmpty) {
                        ScaffoldMessenger.of(ctx).showSnackBar(
                          const SnackBar(
                            content: Text("Part Name cannot be empty"),
                            backgroundColor: AppColors.error500,
                          ),
                        );
                        return;
                      }
                      if (isUninstalled) {
                        viewModel.addUninstalledPart(
                          partId,
                          partName,
                          sn.isEmpty ? null : sn,
                        );
                      } else {
                        viewModel.addInstalledPart(
                          partId,
                          partName,
                          sn.isEmpty ? null : sn,
                        );
                      }
                      Navigator.pop(ctx);
                    },
                    child: Text(
                      'Add',
                      style: TextStyles.bodyLarge.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
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
        border: Border.all(color: AppColors.secondary300),
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
          if (!viewModel.isReadOnly) ...[
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
        ],
      ),
    );
  }

  Widget _buildPartListItem(TechWorkOrderPart part, bool isUninstalled) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimens.spaceSm),
      padding: EdgeInsets.only(
        left: AppDimens.spaceMd,
        top: AppDimens.spaceSm,
        bottom: AppDimens.spaceSm,
        right: viewModel.isReadOnly ? AppDimens.spaceMd : 0,
      ),
      decoration: BoxDecoration(
        color: AppColors.tertiary50,
        borderRadius: BorderRadius.circular(AppDimens.boraSm),
        border: Border.all(color: AppColors.secondary200),
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
          if (!viewModel.isReadOnly)
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
