import 'package:flutter/material.dart';
import 'package:zent_fe/presentation/common/core/utils/tap_debounce.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/presentation/common/core/themes/boxshadow.dart';

class SidebarMenuItem extends StatelessWidget {
  final String title;
  final Widget icon;
  final bool isActive;
  final VoidCallback onTap;

  const SidebarMenuItem({
    super.key,
    required this.title,
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimens.spaceMd),
      decoration: BoxDecoration(
        color: isActive ? AppColors.tertiary500 : Colors.transparent,
        borderRadius: BorderRadius.circular(AppDimens.boraSm),
        boxShadow: isActive ? [BoxShadowStyles.raised] : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: ThrottledInkWell(
          borderRadius: BorderRadius.circular(AppDimens.boraSm),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.spaceMd,
              vertical: AppDimens.spaceSm,
            ),
            child: Row(
              children: [
                SizedBox(width: 34.0, height: 34.0, child: Center(child: icon)),
                const SizedBox(width: AppDimens.spaceSm),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyles.title.copyWith(
                      color: isActive
                          ? AppColors.surface100
                          : AppColors.primary500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
