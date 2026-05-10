import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/presentation/common/core/app_assets.dart'
    show AppAssets;
import 'package:zent_fe/di/injection_container.dart' as di;
import 'package:zent_fe/presentation/common/intro/viewmodels/splash_viewmodel.dart';
import 'package:zent_fe/routing/route_names.dart';

class AppSplashScreen extends StatelessWidget {
  const AppSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => di.sl<SplashViewModel>(),
      child: const _SplashScreenContent(),
    );
  }
}

class _SplashScreenContent extends StatefulWidget {
  const _SplashScreenContent();

  @override
  State<_SplashScreenContent> createState() => _SplashScreenContentState();
}

class _SplashScreenContentState extends State<_SplashScreenContent> {
  bool _isVisible = false;
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _isInitialized = true;
      _initApp();
    }
  }

  Future<void> _initApp() async {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) setState(() => _isVisible = true);
    });

    final onboardingImages = [
      AppAssets.onboarding1,
      AppAssets.onboarding2,
      AppAssets.onboarding3,
    ];

    try {
      await Future.wait([
        ...onboardingImages.map(
          (path) => precacheImage(AssetImage(path), context),
        ),
      ]);
    } catch (e) {
      debugPrint("Precache error: $e");
    }

    await Future.delayed(const Duration(milliseconds: 2000));

    FlutterNativeSplash.remove();

    if (!mounted) return;
    final splashViewModel = context.read<SplashViewModel>();
    final isFirstTime = await splashViewModel.resolveFirstTimeFlow();

    if (mounted) {
      if (isFirstTime) {
        context.goNamed(RouteNames.onBoarding);
      } else {
        context.goNamed(RouteNames.login);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background500,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(AppAssets.blackLogo, width: 109, height: 129),
            AnimatedContainer(
              duration: const Duration(milliseconds: 1000),
              height: _isVisible ? AppDimens.spaceLg : 0,
            ),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 1500),
              opacity: _isVisible ? 1.0 : 0.0,
              child: Column(
                children: [
                  Text(
                    'ZENT',
                    style: TextStyles.display.copyWith(
                      color: AppColors.primary500,
                    ),
                  ),
                  const SizedBox(height: AppDimens.spaceXs),
                  Text(
                    'Accountability in Every Action',
                    textAlign: TextAlign.center,
                    style: TextStyles.bodyLarge.copyWith(
                      color: AppColors.secondary500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
