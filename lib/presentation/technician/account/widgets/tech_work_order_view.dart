import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';

import 'tech_app_bar.dart';
import '../view_models/tech_work_order_viewmodel.dart';
import 'tech_work_order_card.dart';

class TechWorkOrderView extends StatelessWidget {
  const TechWorkOrderView({super.key});

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
                  borderRadius: BorderRadius.circular(8.0),
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
                    ), // Icon kính lúp
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                    ), // Căn giữa chữ
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
                      margin: const EdgeInsets.only(right: 8.0),
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.tertiary500
                            : Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                        border: isSelected
                            ? null
                            : Border.all(color: AppColors.secondary100),
                      ),
                      child: Text(
                        viewModel.filters[index],
                        style: TextStyles.bodyLarge.copyWith(
                          color: isSelected
                              ? Colors.white
                              : AppColors.secondary500,
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
