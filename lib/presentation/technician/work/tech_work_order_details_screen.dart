import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:zent_fe/routing/route_names.dart';
import 'package:intl/intl.dart';
import 'package:zent_fe/presentation/common/core/themes/boxshadow.dart';
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

    if (viewModel.workOrder == null) {
      return const Scaffold(
        backgroundColor: AppColors.background500,
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary500),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background500,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    AccountHeader(
                      title: "Detailed Work",
                      subtitle:
                          "${viewModel.displayWorkOrderNum} • ${viewModel.appointmentFormatted}",
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
                        _buildWorkOrderInfoCard(viewModel),
                        const SizedBox(height: AppDimens.spaceXl),
                      ],
                    ),
                  ),
                ),
                DetailsBottomActions(viewModel: viewModel),
              ],
            ),
            if (viewModel.isLoading)
              Container(
                color: Colors.black.withAlpha(90),
                child: const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.primary500,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkOrderInfoCard(TechWorkOrderDetailsViewModel viewModel) {
    // Format Appointment time nicely
    final dt = viewModel.workOrder?.appointment;
    String appointmentStr = 'N/A';
    if (dt != null) {
      final now = DateTime.now();
      final isToday =
          dt.year == now.year && dt.month == now.month && dt.day == now.day;
      final timeStr = DateFormat("hh:mm a").format(dt);
      if (isToday) {
        appointmentStr = '$timeStr - Today';
      } else {
        appointmentStr = '$timeStr - ${DateFormat("dd/MM/yyyy").format(dt)}';
      }
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimens.spaceMd),
      decoration: BoxDecoration(
        color: AppColors.surface100,
        borderRadius: BorderRadius.circular(AppDimens.boraSm),
        boxShadow: [BoxShadowStyles.raised],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.format_list_bulleted_rounded,
                color: AppColors.primary400,
                size: 22,
              ),
              const SizedBox(width: AppDimens.spaceSm),
              Text(
                'Work Order Information',
                style: TextStyles.middle.copyWith(
                  color: AppColors.primary400,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimens.spaceMd),

          // Appointment Section
          Text(
            'Appointment',
            style: TextStyles.bodyLarge.copyWith(
              color: AppColors.primary500,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2.0),
          Text(
            appointmentStr,
            style: TextStyles.bodyMedium.copyWith(
              color: AppColors.secondary500,
            ),
          ),
          const SizedBox(height: AppDimens.spaceSm),

          // Symptom Section
          Text(
            'Symptom',
            style: TextStyles.bodyLarge.copyWith(
              color: AppColors.primary500,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2.0),
          Text(
            viewModel.symptom.isNotEmpty ? viewModel.symptom : 'N/A',
            style: TextStyles.bodyMedium.copyWith(
              color: AppColors.secondary500,
            ),
          ),
          const SizedBox(height: AppDimens.spaceSm),

          // Description Section
          Text(
            'Description',
            style: TextStyles.bodyLarge.copyWith(
              color: AppColors.primary500,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2.0),
          Text(
            viewModel.description.isNotEmpty ? viewModel.description : 'N/A',
            style: TextStyles.bodyMedium.copyWith(
              color: AppColors.secondary500,
            ),
          ),
        ],
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
                  color: Colors.black.withValues(alpha: 0.08),
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
                  color: Colors.black.withValues(alpha: 0.08),
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
