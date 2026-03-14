import 'package:flutter/material.dart';
import '../../../core/app_assets.dart';

class LoginBackground extends StatelessWidget {
  const LoginBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppAssets.loginBackground,
      width: double.infinity,
      height: 320,
      fit: BoxFit.cover,
      cacheHeight: 400,
    );
  }
}