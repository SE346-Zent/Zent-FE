import 'package:flutter/material.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/presentation/common/core/themes/boxshadow.dart';

class UserRoleTabs extends StatelessWidget {
  final int activeIndex;
  final ValueChanged<int> onTabChanged;

  const UserRoleTabs({
    super.key,
    required this.activeIndex,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 364.0,
      height: 46.0,
      decoration: BoxDecoration(
        color: AppColors.secondary50,
        borderRadius: BorderRadius.circular(AppDimens.boraMd),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
      child: Row(
        children: [
          _buildTab(context, title: 'Technicians', index: 0),
          _buildTab(context, title: 'Admin', index: 1),
        ],
      ),
    );
  }

  Widget _buildTab(
    BuildContext context, {
    required String title,
    required int index,
  }) {
    final isActive = activeIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTabChanged(index),
        child: Container(
          height: 37.0,
          decoration: BoxDecoration(
            color: isActive ? AppColors.surface100 : Colors.transparent,
            borderRadius: BorderRadius.circular(AppDimens.boraMd),
            boxShadow: isActive ? [BoxShadowStyles.subtle] : [],
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyles.middle.copyWith(
              color: isActive ? AppColors.tertiary500 : AppColors.primary500,
            ),
          ),
        ),
      ),
    );
  }
}
