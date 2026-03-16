import 'package:flutter/material.dart';
import '../../../core/themes/colors.dart';
import '../../../core/themes/dimens.dart';
import '../../../core/themes/text_styles.dart';
import 'package:zent_fe/presentation/common/core/app_assets.dart'
    show AppAssets;

class AuthHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool showLogo;
  final bool isCenter;

  const AuthHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.showLogo = false,
    this.isCenter = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: isCenter
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        if (showLogo) ...[
          Row(
            mainAxisAlignment: isCenter
                ? MainAxisAlignment.center
                : MainAxisAlignment.start,
            children: [
              Image.asset(AppAssets.blackLogo, height: 24, fit: BoxFit.contain),
              const SizedBox(width: AppDimens.spaceSm),
              Text(
                'ZENT',
                style: TextStyles.title.copyWith(
                  letterSpacing: 1.5,
                  color: AppColors.primary500,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimens.spaceXl),
        ],
        Text(
          title,
          style: TextStyles.display.copyWith(color: AppColors.primary500),
          textAlign: isCenter ? TextAlign.center : TextAlign.start,
        ),
        if (subtitle != null) ...[
          const SizedBox(height: AppDimens.spaceSm),
          Text(
            subtitle!,
            style: TextStyles.bodyMedium.copyWith(color: AppColors.primary500),
            textAlign: isCenter ? TextAlign.center : TextAlign.start,
          ),
        ],
      ],
    );
  }
}
