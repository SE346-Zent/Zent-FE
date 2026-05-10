import 'package:flutter/material.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';

class PartSearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final VoidCallback onFilterTapped;

  const PartSearchBar({
    super.key,
    required this.onChanged,
    required this.onFilterTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44.0, // Increased height (approx x1.1)
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimens.boraSm),
        border: Border.all(color: AppColors.secondary200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 8.0, right: 2.0),
            child: Icon(
              Icons.search,
              color: AppColors.secondary300,
              size: 20.0,
            ),
          ),
          Expanded(
            child: TextField(
              onChanged: onChanged,
              style: TextStyles.bodyLarge.copyWith(
                height: 1.2,
                color: AppColors.secondary500,
              ),
              decoration: InputDecoration(
                isDense: true,
                hintText: 'Search users by name or ID',
                hintStyle: TextStyles.bodyLarge.copyWith(
                  color: AppColors.secondary200,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 8.5,
                ), // (44 - height) / 2
              ),
            ),
          ),
          IconButton(
            onPressed: onFilterTapped,
            icon: const Icon(
              Icons.filter_list,
              color: AppColors.primary500,
              size: 20.0,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}
