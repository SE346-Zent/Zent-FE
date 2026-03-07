import 'package:flutter/material.dart';

class LoginBackground extends StatelessWidget {
  const LoginBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/LoginBackground.webp',
      width: double.infinity,
      height: 320,
      fit: BoxFit.cover,
      cacheHeight: 400,
    );
  }
}