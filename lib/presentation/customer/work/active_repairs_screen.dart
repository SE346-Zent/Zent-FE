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

class _ActiveRepairsView extends StatefulWidget {
  const _ActiveRepairsView();

  @override
  State<_ActiveRepairsView> createState() => _ActiveRepairsViewState();
}

class _ActiveRepairsViewState extends State<_ActiveRepairsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ActiveRepairsViewModel>().fetchWorkOrders();
    });
  }

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
      body: viewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : viewModel.errorMessage != null
          ? Center(
              child: Text(
                'Error: ${viewModel.errorMessage}',
                style: const TextStyle(color: Colors.red),
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

                        if (viewModel.activeWorkOrder != null) ...[
                          TrackingCard(
                            currentStatusStep: viewModel.currentStatusStep,
                          ),
                          const SizedBox(height: AppDimens.spaceXl),
                        ] else ...[
                          Container(
                            padding: const EdgeInsets.all(AppDimens.spaceLg),
                            decoration: BoxDecoration(
                              color: AppColors.surface50,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: Text(
                                'You have no active repairs at the moment.',
                              ),
                            ),
                          ),
                          const SizedBox(height: AppDimens.spaceXl),
                        ],
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
                    child: viewModel.recentCompleted.isEmpty
                        ? const Center(child: Text('No completed repairs yet.'))
                        : RecentCompletedList(
                            recentCompleted: viewModel.recentCompleted,
                          ),
                  ),
                ),
              ],
            ),
    );
  }
}
