import 'package:flutter/material.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/presentation/common/core/app_assets.dart'
    show AppAssets;

class ZentBottomLogo extends StatelessWidget {
  const ZentBottomLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimens.spaceLg),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(AppAssets.blackLogo, height: 28, fit: BoxFit.contain),
          const SizedBox(width: AppDimens.spaceSm),
          Text(
            'ZENT',
            style: TextStyles.title.copyWith(
              letterSpacing: 1.5,
              color: AppColors.primary500,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
