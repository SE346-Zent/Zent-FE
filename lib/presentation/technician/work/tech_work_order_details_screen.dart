import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/ui/account_header.dart';
import 'package:zent_fe/di/injection_container.dart' as di;

import 'view_models/tech_work_order_details_viewmodel.dart';
import 'widgets/details_job_info.dart';
import 'widgets/details_job_timer.dart';
import 'widgets/details_checklist.dart';
import 'widgets/details_artifact_list.dart';
import 'widgets/details_bottom_actions.dart';

class TechWorkOrderDetailsScreen extends StatelessWidget {
  final String workOrderId;

  const TechWorkOrderDetailsScreen({super.key, required this.workOrderId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => di.sl<TechWorkOrderDetailsViewModel>(param1: workOrderId),
      child: const _TechWorkOrderDetailsContent(),
    );
  }
}

class _TechWorkOrderDetailsContent extends StatelessWidget {
  const _TechWorkOrderDetailsContent();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<TechWorkOrderDetailsViewModel>();

    return Scaffold(
      backgroundColor: AppColors.background500,
      body: SafeArea(
        child: Column(
          children: [
            AccountHeader(
              title: "Detailed Work",
              subtitle: "${viewModel.workOrderId} • 12h30 AM",
              showDivider: true,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppDimens.spaceMd),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DetailsJobInfo(viewModel: viewModel),
                    const SizedBox(height: AppDimens.spaceLg),
                    DetailsJobTimer(viewModel: viewModel),
                    const SizedBox(height: AppDimens.spaceLg),
                    DetailsChecklist(viewModel: viewModel),
                    const SizedBox(height: AppDimens.spaceLg),
                    DetailsArtifactList(viewModel: viewModel),
                    const SizedBox(height: AppDimens.spaceXl),
                  ],
                ),
              ),
            ),
            DetailsBottomActions(viewModel: viewModel),
          ],
        ),
      ),
    );
  }
}
