import 'package:flutter/material.dart';
import 'package:zent_fe/presentation/common/core/utils/tap_debounce.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/presentation/common/core/themes/boxshadow.dart';
import 'package:zent_fe/routing/route_names.dart';
import 'tracking_stepper.dart';
import 'active_repairs_action_button.dart';

import 'package:zent_fe/domain/entities/work_order.dart';
import 'package:zent_fe/domain/entities/enums/work_order_status.dart';
import '../viewmodels/active_repairs_viewmodel.dart';
import 'package:intl/intl.dart';

class TrackingCard extends StatelessWidget {
  final WorkOrder workOrder;
  final int currentStatusStep;

  const TrackingCard({
    super.key,
    required this.workOrder,
    required this.currentStatusStep,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppDimens.boraMd),
          boxShadow: [BoxShadowStyles.raised],
          border: const Border(
            top: BorderSide(color: AppColors.secondary300, width: 1),
            bottom: BorderSide(color: AppColors.secondary300, width: 1),
            right: BorderSide(color: AppColors.secondary300, width: 1),
          ),
        ),
        child: Stack(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(width: 8),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(AppDimens.spaceMd),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          workOrder.workOrderNum.isNotEmpty
                              ? workOrder.workOrderNum
                              : 'WO-${workOrder.id.substring(0, 4)}',
                          style: TextStyles.bodyLarge.copyWith(
                            color: AppColors.secondary400,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          workOrder.title.isNotEmpty
                              ? workOrder.title
                              : 'No Title',
                          style: TextStyles.headline.copyWith(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.tertiary500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Requested: ${DateFormat('MMM dd, yyyy HH:mm').format(workOrder.createdAt)}',
                          style: TextStyles.bodyMedium.copyWith(
                            color: AppColors.secondary500,
                          ),
                        ),
                        const SizedBox(height: AppDimens.spaceXl),
                        TrackingStepper(currentStep: currentStatusStep),
                        const SizedBox(height: AppDimens.spaceXl),
                        Row(
                          children: [
                            Expanded(
                              child: ActiveRepairsActionButton(
                                title: 'Details',
                                bgColor: AppColors.surface600,
                                textColor: AppColors.secondary500,
                                shadow: BoxShadowStyles.subtle,
                                onTap: () {
                                  context
                                      .pushNamed(
                                        RouteNames.customerWorkOrderDetails,
                                        pathParameters: {
                                          'workOrderId': workOrder.id
                                              .replaceAll('#', ''),
                                        },
                                      )
                                      .then((_) {
                                        if (context.mounted) {
                                          context
                                              .read<ActiveRepairsViewModel>()
                                              .fetchWorkOrders();
                                        }
                                      });
                                },
                              ),
                            ),
                            const SizedBox(width: AppDimens.spaceMd),
                            Expanded(
                              child: ActiveRepairsActionButton(
                                title: 'Edit',
                                bgColor: AppColors.tertiary500,
                                textColor: Colors.white,
                                shadow: BoxShadowStyles.glowing,
                                onTap: () {
                                  context
                                      .pushNamed(
                                        RouteNames.customerEditWorkOrder,
                                        pathParameters: {
                                          'workOrderId': workOrder.id,
                                          'workOrderNumber':
                                              workOrder.workOrderNum.isNotEmpty
                                              ? workOrder.workOrderNum
                                              : workOrder.id,
                                        },
                                      )
                                      .then((_) {
                                        if (context.mounted) {
                                          context
                                              .read<ActiveRepairsViewModel>()
                                              .fetchWorkOrders();
                                        }
                                      });
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: Container(
                width: 8,
                decoration: BoxDecoration(
                  color: workOrder.status == WorkOrderStatus.complete
                      ? AppColors.success500
                      : AppColors.tertiary500,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(AppDimens.boraMd),
                    bottomLeft: Radius.circular(AppDimens.boraMd),
                  ),
                ),
              ),
            ),
            Positioned(
              right: AppDimens.spaceSm,
              top: AppDimens.spaceSm,
              child: ThrottledGestureDetector(
                onTapDown: (TapDownDetails details) async {
                  final tapPos = details.globalPosition;
                  final size = MediaQuery.of(context).size;

                  final selected = await showMenu<String>(
                    context: context,
                    color: const Color(0xFFFEF2F2),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 155,
                      maxWidth: 160,
                    ),
                    position: RelativeRect.fromLTRB(
                      tapPos.dx - 155, // menu right edge aligns with tap
                      tapPos.dy + 12, // just below the icon
                      size.width - tapPos.dx, // distance from right screen edge
                      size.height - tapPos.dy - 12, // distance from bottom
                    ),
                    items: [
                      PopupMenuItem<String>(
                        value: 'cancel',
                        padding: EdgeInsets.zero,
                        height: 28,
                        child: Center(
                          child: Text(
                            'Cancel Work Order',
                            style: TextStyles.label.copyWith(
                              color: AppColors.error500,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );

                  if (selected == 'cancel' && context.mounted) {
                    context
                        .pushNamed(
                          RouteNames.customerCancelWorkOrder,
                          pathParameters: {
                            'workOrderId': workOrder.id.replaceAll('#', ''),
                          },
                        )
                        .then((result) {
                          if (result == true && context.mounted) {
                            context
                                .read<ActiveRepairsViewModel>()
                                .fetchWorkOrders();
                          }
                        });
                  }
                },
                child: const Icon(
                  Icons.more_horiz,
                  color: AppColors.secondary500,
                  size: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
