import 'package:flutter/material.dart';

// Core Theming
import 'package:zent_fe/presentation/common/core/themes/boxshadow.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';

import 'package:go_router/go_router.dart';
import 'package:zent_fe/routing/route_names.dart';
// ViewModel
import '../viewmodels/tech_work_order_viewmodel.dart';

class WorkOrderCard extends StatelessWidget {
  final MockWorkOrder order;

  const WorkOrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final isHighPriority = order.priority == 'High';
    final isCompleted = order.status == 'Completed';
    final isPending = order.status == 'Pending';

    // Priority Color Processing
    final priorityColor = isHighPriority
        ? AppColors.error500
        : AppColors.secondary500;
    final priorityBg = isHighPriority
        ? AppColors.error100
        : AppColors.surface600;

    // Status Color Processing
    Color statusColor = AppColors.tertiary400;
    if (isCompleted) statusColor = AppColors.success500;
    if (isPending) statusColor = AppColors.secondary200;

    return Container(
      margin: const EdgeInsets.only(bottom: AppDimens.spaceMd),
      padding: const EdgeInsets.all(AppDimens.spaceMd),
      decoration: BoxDecoration(
        color: AppColors.surface100,
        borderRadius: BorderRadius.circular(AppDimens.boraMd),
        border: Border.all(color: AppColors.secondary50),
        boxShadow: [BoxShadowStyles.raised],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1.Priority & Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 23.0,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.spaceSm,
                  vertical: 2.0,
                ),
                decoration: BoxDecoration(
                  color: priorityBg,
                  borderRadius: BorderRadius.circular(AppDimens.boraMd),
                ),
                alignment: Alignment.center,
                child: Text(
                  '${order.priority.toUpperCase()} PRIORITY',
                  style: TextStyles.bodyMedium.copyWith(
                    color: priorityColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: statusColor,
                    ),
                  ),
                  const SizedBox(width: 6.0),
                  Text(
                    order.status,
                    style: TextStyles.label.copyWith(color: statusColor),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12.0),

          // 2. Title
          Text(
            '${order.id} | ${order.title}',
            style: TextStyles.title.copyWith(color: AppColors.primary500),
          ),
          const SizedBox(height: AppDimens.spaceSm),

          // 3. Details
          _buildDetailRow(Icons.person_outline, order.customerName),
          const SizedBox(height: AppDimens.spaceXs),
          _buildDetailRow(Icons.access_time, order.time),
          const SizedBox(height: AppDimens.spaceXs),
          _buildDetailRow(Icons.location_on_outlined, order.address),
          const SizedBox(height: AppDimens.spaceMd),

          // 4. Action Buttons
          if (isCompleted)
            _buildActionButton(
              text: 'View Details',
              textColor: AppColors.tertiary500,
              bgColor: AppColors.tertiary50,
              onPressed: () {
                context.pushNamed(
                  RouteNames.techWorkOrderDetails,
                  pathParameters: {'workOrderId': order.id},
                );
              },
            )
          else
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    text: isPending ? 'Start Job' : 'Complete',
                    textColor: AppColors.surface100,
                    bgColor: AppColors.tertiary500,
                    onPressed: () {
                      context.pushNamed(
                        RouteNames.techWorkOrderDetails,
                        pathParameters: {'workOrderId': order.id},
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12.0),
                Container(
                  height: 44.0,
                  width: 44.0,
                  decoration: BoxDecoration(
                    color: AppColors.surface100,
                    borderRadius: BorderRadius.circular(AppDimens.boraSm),
                    border: Border.all(color: AppColors.secondary50),
                  ),
                  child: const Icon(
                    Icons.turn_right,
                    size: 24.0,
                    color: AppColors.secondary500,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16.0, color: AppColors.secondary400),
        const SizedBox(width: AppDimens.spaceSm),
        Expanded(
          child: Text(
            text,
            style: TextStyles.label.copyWith(color: AppColors.secondary400),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String text,
    required Color textColor,
    required Color bgColor,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(AppDimens.boraSm),
      child: Container(
        height: 44.0,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(AppDimens.boraSm),
          boxShadow: [BoxShadowStyles.subtle],
        ),
        alignment: Alignment.center,
        child: Text(text, style: TextStyles.title.copyWith(color: textColor)),
      ),
    );
  }
}
