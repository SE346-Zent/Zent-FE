import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/ui/account_header.dart';
import 'package:zent_fe/presentation/common/core/ui/button.dart';
import 'package:zent_fe/di/injection_container.dart' as di;

import 'view_models/complete_work_order_viewmodel.dart';
import 'widgets/machine_info_section.dart';
import 'widgets/diagnostic_section.dart';
import 'widgets/part_tracking_section.dart';
import 'widgets/evidence_photos_section.dart';

class CompleteWorkOrderScreen extends StatelessWidget {
  final String workOrderId;

  const CompleteWorkOrderScreen({super.key, required this.workOrderId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => di.sl<CompleteWorkOrderViewModel>(param1: workOrderId),
      child: const _CompleteWorkOrderContent(),
    );
  }
}

class _CompleteWorkOrderContent extends StatelessWidget {
  const _CompleteWorkOrderContent();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CompleteWorkOrderViewModel>();

    return Scaffold(
      backgroundColor: AppColors.background500,
      body: SafeArea(
        child: Column(
          children: [
            AccountHeader(
              title: "Complete Work Order",
              subtitle: "${viewModel.workOrderId} • 12h30 AM",
              showDivider: true,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppDimens.spaceMd),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch, // Kept for consistency with other sections
                  children: [
                    MachineInfoSection(viewModel: viewModel),
                    const SizedBox(height: AppDimens.spaceLg),
                    DiagnosticSection(viewModel: viewModel),
                    const SizedBox(height: AppDimens.spaceLg),
                    PartTrackingSection(viewModel: viewModel),
                    const SizedBox(height: AppDimens.spaceLg),
                    EvidencePhotosSection(viewModel: viewModel),
                    const SizedBox(height: AppDimens.spaceXl),
                    
                    // Submit Button inside ScrollView for better accessibility
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceSm),
                      child: PrimaryActionButton(
                        label: "Submit Completion Report",
                        width: double.infinity,
                        onPressed: () => viewModel.submitReport(),
                      ),
                    ),
                    const SizedBox(height: AppDimens.spaceXl),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
