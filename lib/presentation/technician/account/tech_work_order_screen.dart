import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Core Dependency Injection
import 'package:zent_fe/di/injection_container.dart';

// Core Theming
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';

// Shared Tech Components
import 'widgets/tech_app_bar.dart';

// Feature-specific Widgets
import 'widgets/tech_work_order_card.dart';

// ViewModel
import 'view_models/tech_work_order_viewmodel.dart';

class TechWorkOrderScreen extends StatelessWidget {
  const TechWorkOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TechWorkOrderViewModel>(
      create: (_) => sl<TechWorkOrderViewModel>(),
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
      backgroundColor: Colors.white,
      appBar: const TechAppBar(
        title: 'Work Orders',
        showBackButton: false,
        showBottomDivider: false,
      ),

      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.spaceMd,
                vertical: AppDimens.spaceSm,
              ),
              child: Container(
                height: 40.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppDimens.boraSm),
                  border: Border.all(color: AppColors.secondary200),
                ),
                child: TextField(
                  style: TextStyles.bodyLarge.copyWith(
                    color: AppColors.secondary200,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search users by name or ID',
                    hintStyle: TextStyles.bodyLarge.copyWith(
                      color: AppColors.secondary200,
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: AppColors.secondary300,
                      size: 20.0,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppDimens.spaceSm),

            // Filter Tabs
            SizedBox(
              height: 40.0,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.spaceMd,
                ),
                itemCount: viewModel.filters.length,
                itemBuilder: (context, index) {
                  final isSelected = viewModel.selectedFilterIndex == index;
                  return GestureDetector(
                    onTap: () => viewModel.setFilter(index),
                    child: Container(
                      margin: const EdgeInsets.only(right: AppDimens.spaceSm),
                      padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceMd),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.tertiary500 : Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                        border: isSelected ? null : Border.all(color: AppColors.secondary100),
                      ),
                      child: Text(
                        viewModel.filters[index],
                        style: TextStyles.bodyLarge.copyWith(
                          color: isSelected ? Colors.white : AppColors.secondary500,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: AppDimens.spaceMd),

            // Work Order List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.spaceMd,
                ),
                itemCount: viewModel.filteredOrders.length,
                itemBuilder: (context, index) {
                  return WorkOrderCard(order: viewModel.filteredOrders[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}