import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/presentation/common/core/themes/boxshadow.dart';
import 'package:zent_fe/routing/route_names.dart';
import 'package:provider/provider.dart';
import '../viewmodels/operational_queue_viewmodel.dart';

class OperationalQueueJobCard extends StatelessWidget {
  final Map<String, dynamic> job;

  const OperationalQueueJobCard({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final status = job['statusEnum'].toString();
        final cleanId = job['id'].toString().replaceAll('#', '');

        if (status == 'pending') {
          await context.pushNamed(
            RouteNames.adminWorkOrderDetails,
            pathParameters: {'workOrderId': cleanId},
          );
        } else {
          await context.pushNamed(
            RouteNames.adminAssignedWorkOrderDetails,
            pathParameters: {'workOrderId': cleanId},
            extra: {
              'showOnlyTimeline': status == 'assigned' || status == 'inProg'
            }, 
          );
        }
        if (context.mounted) {
          context.read<OperationalQueueViewModel>().loadWorkOrders();
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppDimens.boraMd),
          boxShadow: [BoxShadowStyles.raised],
        ),
        clipBehavior: Clip.antiAlias,
        child: IntrinsicHeight(
          child: Row(
            children: [
              Container(width: 6.0, color: AppColors.tertiary500),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(AppDimens.spaceMd),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        job['id'],
                        style: TextStyles.middle.copyWith(
                          color: AppColors.secondary500,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        job['title'],
                        style: TextStyles.headline.copyWith(
                          color: AppColors.primary500,
                        ),
                      ),
                      const SizedBox(height: AppDimens.spaceSm),
                      _buildIconTextRow(Icons.person_outline, job['assignee']),
                      const SizedBox(height: 4.0),
                      _buildIconTextRow(
                        Icons.location_on_outlined,
                        job['location'],
                      ),
                      const SizedBox(height: 4.0),
                      _buildIconTextRow(
                        Icons.calendar_today_outlined,
                        job['time'],
                      ),
                      const SizedBox(height: AppDimens.spaceMd),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: () {
                                      final s = job['statusEnum'].toString();
                                      if (s == 'rejected') {
                                        return AppColors.error500;
                                      }
                                      if (s == 'rejectInReview') {
                                        return AppColors.error200;
                                      }
                                      if (s == 'inProg' || s == 'complete') {
                                        return AppColors.tertiary500;
                                      }
                                      return AppColors.warning500; // pending
                                    }(),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: AppDimens.spaceXs),
                                Expanded(
                                  child: Text(
                                    job['status'],
                                    style: TextStyles.middle.copyWith(
                                      color: AppColors.secondary500,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: AppDimens.spaceSm),
                          if (job['statusEnum'] == 'pending')
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 30.0,
                                vertical: 5.0,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary500,
                                borderRadius: BorderRadius.circular(
                                  AppDimens.boraSm,
                                ),
                                boxShadow: [BoxShadowStyles.subtle],
                              ),
                              child: Text(
                                'Assign',
                                style: TextStyles.title.copyWith(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
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
        ),
      ),
    );
  }

  Widget _buildIconTextRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.secondary400),
        const SizedBox(width: 6.0),
        Expanded(
          child: Text(
            text,
            style: TextStyles.label.copyWith(color: AppColors.secondary400),
          ),
        ),
      ],
    );
  }
}