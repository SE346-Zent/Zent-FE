import 'package:flutter/material.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/presentation/common/core/themes/boxshadow.dart';

class TimeRangeTabs extends StatelessWidget {
  final int activeIndex;
  final ValueChanged<int> onTabChanged;

  const TimeRangeTabs({
    super.key,
    required this.activeIndex,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final indicatorWidth = (constraints.maxWidth - 8.0) / 2;

        return Container(
          width: double.infinity,
          height: 46.0,
          decoration: BoxDecoration(
            color: AppColors.secondary50,
            borderRadius: BorderRadius.circular(AppDimens.boraMd),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
          child: Stack(
            children: [
              AnimatedAlign(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                alignment: activeIndex == 0
                    ? Alignment.centerLeft
                    : Alignment.centerRight,
                child: Container(
                  width: indicatorWidth,
                  height: 38.0,
                  decoration: BoxDecoration(
                    color: AppColors.surface100,
                    borderRadius: BorderRadius.circular(AppDimens.boraMd),
                    boxShadow: [BoxShadowStyles.subtle],
                  ),
                ),
              ),
              Row(
                children: [
                  _buildTab(context, title: 'Last 7 days', index: 0),
                  _buildTab(context, title: 'Last 30 days', index: 1),
                ],
              ),
            ],
          ),
        );
      },
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
          height: 38.0,
          color: Colors.transparent,
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
