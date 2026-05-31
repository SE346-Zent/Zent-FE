import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:zent_fe/routing/route_names.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/presentation/common/core/ui/account_header.dart';
import 'package:zent_fe/di/injection_container.dart' as di;

import 'package:zent_fe/domain/entities/enums/work_order_status.dart';
import 'viewmodels/tech_work_order_details_viewmodel.dart';
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
        child: viewModel.isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.primary500,
                  ),
                ),
              )
            : Column(
                children: [
                  Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      AccountHeader(
                        title: "Detailed Work",
                        subtitle: "${viewModel.displayWorkOrderNum} • 12h30 AM",
                        showDivider: true,
                      ),
                      Positioned(
                        right: AppDimens.spaceSm,
                        top: 4.0,
                        child:
                            (viewModel.workOrder?.status ==
                                    WorkOrderStatus.complete ||
                                viewModel.workOrder?.status ==
                                    WorkOrderStatus.rejected ||
                                viewModel.workOrder?.status ==
                                    WorkOrderStatus.rejectInReview)
                            ? const SizedBox.shrink()
                            : _buildPopupMenu(context),
                      ),
                    ],
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

  Widget _buildPopupMenu(BuildContext context) {
    final viewModel = context.read<TechWorkOrderDetailsViewModel>();
    final cleanId = viewModel.workOrderId.replaceAll('#', '');
    final woNum = viewModel.displayWorkOrderNum;

    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_horiz, color: Colors.black),
      color: AppColors.background500,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.boraSm),
      ),
      offset: const Offset(0, 40),
      onSelected: (value) {
        if (value == 'addPart') {
          context.pushNamed(
            RouteNames.techAddNewPart,
            extra: {'workOrderId': cleanId, 'workOrderNumber': woNum},
          );
        } else if (value == 'reject') {
          context.pushNamed(
            RouteNames.techRejectWorkOrder,
            pathParameters: {'workOrderId': cleanId},
          );
        }
      },
      itemBuilder: (BuildContext context) => [
        PopupMenuItem<String>(
          value: 'addPart',
          height: 38,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppDimens.boraSm),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Text(
                'Add New Part',
                style: TextStyles.label.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
        PopupMenuItem<String>(
          value: 'reject',
          height: 38,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.error50,
              borderRadius: BorderRadius.circular(AppDimens.boraSm),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Text(
                'Reject Work Order',
                style: TextStyles.label.copyWith(
                  color: AppColors.error500,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
