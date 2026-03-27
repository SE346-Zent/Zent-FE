import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/app_assets.dart'
    show AppAssets;
import 'package:zent_fe/routing/route_names.dart';

import 'widgets/on_boarding_page_content.dart';
import 'widgets/on_boarding_bottom_controls.dart';

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
    if (_currentPage < _data.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      context.goNamed(RouteNames.login);
    }
  }

  void _onSkipPressed() {
    context.goNamed(RouteNames.login);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isLastPage = _currentPage == _data.length - 1;

    return Scaffold(
      backgroundColor: AppColors.background500,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                allowImplicitScrolling: true,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemCount: _data.length,
                itemBuilder: (context, index) => OnBoardingPageContent(
                  data: _data[index],
                  totalPages: _data.length,
                  currentPage: _currentPage,
                ),
              ),
            ),
            OnBoardingBottomControls(
              isLastPage: isLastPage,
              onNextPressed: _onNextPressed,
              onSkipPressed: _onSkipPressed,
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
