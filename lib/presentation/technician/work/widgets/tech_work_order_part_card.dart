import 'package:flutter/material.dart';
import 'package:zent_fe/domain/entities/work_order_completion_draft.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/presentation/common/core/themes/boxshadow.dart';

class TechWorkOrderPartCard extends StatelessWidget {
  final TechWorkOrderPart part;
  final VoidCallback onRemove;

  const TechWorkOrderPartCard({
    super.key,
    required this.part,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimens.spaceSm),
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spaceMd,
        vertical: AppDimens.spaceSm,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface100,
        borderRadius: BorderRadius.circular(AppDimens.boraSm),
        boxShadow: [BoxShadowStyles.subtle],
        border: Border.all(color: AppColors.secondary50, width: 1.0),
      ),
      child: Row(
        children: [
          // Quantity Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            decoration: BoxDecoration(
              color: AppColors.secondary100,
              borderRadius: BorderRadius.circular(AppDimens.boraXs),
            ),
            child: Text(
              "${part.quantity}x",
              style: TextStyles.label.copyWith(color: AppColors.secondary500),
            ),
          ),
          const SizedBox(width: AppDimens.spaceMd),
          // Part Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  part.name,
                  style: TextStyles.middle.copyWith(
                    color: AppColors.primary500,
                  ),
                ),
                Text(
                  "ID: ${part.id}",
                  style: TextStyles.label.copyWith(
                    color: AppColors.secondary300,
                  ),
                ),
              ],
            ),
          ),
          // Remove Action
          IconButton(
            onPressed: onRemove,
            icon: const Icon(Icons.delete_outline, color: AppColors.error500),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}
