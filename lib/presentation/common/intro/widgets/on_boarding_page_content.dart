import 'package:flutter/material.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'on_boarding_page_indicator.dart';

class OnBoardingPageContent extends StatelessWidget {
  final Map<String, String> data;
  final int totalPages;

  const OnBoardingPageContent({
    super.key,
    required this.data,
    required this.totalPages,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            data["image"]!,
            width: 270,
            height: 245,
            cacheWidth: 540,
            cacheHeight: 490,
          ),
          const SizedBox(height: 60),
          Builder(
            builder: (context) {
              final title = data["title"]!;
              final firstSpaceIndex = title.indexOf(' ');
              final firstWord = firstSpaceIndex != -1
                  ? title.substring(0, firstSpaceIndex)
                  : title;
              final restOfTitle = firstSpaceIndex != -1
                  ? title.substring(firstSpaceIndex)
                  : '';

              return RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyles.display,
                  children: [
                    TextSpan(
                      text: firstWord,
                      style: TextStyle(color: AppColors.tertiary500),
                    ),
                    TextSpan(
                      text: restOfTitle,
                      style: TextStyle(color: AppColors.primary500),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: AppDimens.spaceMd),
          Text(
            data["desc"]!,
            textAlign: TextAlign.center,
            style: TextStyles.bodyLarge.copyWith(color: AppColors.secondary500),
          ),
          const SizedBox(height: 40),
          OnBoardingPageIndicator(totalPages: totalPages),
        ],
      ),
    );
  }
}
