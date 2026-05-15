import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zent_fe/di/injection_container.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import '../account/widgets/customer_app_bar.dart';
import 'viewmodels/active_repairs_viewmodel.dart';
import 'widgets/tracking_card.dart';
import 'widgets/recent_completed_list.dart';

class ActiveRepairsScreen extends StatelessWidget {
  const ActiveRepairsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => sl<ActiveRepairsViewModel>()..fetchWorkOrders(),
      child: const _ActiveRepairsView(),
    );
  }
}

class _ActiveRepairsView extends StatelessWidget {
  const _ActiveRepairsView();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ActiveRepairsViewModel>();

    return Scaffold(
      backgroundColor: AppColors.background500,
      appBar: const CustomerAppBar(
        title: 'Active Repairs',
        showBackButton: true,
        showBottomDivider: true,
      ),
      body: viewModel.isLoading && viewModel.activeWorkOrders.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : viewModel.errorMessage != null && viewModel.activeWorkOrders.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${viewModel.errorMessage}',
                    style: TextStyles.bodyLarge,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => viewModel.fetchWorkOrders(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            )
          : CustomScrollView(
              slivers: [
                // Title & Tracking Card
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: AppDimens.spaceMd,
                      left: AppDimens.spaceMd,
                      right: AppDimens.spaceMd,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tracking Work Order',
                          style: TextStyles.display.copyWith(
                            color: Colors.black,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: AppDimens.spaceXs),
                        Text(
                          'Tracking your ongoing industrial service in real-time',
                          style: TextStyles.bodyLarge.copyWith(
                            color: AppColors.secondary500,
                          ),
                        ),
                        const SizedBox(height: AppDimens.spaceLg),

                        // Tracking Card
                        if (viewModel.currentTrackingOrder != null)
                          TrackingCard(
                            workOrder: viewModel.currentTrackingOrder!,
                            currentStatusStep: viewModel.currentStatusStep,
                          )
                        else
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.all(AppDimens.spaceXl),
                              child: Text('No active work orders'),
                            ),
                          ),
                        const SizedBox(height: AppDimens.spaceXl),
                      ],
                    ),
                  ),
                ),

                // Recent Completed List
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: AppDimens.spaceMd,
                      right: AppDimens.spaceMd,
                      bottom: AppDimens.spaceMd,
                    ),
                    child: RecentCompletedList(
                      recentCompleted: viewModel.completedWorkOrders,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
