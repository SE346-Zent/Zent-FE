import 'package:flutter/material.dart';
import 'package:zent_fe/presentation/common/core/utils/tap_debounce.dart';

// Core Theming
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/presentation/common/core/themes/boxshadow.dart';

class ProfileMenuItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData iconData;
  final VoidCallback onTap;

  const ProfileMenuItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.iconData,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimens.boraMd),
        boxShadow: [BoxShadowStyles.subtle],
      ),
      child: Material(
        color: AppColors.surface100,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: AppColors.surface600, width: 1.0),
          borderRadius: BorderRadius.circular(AppDimens.boraMd),
        ),
        child: ThrottledInkWell(
          onTap: () {
            Future.delayed(const Duration(milliseconds: 150), onTap);
          },
          borderRadius: BorderRadius.circular(AppDimens.boraMd),
          splashColor: AppColors.secondary100.withValues(alpha: 0.5),
          highlightColor: AppColors.secondary50.withValues(alpha: 0.3),
          child: Container(
            width: double.infinity,
            height: 60.0,
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceMd),
            child: Row(
              children: [
                Container(
                  width: 36.0,
                  height: 36.0,
                  decoration: const BoxDecoration(
                    color: AppColors.tertiary50,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    iconData,
                    color: AppColors.tertiary500,
                    size: 20.0,
                  ),
                ),
                const SizedBox(width: AppDimens.spaceMd),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: TextStyles.middle.copyWith(
                          color: AppColors.primary500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        subtitle,
                        style: TextStyles.bodyMedium.copyWith(
                          color: AppColors.secondary300,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  color: AppColors.secondary200,
                  size: 24.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
