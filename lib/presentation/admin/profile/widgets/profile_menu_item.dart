import 'package:flutter/material.dart';
import '../../../common/core/themes/colors.dart';
import '../../../common/core/themes/dimens.dart';
import '../../../common/core/themes/text_styles.dart';

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
    return Material(
      color: AppColors.surface100,
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: AppColors.surface600, width: 1.0),
        borderRadius: BorderRadius.circular(AppDimens.boraMd),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimens.boraMd),
        child: Container(
          width: 364.0,
          height: 60.0,
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceMd),
          child: Row(
            children: [
              Container(
                width: 36.0,
                height: 36.0,
                decoration: BoxDecoration(
                  color: AppColors.tertiary50,
                  borderRadius: BorderRadius.circular(AppDimens.boraSm),
                ),
                alignment: Alignment.center,
                child: Icon(iconData, color: AppColors.tertiary500, size: 20.0),
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
    );
  }
}
