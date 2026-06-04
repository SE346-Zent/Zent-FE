import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Core Dependency Injection
import 'package:zent_fe/di/injection_container.dart';

// Core Theming
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';

// Shared Tech Components
import 'package:zent_fe/presentation/technician/account/widgets/tech_app_bar.dart';

import 'widgets/tech_work_order_card.dart';
import 'widgets/tech_work_order_search_bar.dart';
import 'widgets/tech_work_order_filter_tabs.dart';

// ViewModel (Internal to work folder)
import 'viewmodels/tech_work_order_viewmodel.dart';

class TechWorkOrderScreen extends StatelessWidget {
  const TechWorkOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TechWorkOrderViewModel>(
      create: (_) => sl<TechWorkOrderViewModel>()..initData(),
      child: const _TechWorkOrderView(),
    );
  }
}

class _TechWorkOrderView extends StatelessWidget {
  const _TechWorkOrderView();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<TechWorkOrderViewModel>();

    return Scaffold(
      backgroundColor: AppColors.background500,
      resizeToAvoidBottomInset: false,
      appBar: const TechAppBar(
        title: 'Work Orders',
        showBackButton: false,
        showBottomDivider: false,
      ),

      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            const TechWorkOrderSearchBar(),
            const SizedBox(height: AppDimens.spaceSm),

            // Filter Tabs
            const TechWorkOrderFilterTabs(),
            const SizedBox(height: AppDimens.spaceMd),

            // Work Order List
            Expanded(
              child: viewModel.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : RefreshIndicator(
                      color: AppColors.tertiary500,
                      onRefresh: () => viewModel.refreshData(silent: true),
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimens.spaceMd,
                        ),
                        itemCount: viewModel.filteredOrders.length,
                        itemBuilder: (context, index) {
                          return WorkOrderCard(
                            order: viewModel.filteredOrders[index],
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
