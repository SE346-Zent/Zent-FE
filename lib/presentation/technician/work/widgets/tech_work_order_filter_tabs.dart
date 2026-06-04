import 'package:flutter/material.dart';
import 'package:zent_fe/presentation/common/core/utils/tap_debounce.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import '../viewmodels/tech_work_order_viewmodel.dart';
import 'package:provider/provider.dart';

class TechWorkOrderFilterTabs extends StatelessWidget {
  const TechWorkOrderFilterTabs({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<TechWorkOrderViewModel>();

    return SizedBox(
      height: 40.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceMd),
        itemCount: viewModel.filters.length,
        itemBuilder: (context, index) {
          final isSelected = viewModel.selectedFilterIndex == index;
          return ThrottledGestureDetector(
            onTap: () => viewModel.setFilter(index),
            child: Container(
              margin: const EdgeInsets.only(right: AppDimens.spaceSm),
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.spaceMd,
              ),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.tertiary500 : Colors.white,
                borderRadius: BorderRadius.circular(20.0),
                border: isSelected
                    ? null
                    : Border.all(color: AppColors.secondary100),
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
    );
  }
}
