import 'package:flutter/material.dart';

class ChatBackground extends StatelessWidget {
  const ChatBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Opacity(
        opacity: 0.1,
        child: Image.asset(
          'assets/images/ZentLogo.webp',
          width: 109.0,
          height: 129.0,
          errorBuilder: (context, error, stackTrace) => const SizedBox(),
        ),
      ),
    );
  }
}
