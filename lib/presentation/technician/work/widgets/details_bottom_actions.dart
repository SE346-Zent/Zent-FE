import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zent_fe/domain/entities/enums/work_order_status.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/presentation/common/core/ui/button.dart';
import 'package:zent_fe/routing/route_names.dart';
import '../viewmodels/tech_work_order_details_viewmodel.dart';

class DetailsBottomActions extends StatelessWidget {
  final TechWorkOrderDetailsViewModel viewModel;

  const DetailsBottomActions({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final order = viewModel.workOrder;
    final status = order?.status;
    final statusId = order?.statusId;
    final isPending = status == WorkOrderStatus.pending ||
        (status == WorkOrderStatus.assigned && statusId == 2);
    final isCompletedOrRejected =
        status == WorkOrderStatus.complete ||
        status == WorkOrderStatus.rejected ||
        status == WorkOrderStatus.rejectInReview;

    final String leftLabel;
    if (isPending ||
        status == WorkOrderStatus.rejected ||
        status == WorkOrderStatus.rejectInReview) {
      leftLabel = "Reject";
    } else {
      leftLabel = "Pause";
    }

    final bool isLeftReject = leftLabel == "Reject";

    return Container(
      padding: const EdgeInsets.all(AppDimens.spaceMd),
      decoration: BoxDecoration(color: AppColors.surface100),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: _buildSecondaryButton(
              label: leftLabel,
              isReject: isLeftReject,
              enabled: !isCompletedOrRejected,
              onPressed: isCompletedOrRejected
                  ? null
                  : () {
                      final cleanId = viewModel.workOrderId.replaceAll('#', '');
                      if (isPending) {
                        context.pushNamed(
                          RouteNames.techRejectWorkOrder,
                          pathParameters: {'workOrderId': cleanId},
                        );
                      } else {
                        context.pushNamed(
                          RouteNames.techPauseWorkOrder,
                          pathParameters: {'workOrderId': cleanId},
                        );
                      }
                    },
            ),
          ),
          const SizedBox(width: AppDimens.spaceMd),
          Expanded(
            flex: 2,
            child: PrimaryActionButton(
              label: isCompletedOrRejected
                  ? "View Report"
                  : (isPending ? "Start Job" : "Complete"),
              icon: isCompletedOrRejected
                  ? Icons.remove_red_eye_outlined
                  : (isPending
                        ? Icons.play_arrow
                        : Icons.assignment_turned_in_outlined),
              backgroundColor: isCompletedOrRejected
                  ? AppColors.primary300
                  : (isPending ? Colors.green.shade600 : AppColors.tertiary500),
              onPressed: () {
                if (isCompletedOrRejected) {
                  context.pushNamed(
                    RouteNames.techCompleteWorkOrder,
                    pathParameters: {'workOrderId': viewModel.workOrderId},
                  );
                } else if (isPending) {
                  viewModel.startJob(context);
                } else {
                  viewModel.onFillFormPressed(context);
                  context.pushNamed(
                    RouteNames.techCompleteWorkOrder,
                    pathParameters: {'workOrderId': viewModel.workOrderId},
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecondaryButton({
    required String label,
    required VoidCallback? onPressed,
    bool isReject = false,
    bool enabled = true,
  }) {
    return InkWell(
      onTap: enabled ? onPressed : null,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: enabled
              ? (isReject
                    ? AppColors.error50.withValues(alpha: 0.5)
                    : AppColors.tertiary50.withValues(alpha: 0.5))
              : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(AppDimens.boraSm),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyles.title.copyWith(
            color: enabled
                ? (isReject ? AppColors.error500 : AppColors.tertiary300)
                : Colors.grey.shade400,
          ),
        ),
      ),
    );
  }
}
