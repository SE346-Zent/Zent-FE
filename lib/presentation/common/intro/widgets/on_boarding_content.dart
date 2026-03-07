import 'package:flutter/material.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';

class OnBoardingContent extends StatelessWidget {
  final String image;
  final String title;
  final String desc;

  const OnBoardingContent({
    super.key,
    required this.image,
    required this.title,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          image,
          width: 270,
          height: 245,
          cacheWidth: 540,
          cacheHeight: 490,
        ),
        const SizedBox(height: 60),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyles.display.copyWith(color: AppColors.primary500),
        ),
        const SizedBox(height: AppDimens.spaceMd),
        Text(
          desc,
          textAlign: TextAlign.center,
          style: TextStyles.bodyLarge.copyWith(color: AppColors.secondary500),
        ),
      ],
    );
  }
}