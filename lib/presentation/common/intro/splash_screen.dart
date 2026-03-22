import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:go_router/go_router.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/presentation/common/core/app_assets.dart'
    show AppAssets;
import 'package:zent_fe/di/injection_container.dart' as di;
import 'package:zent_fe/data/datasources/local/auth_local_datasource.dart';
import 'package:zent_fe/routing/route_names.dart';

class AppSplashScreen extends StatefulWidget {
  const AppSplashScreen({super.key});

  @override
  State<AppSplashScreen> createState() => _AppSplashScreenState();
}

class _AppSplashScreenState extends State<AppSplashScreen> {
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

    final authLocal = di.sl<AuthLocalDataSource>();
    final isFirstTime = await authLocal.isFirstTime();

    if (isFirstTime) {
      await authLocal.setFirstTimeDone();
      if (mounted) {
        context.goNamed(RouteNames.onBoarding);
      }
    } else {
      if (mounted) {
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
