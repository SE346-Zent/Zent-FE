import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:zent_fe/presentation/common/intro/on_boarding_screen.dart'; 
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';

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
      'assets/images/OnBoarding1.webp',
      'assets/images/OnBoarding2.webp',
      'assets/images/OnBoarding3.webp',
    ];

    try {
      await Future.wait([
        ...onboardingImages.map((path) => precacheImage(AssetImage(path), context)),
      ]);
    } catch (e) {
      debugPrint("Precache error: $e");
    }

    await Future.delayed(const Duration(milliseconds: 2000));

    FlutterNativeSplash.remove();
    
if (mounted) {
      Navigator.pushReplacement(
        context, 
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const OnBoardingScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 0.05); 
            const end = Offset.zero;
            const curve = Curves.easeOutCubic; 

            var slideTween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var fadeTween = Tween(begin: 0.0, end: 1.0).chain(CurveTween(
                    curve: const Interval(0.0, 0.4, curve: Curves.easeOut)
                  ,));
            return FadeTransition(
              opacity: animation.drive(fadeTween),
              child: SlideTransition(
                position: animation.drive(slideTween),
                child: child,
              ),
            );
          },
          transitionDuration: const Duration(milliseconds: 1200), 
        ),
      );
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
            Image.asset(
              'assets/images/ZentLogo.webp',
              width: 109, 
              height: 129,
            ),
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
        ),
      ),
    );
  }
}