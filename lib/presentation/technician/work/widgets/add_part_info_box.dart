import 'package:flutter/material.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';

class AddPartInfoBox extends StatelessWidget {
  const AddPartInfoBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.tertiary50,
        borderRadius: BorderRadius.circular(AppDimens.boraMd),
        border: Border.all(color: AppColors.tertiary500, width: 1.0),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spaceMd,
        vertical: 12.0,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            width: 28.0,
            height: 28.0,
            child: Icon(
              Icons.info_outline,
              color: AppColors.tertiary500,
              size: 28.0,
            ),
          ),
          const SizedBox(width: AppDimens.spaceMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Add new part to the inventory",
                  style: TextStyles.bodyLarge.copyWith(
                    color: AppColors.secondary500,
                  ),
                ),
                Text(
                  "Enter the details of the part that was not found in the inventory system.",
                  style: TextStyles.label.copyWith(
                    color: AppColors.secondary300,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
