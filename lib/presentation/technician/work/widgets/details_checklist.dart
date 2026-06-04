import 'package:flutter/material.dart';
import 'package:zent_fe/presentation/common/core/utils/tap_debounce.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/domain/entities/enums/work_order_status.dart';
import '../viewmodels/tech_work_order_details_viewmodel.dart';

class DetailsChecklist extends StatefulWidget {
  final TechWorkOrderDetailsViewModel viewModel;

  const DetailsChecklist({super.key, required this.viewModel});

  @override
  State<DetailsChecklist> createState() => _DetailsChecklistState();
}

class _DetailsChecklistState extends State<DetailsChecklist> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    final viewModel = widget.viewModel;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ThrottledGestureDetector(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          behavior: HitTestBehavior.opaque,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    "Task Checklist",
                    style: TextStyles.middle.copyWith(
                      color: AppColors.primary500,
                    ),
                  ),
                  if (!_isExpanded) ...[
                    const SizedBox(width: 8),
                    Text(
                      "(${viewModel.completedTasksCount} of ${viewModel.totalTasksCount} Complete)",
                      style: TextStyles.bodyMedium.copyWith(
                        color: AppColors.tertiary300,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ],
              ),
              Icon(
                _isExpanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                color: AppColors.primary500,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimens.spaceMd),
        AnimatedCrossFade(
          firstChild: const SizedBox(width: double.infinity),
          secondChild: Container(
            width: double.infinity,
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
                        ThrottledGestureDetector(
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
          crossFadeState: _isExpanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 300),
        ),
      ],
    );
  }
}
