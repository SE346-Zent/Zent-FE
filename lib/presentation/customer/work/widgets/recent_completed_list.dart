import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/presentation/common/core/themes/boxshadow.dart';
import 'package:zent_fe/routing/route_names.dart';

import '../../../../domain/entities/work_order.dart';
import 'package:intl/intl.dart';

class RecentCompletedList extends StatelessWidget {
  final List<WorkOrder> recentCompleted;

  const RecentCompletedList({super.key, required this.recentCompleted});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimens.boraMd),
        boxShadow: [BoxShadowStyles.subtle],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.spaceMd,
              vertical: AppDimens.spaceSm,
            ),
            child: Text('Recent Completed', style: TextStyles.middle),
          ),
          const Divider(height: 1, color: AppColors.secondary50),

          // List item
          if (recentCompleted.isEmpty)
            const Padding(
              padding: EdgeInsets.all(AppDimens.spaceMd),
              child: Center(child: Text('No completed work orders')),
            )
          else
            Column(
              children: [
                for (int i = 0; i < recentCompleted.length; i++) ...[
                  InkWell(
                    onTap: () {
                      context.pushNamed(
                        RouteNames.customerWorkOrderDetails,
                        pathParameters: {'workOrderId': recentCompleted[i].id},
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimens.spaceMd,
                        vertical: AppDimens.spaceSm,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                recentCompleted[i].title,
                                style: TextStyles.bodyLarge.copyWith(
                                  color: AppColors.secondary500,
                                ),
                              ),
                              Text(
                                recentCompleted[i].workOrderNum.isNotEmpty
                                    ? recentCompleted[i].workOrderNum
                                    : 'WO-${recentCompleted[i].id.substring(0, 4)}',
                                style: TextStyles.label.copyWith(
                                  color: AppColors.secondary300,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            DateFormat(
                              'MMM dd, yyyy',
                            ).format(recentCompleted[i].createdAt),
                            style: TextStyles.label.copyWith(
                              color: AppColors.secondary500,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (i < recentCompleted.length - 1)
                    const Divider(height: 1, color: AppColors.secondary50),
                ],
              ],
            ),
        ],
      ),
    );
  }
}
