import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zent_fe/routing/routes.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/presentation/common/core/themes/boxshadow.dart';
import 'package:zent_fe/presentation/common/core/app_assets.dart'
    show AppAssets;

import 'package:flutter_bloc/flutter_bloc.dart';

class OnboardingStepCubit extends Cubit<int> {
  OnboardingStepCubit() : super(0);
  void setStep(int step) => emit(step);
}

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OnboardingStepCubit(),
      child: const _OnBoardingScreenContent(),
    );
  }
}

class _OnBoardingScreenContent extends StatefulWidget {
  const _OnBoardingScreenContent();

  @override
  State<_OnBoardingScreenContent> createState() => _OnBoardingContentState();
}

class _OnBoardingContentState extends State<_OnBoardingScreenContent> {
  final PageController _pageController = PageController();

  final List<Map<String, String>> _data = [
    {
      "image": AppAssets.onboarding1,
      "title": "Centralize Your Operations",
      "desc":
          "Manage your entire field service workflow from a single, intuitive digital hub. No more fragmented tools.",
    },
    {
      "image": AppAssets.onboarding2,
      "title": "Empower Your Team",
      "desc":
          "Enable instant job syncing and real-time reporting. Keep your field technicians aligned with zero latency.",
    },
    {
      "image": AppAssets.onboarding3,
      "title": "Optimize Peformance",
      "desc":
          "Make data-driven decisions with real-time analytics. Track and easily see your improvements.",
    },
  ];

  void _onNextPressed() {
    final currentPage = context.read<OnboardingStepCubit>().state;
    if (currentPage < _data.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      context.go(Routes.login);
    }
  }

  void _onSkipPressed() {
    context.go(Routes.login);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingStepCubit, int>(
      builder: (context, currentPage) {
        bool isLastPage = currentPage == _data.length - 1;

        return Scaffold(
          backgroundColor: AppColors.background500,
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    allowImplicitScrolling: true,
                    onPageChanged: (index) =>
                        context.read<OnboardingStepCubit>().setStep(index),
                    itemCount: _data.length,
                    itemBuilder: (context, index) =>
                        _buildPageContent(index, currentPage),
                  ),
                ),
                _buildBottomControls(isLastPage),
                const SizedBox(height: 30),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPageContent(int index, int currentPage) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            _data[index]["image"]!,
            width: 270,
            height: 245,
            cacheWidth: 540,
            cacheHeight: 490,
          ),
          const SizedBox(height: 60),
          Builder(
            builder: (context) {
              final title = _data[index]["title"]!;
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
            _data[index]["desc"]!,
            textAlign: TextAlign.center,
            style: TextStyles.bodyLarge.copyWith(color: AppColors.secondary500),
          ),
          const SizedBox(height: 40),
          _buildPageIndicator(currentPage),
        ],
      ),
    );
  }

  Widget _buildPageIndicator(int currentPage) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _data.length,
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

  Widget _buildBottomControls(bool isLastPage) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        mainAxisAlignment: isLastPage
            ? MainAxisAlignment.center
            : MainAxisAlignment.spaceBetween,
        children: [
          if (!isLastPage)
            InkWell(
              onTap: _onSkipPressed,
              child: Text(
                "SKIP",
                style: TextStyles.bodyLarge.copyWith(
                  color: AppColors.secondary300,
                ),
              ),
            ),
          Container(
            decoration: BoxDecoration(
              boxShadow: [BoxShadowStyles.raised],
              borderRadius: BorderRadius.circular(AppDimens.boraMd),
            ),
            child: ElevatedButton(
              onPressed: _onNextPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.tertiary500,
                minimumSize: Size(isLastPage ? 229 : 170, 45),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimens.boraMd),
                ),
                elevation: 0,
              ),
              child: Text(
                isLastPage ? "Get Started →" : "Continue",
                style: TextStyles.title.copyWith(color: AppColors.surface100),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
