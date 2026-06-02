import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/presentation/common/core/themes/boxshadow.dart';
import 'package:zent_fe/routing/route_names.dart';
import 'tracking_stepper.dart';
import 'active_repairs_action_button.dart';

import '../../../../domain/entities/work_order.dart';
import '../viewmodels/active_repairs_viewmodel.dart';
import 'package:provider/provider.dart';
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
                          workOrder.title,
                          style: TextStyles.headline.copyWith(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
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
                                  context.pushNamed(
                                    RouteNames.customerWorkOrderDetails,
                                    pathParameters: {
                                      'workOrderId': workOrder.id,
                                    },
                                  );
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
                                onTap: () async {
                                  final result = await context.pushNamed(
                                    RouteNames.customerEditWorkOrder,
                                    pathParameters: {
                                      'workOrderId': workOrder.id,
                                      'workOrderNumber':
                                          workOrder.workOrderNum.isNotEmpty
                                          ? workOrder.workOrderNum
                                          : workOrder.id,
                                    },
                                  );
                                  if (result == true && context.mounted) {
                                    context
                                        .read<ActiveRepairsViewModel>()
                                        .fetchWorkOrders();
                                  }
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
                decoration: const BoxDecoration(
                  color: AppColors.secondary700,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(AppDimens.boraMd),
                    bottomLeft: Radius.circular(AppDimens.boraMd),
                  ),
                ),
              ),
            ),
            Positioned(
              right: AppDimens.spaceSm,
              top: AppDimens.spaceSm,
              child: PopupMenuButton<String>(
                icon: const Icon(
                  Icons.more_horiz,
                  color: AppColors.secondary500,
                  size: 24,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(
                  minWidth: 190,
                  maxWidth: 190,
                  minHeight: 28,
                  maxHeight: 28,
                ),
                offset: const Offset(0, 32),
                color: const Color(0xFFFEF2F2),
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                ),
                onSelected: (value) {
                  if (value == 'cancel') {
                    context
                        .pushNamed(
                          RouteNames.customerCancelWorkOrder,
                          pathParameters: {'workOrderId': workOrder.id},
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
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem<String>(
                    value: 'cancel',
                    height: 28,
                    padding: EdgeInsets.zero,
                    child: Container(
                      width: double.infinity,
                      height: 28,
                      alignment: Alignment.center,
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
