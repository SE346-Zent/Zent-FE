import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:zent_fe/presentation/common/core/ui/zent_error_popup.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/presentation/common/core/themes/boxshadow.dart';
import 'profile_input_field.dart';
import '../viewmodels/complete_work_order_viewmodel.dart';
import 'package:go_router/go_router.dart';
import 'package:zent_fe/routing/route_names.dart' as import_router;

class MachineInfoSection extends StatelessWidget {
  final CompleteWorkOrderViewModel viewModel;

  const MachineInfoSection({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
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
              const Icon(Icons.memory, color: AppColors.tertiary500, size: 36),
              const SizedBox(width: AppDimens.spaceSm),
              Text(
                "Machine Information",
                style: TextStyles.title.copyWith(color: AppColors.primary500),
              ),
            ],
          ),
          const SizedBox(height: AppDimens.spaceMd),
          Row(
            children: [
              Expanded(
                child: ProfileInputField(
                  label: "MTM",
                  hintText: "e.g 234931043",
                  controller: viewModel.mtmController,
                  labelColor: AppColors.secondary400,
                  showSubtleShadow: true,
                  enabled: !viewModel.isReadOnly,
                ),
              ),
              const SizedBox(width: AppDimens.spaceMd),
              Expanded(
                child: ProfileInputField(
                  label: "Serial Number",
                  hintText: "e.g 123456",
                  controller: viewModel.serialNumberController,
                  labelColor: AppColors.secondary400,
                  showSubtleShadow: true,
                  enabled: !viewModel.isReadOnly,
                ),
              ),
            ],
          ),
          if (!viewModel.isReadOnly) ...[
            const SizedBox(height: AppDimens.spaceLg),
            _buildLongScannerButton(context),
          ],
        ],
      ),
    );
  }

  Widget _buildLongScannerButton(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.tertiary500,
        borderRadius: BorderRadius.circular(AppDimens.boraSm),
        boxShadow: [BoxShadowStyles.glowing],
      ),
      child: TextButton.icon(
        icon: const Icon(
          Icons.qr_code_scanner,
          color: AppColors.surface100,
          size: 31,
        ),
        label: Text(
          "Scanner",
          style: TextStyles.middle.copyWith(color: AppColors.surface100),
        ),
        onPressed: () {
          context.pushNamed(
            import_router.RouteNames.qrScanner,
            extra: {
              'onScanned': (String result) {
                try {
                  final decoded = jsonDecode(result);
                  if (decoded is Map<String, dynamic> && decoded.length == 2) {
                    String? mtmVal;
                    String? snVal;
                    decoded.forEach((k, v) {
                      if (k.toLowerCase() == 'mtm') mtmVal = v.toString();
                      if (k.toLowerCase() == 'sn') snVal = v.toString();
                    });
                    if (mtmVal != null && snVal != null) {
                      viewModel.mtmController.text = mtmVal!;
                      viewModel.serialNumberController.text = snVal!;
                      viewModel.notifyListeners();
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
        },
      ),
    );
  }
}
