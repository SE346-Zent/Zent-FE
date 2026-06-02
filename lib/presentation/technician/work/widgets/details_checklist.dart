import 'package:flutter/material.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/domain/entities/enums/work_order_status.dart';
import '../viewmodels/tech_work_order_details_viewmodel.dart';

class DetailsChecklist extends StatelessWidget {
  final TechWorkOrderDetailsViewModel viewModel;

  const DetailsChecklist({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Task Checklist",
          style: TextStyles.middle.copyWith(color: AppColors.primary500),
        ),
        const SizedBox(height: AppDimens.spaceMd),
        Container(
          padding: const EdgeInsets.all(AppDimens.spaceMd),
          decoration: BoxDecoration(
            color: AppColors.surface100,
            borderRadius: BorderRadius.circular(AppDimens.boraSm),
            border: Border.all(color: AppColors.tertiary100),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${viewModel.completedTasksCount} of ${viewModel.totalTasksCount} complete",
                style: TextStyles.bodyMedium.copyWith(
                  color: AppColors.tertiary300,
                ),
              ),
              const SizedBox(height: AppDimens.spaceSm),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: viewModel.checklist.length,
                separatorBuilder: (_, index) =>
                    const SizedBox(height: AppDimens.spaceSm),
                itemBuilder: (context, index) {
                  final item = viewModel.checklist[index];
                  return Row(
                    children: [
                      GestureDetector(
                        onTap:
                            viewModel.workOrder?.status ==
                                WorkOrderStatus.complete
                            ? null
                            : () => viewModel.toggleTask(index),
                        child: Icon(
                          item.isCompleted
                              ? Icons.check_circle
                              : Icons.circle_outlined,
                          color: item.isCompleted
                              ? AppColors.success500
                              : AppColors.secondary300,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: AppDimens.spaceSm),
                      Expanded(
                        child: Text(
                          item.title,
                          style: TextStyles.bodyMedium.copyWith(
                            color: item.isCompleted
                                ? AppColors.secondary200
                                : AppColors.secondary500,
                            decoration: item.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
