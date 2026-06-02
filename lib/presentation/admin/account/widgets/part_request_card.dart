import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:zent_fe/routing/route_names.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/presentation/common/core/themes/boxshadow.dart';
import '../viewmodels/part_request_viewmodel.dart';

class PartRequestCard extends StatelessWidget {
  final String partId;
  final String partName;
  final String woId;
  final String date;
  final String status;
  final Color statusColor;

  const PartRequestCard({
    super.key,
    required this.partId,
    required this.partName,
    required this.woId,
    required this.date,
    required this.status,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final result = await context.pushNamed(
          RouteNames.adminDetailRequest,
          pathParameters: {'partId': partId},
        );
        if (result == true && context.mounted) {
          Provider.of<PartRequestsViewModel>(
            context,
            listen: false,
          ).loadRequests();
        }
      },
      borderRadius: BorderRadius.circular(AppDimens.boraMd),
      child: Container(
        padding: const EdgeInsets.all(AppDimens.spaceMd),
        decoration: BoxDecoration(
          color: AppColors.surface100,
          borderRadius: BorderRadius.circular(AppDimens.boraMd),
          boxShadow: [BoxShadowStyles.raised],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              partName,
              style: TextStyles.title.copyWith(color: Colors.black),
            ),
            const SizedBox(height: AppDimens.spaceSm),
            Row(
              children: [
                const Icon(
                  Icons.receipt_long_outlined,
                  size: 14.0,
                  color: AppColors.secondary500,
                ),
                const SizedBox(width: 4.0),
                Text(
                  woId,
                  style: TextStyles.label.copyWith(
                    color: AppColors.secondary500,
                  ),
                ),
                const SizedBox(width: AppDimens.spaceLg),
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 14.0,
                  color: AppColors.secondary500,
                ),
                const SizedBox(width: 4.0),
                Text(
                  date,
                  style: TextStyles.label.copyWith(
                    color: AppColors.secondary500,
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: AppDimens.spaceMd),
              child: Divider(
                color: AppColors.secondary50,
                height: 1.0,
                thickness: 1.0,
              ),
            ),
            Row(
              children: [
                Container(
                  width: 8.0,
                  height: 8.0,
                  decoration: BoxDecoration(
                    color: statusColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: AppDimens.spaceSm),
                Text(
                  status,
                  style: TextStyles.label.copyWith(color: statusColor),
                ),
                const Spacer(),
                const Icon(
                  Icons.arrow_forward,
                  size: 16.0,
                  color: AppColors.secondary500,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
