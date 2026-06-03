import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/presentation/common/core/themes/boxshadow.dart';
import 'package:zent_fe/domain/entities/work_order.dart';

class RejectedWorkOrderCard extends StatelessWidget {
  final WorkOrder workOrder;
  final VoidCallback onApprove;
  final VoidCallback onDeny;
  final VoidCallback onDetailTap;

  const RejectedWorkOrderCard({
    super.key,
    required this.workOrder,
    required this.onApprove,
    required this.onDeny,
    required this.onDetailTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimens.spaceLg),
      decoration: BoxDecoration(
        color: AppColors.surface100,
        borderRadius: BorderRadius.circular(AppDimens.boraSm),
        boxShadow: [BoxShadowStyles.overlay],
      ),
      padding: const EdgeInsets.all(AppDimens.spaceLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '#${workOrder.id}',
            style: TextStyles.middle.copyWith(color: AppColors.tertiary500),
          ),
          const SizedBox(height: 4.0),
          Text(
            workOrder.title,
            style: TextStyles.headline.copyWith(color: AppColors.primary500),
          ),
          const SizedBox(height: AppDimens.spaceMd),
          GestureDetector(
            onTap: onDetailTap,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.spaceMd,
                vertical: AppDimens.spaceSm,
              ),
              decoration: BoxDecoration(
                color: AppColors.secondary50,
                borderRadius: BorderRadius.circular(AppDimens.boraSm),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            const Text(
                              'TECHNICIAN',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const CircleAvatar(
                                  radius: 10,
                                  backgroundImage: CachedNetworkImageProvider(
                                    'https://i.pravatar.cc/150?img=11',
                                  ),
                                ),
                                const SizedBox(width: 8.0),
                                Flexible(
                                  child: Text(
                                    workOrder.technicianName ?? 'N/A',
                                    style: TextStyles.middle.copyWith(
                                      color: Colors.black,
                                    ),
                                    softWrap: true,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            const Text(
                              'CUSTOMER',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const CircleAvatar(
                                  radius: 10,
                                  backgroundImage: CachedNetworkImageProvider(
                                    'https://i.pravatar.cc/150?img=5',
                                  ),
                                ),
                                const SizedBox(width: 8.0),
                                Flexible(
                                  child: Text(
                                    workOrder.customerName,
                                    style: TextStyles.middle.copyWith(
                                      color: Colors.black,
                                    ),
                                    softWrap: true,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  const Divider(color: AppColors.secondary100, height: 1.0),
                  const SizedBox(height: 10.0),
                  const Text(
                    'TECHNICIAN NOTES',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 6.0),
                  Text(
                    '"${workOrder.refusalNote}"',
                    style: TextStyles.bodyLarge.copyWith(color: Colors.black),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppDimens.spaceLg),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: onDeny,
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.tertiary500,
                      borderRadius: BorderRadius.circular(AppDimens.boraSm),
                      border: Border.all(
                        color: AppColors.tertiary500,
                        width: 1.5,
                      ),
                      boxShadow: [BoxShadowStyles.glowing],
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Deny',
                      style: TextStyles.middle.copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppDimens.spaceMd),
              Expanded(
                child: GestureDetector(
                  onTap: onApprove,
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.surface600,
                      borderRadius: BorderRadius.circular(AppDimens.boraSm),
                      border: Border.all(
                        color: AppColors.surface600,
                        width: 1.5,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Approve',
                      style: TextStyles.middle.copyWith(
                        color: AppColors.primary500,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
