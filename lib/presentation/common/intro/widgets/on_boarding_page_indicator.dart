import 'package:flutter/material.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';

class OnBoardingPageIndicator extends StatelessWidget {
  final int totalPages;
  final int currentPage;

  const OnBoardingPageIndicator({
    super.key,
    required this.totalPages,
    required this.currentPage,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        totalPages,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(horizontal: AppDimens.spaceXs),
          width: currentPage == index ? AppDimens.spaceLg : AppDimens.spaceSm,
          height: AppDimens.spaceSm,
          decoration: BoxDecoration(
            color: currentPage == index
                ? AppColors.tertiary500
                : AppColors.background600,
            borderRadius: BorderRadius.circular(AppDimens.boraXs),
          ),
        ),
      ),
    );
  }
}
