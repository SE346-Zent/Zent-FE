import 'package:flutter/material.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';

class SplashLogoWidget extends StatelessWidget {
  final bool isVisible;

  const SplashLogoWidget({
    super.key,
    required this.isVisible,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/ZentLogo.webp',
          width: 109,
          height: 129,
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 1000),
          height: isVisible ? AppDimens.spaceLg : 0,
        ),
        AnimatedOpacity(
          duration: const Duration(milliseconds: 1500),
          opacity: isVisible ? 1.0 : 0.0,
          child: Column(
            children: [
              Text(
                'ZENT',
                style: TextStyles.display.copyWith(color: AppColors.primary500),
              ),
              const SizedBox(height: AppDimens.spaceXs),
              Text(
                'Accountability in Every Action',
                textAlign: TextAlign.center,
                style: TextStyles.bodyLarge.copyWith(color: AppColors.secondary500),
              ),
            ],
          ),
        ),
      ],
    );
  }
}