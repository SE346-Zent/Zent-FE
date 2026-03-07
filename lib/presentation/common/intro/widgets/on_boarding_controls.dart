import 'package:flutter/material.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';

class OnBoardingControls extends StatelessWidget {
  final bool isLastPage;
  final VoidCallback onNextPressed;
  final VoidCallback onSkipPressed;

  const OnBoardingControls({
    super.key,
    required this.isLastPage,
    required this.onNextPressed,
    required this.onSkipPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        mainAxisAlignment: isLastPage ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween,
        children: [
          if (!isLastPage)
            InkWell(
              onTap: onSkipPressed,
              child: Text(
                "SKIP",
                style: TextStyles.bodyLarge.copyWith(
                  color: AppColors.secondary300,
                ),
              ),
            ),
          ElevatedButton(
            onPressed: onNextPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.tertiary500,
              minimumSize: Size(isLastPage ? 229 : 170, 45),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimens.boraMd)),
              elevation: 0,
            ),
            child: Text(
              isLastPage ? "Get Started →" : "Continue",
              style: TextStyles.title.copyWith(color: AppColors.surface50),
            ),
          ),
        ],
      ),
    );
  }
}