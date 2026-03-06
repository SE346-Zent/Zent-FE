import 'package:flutter/material.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _data = [
    {
      "image": "assets/images/OnBoarding1.webp",
      "title": "Centralize Your Operations",
      "desc": "Manage your entire field service workflow from a single, intuitive digital hub. No more fragmented tools."
    },
    {
      "image": "assets/images/OnBoarding2.webp",
      "title": "Empower Your Team",
      "desc": "Enable instant job syncing and real-time reporting. Keep your field technicians aligned with zero latency."
    },
    {
      "image": "assets/images/OnBoarding3.webp",
      "title": "Optimize Peformance", 
      "desc": "Make data-driven decisions with real-time analytics. Track and easily see your improvements."
    },
  ];

  void _onNextPressed() {
    if (_currentPage < _data.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      debugPrint("Navigate to Login");
    }
  }

  void _onSkipPressed() {
    debugPrint("Skip to Login");
  }

  @override
  Widget build(BuildContext context) {
    bool isLastPage = _currentPage == _data.length - 1;

    return Scaffold(
      backgroundColor: AppColors.background500,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                allowImplicitScrolling: true,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemCount: _data.length,
                itemBuilder: (context, index) => _buildPageContent(index),
              ),
            ),
            
            _buildBottomControls(isLastPage),
            const SizedBox(height: 30), 
          ],
        ),
      ),
    );
  }

  Widget _buildPageContent(int index) {
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
          Text(
            _data[index]["title"]!,
            textAlign: TextAlign.center,
            style: TextStyles.display.copyWith(color: AppColors.primary500),
          ),
          const SizedBox(height: AppDimens.spaceMd),
          Text(
            _data[index]["desc"]!,
            textAlign: TextAlign.center,
            style: TextStyles.bodyLarge.copyWith(color: AppColors.secondary500),
          ),
          const SizedBox(height: 40),
          _buildPageIndicator(),
        ],
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _data.length,
        (index) => AnimatedContainer( 
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(horizontal: AppDimens.spaceXs),
          width: _currentPage == index ? AppDimens.spaceLg : AppDimens.spaceSm,
          height: AppDimens.spaceSm,
          decoration: BoxDecoration(
            color: _currentPage == index ? AppColors.tertiary500 : AppColors.background600,
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
        mainAxisAlignment: isLastPage ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween,
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
          ElevatedButton(
            onPressed: _onNextPressed,
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