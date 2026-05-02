import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/presentation/common/core/themes/boxshadow.dart';
import 'package:zent_fe/routing/route_names.dart';
import 'tracking_stepper.dart';
import 'active_repairs_action_button.dart';

class TrackingCard extends StatelessWidget {
  final int currentStatusStep;

  const TrackingCard({super.key, required this.currentStatusStep});

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
                          'WO-1234',
                          style: TextStyles.bodyLarge.copyWith(
                            color: AppColors.secondary400,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Mainboard Inspection',
                          style: TextStyles.headline.copyWith(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Scheduled time: 14h30',
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
                                title: 'Cancel',
                                bgColor: AppColors.surface600,
                                textColor: AppColors.secondary500,
                                shadow: BoxShadowStyles.subtle,
                                onTap: () {
                                  context.pushNamed(
                                    RouteNames.customerCancelWorkOrder,
                                    pathParameters: {'workOrderId': 'WO-1234'},
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
                                onTap: () {},
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
          ],
        ),
      ),
    );
  }
}
