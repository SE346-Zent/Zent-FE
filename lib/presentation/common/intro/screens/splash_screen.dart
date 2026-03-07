import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:go_router/go_router.dart'; 
import 'package:zent_fe/routing/routes.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';

import '../widgets/splash_logo_widget.dart';

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
      context.replace(Routes.onBoarding); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background500,
      body: Center(
        child: SplashLogoWidget(isVisible: _isVisible),
      ),
    );
  }
}