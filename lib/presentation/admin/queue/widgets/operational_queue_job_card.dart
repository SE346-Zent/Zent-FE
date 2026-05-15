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
    return Container(
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
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: AppColors.warning500,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: AppDimens.spaceXs),
                              Expanded(
                                child: Text(
                                  job['status'],
                                  style: TextStyles.middle.copyWith(
                                    color: AppColors.secondary500,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: AppDimens.spaceSm),
                        GestureDetector(
                          onTap: () async {
                            final cleanId = job['id'].toString().replaceAll(
                              '#',
                              '',
                            );
                            if (job['statusEnum'] == 'rejectInReview') {
                              await context.pushNamed(
                                RouteNames.adminRejectionDetail,
                                pathParameters: {'workOrderId': cleanId},
                              );
                            } else {
                              await context.pushNamed(
                                RouteNames.adminWorkOrderDetails,
                                pathParameters: {'workOrderId': cleanId},
                              );
                            }
                            if (context.mounted) {
                              context
                                  .read<OperationalQueueViewModel>()
                                  .loadWorkOrders();
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14.0,
                              vertical: 6.0,
                            ),
                            decoration: BoxDecoration(
                              color: job['statusEnum'] == 'rejectInReview'
                                  ? AppColors.tertiary500
                                  : AppColors.primary500,
                              borderRadius: BorderRadius.circular(
                                AppDimens.boraSm,
                              ),
                              boxShadow: [BoxShadowStyles.subtle],
                            ),
                            child: Text(
                              job['statusEnum'] == 'rejectInReview'
                                  ? 'Review'
                                  : 'Assign',
                              style: TextStyles.title.copyWith(
                                color: Colors.white,
                              ),
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
