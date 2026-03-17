import 'package:flutter/material.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';

class UserSearchBar extends StatelessWidget {
  const UserSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 364.0,
      height: 42.0,
      decoration: BoxDecoration(
        color: AppColors.surface100,
        borderRadius: BorderRadius.circular(
          AppDimens.boraSm,
        ), // Standard text field radius
        border: Border.all(color: AppColors.secondary200, width: 1.0),
      ),
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceMd),
      child: Row(
        children: [
          const Icon(Icons.search, color: AppColors.secondary300, size: 20.0),
          const SizedBox(width: AppDimens.spaceSm),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search users by name or ID',
                hintStyle: TextStyles.bodyLarge.copyWith(
                  color: AppColors.secondary300,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              style: TextStyles.bodyLarge.copyWith(color: AppColors.primary500),
            ),
          ),
        ],
      ),
    );
  }
}
