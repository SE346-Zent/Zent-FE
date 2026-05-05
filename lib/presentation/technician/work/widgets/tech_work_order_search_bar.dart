import 'package:flutter/material.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';

class TechWorkOrderSearchBar extends StatelessWidget {
  const TechWorkOrderSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
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
          style: TextStyles.bodyLarge.copyWith(color: AppColors.secondary200),
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
            contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
          ),
        ),
      ),
    );
  }
}
