import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/presentation/common/core/ui/button.dart';
import 'package:zent_fe/routing/route_names.dart';
import '../viewmodels/tech_work_order_details_viewmodel.dart';

class DetailsBottomActions extends StatelessWidget {
  final TechWorkOrderDetailsViewModel viewModel;

  const DetailsBottomActions({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimens.spaceMd),
      decoration: BoxDecoration(color: AppColors.surface100),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: _buildSecondaryButton(
              label: "Pause",
              onPressed: () {
                final cleanId = viewModel.workOrderId.replaceAll('#', '');
                context.pushNamed(
                  RouteNames.techPauseWorkOrder,
                  pathParameters: {'workOrderId': cleanId},
                );
              },
            ),
          ),
          const SizedBox(width: AppDimens.spaceMd),
          Expanded(
            flex: 2,
            child: PrimaryActionButton(
              label: "Fill Form",
              icon: Icons.assignment_turned_in_outlined,
              onPressed: () {
                viewModel.onFillFormPressed(context);
                context.pushNamed(
                  RouteNames.techCompleteWorkOrder,
                  pathParameters: {'workOrderId': viewModel.workOrderId},
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecondaryButton({
    required String label,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.tertiary50.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(AppDimens.boraSm),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyles.title.copyWith(color: AppColors.tertiary300),
        ),
      ),
    );
  }
}
