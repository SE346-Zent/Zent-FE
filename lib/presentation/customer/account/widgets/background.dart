import 'package:flutter/material.dart';
import 'package:zent_fe/presentation/common/core/app_assets.dart' show AppAssets;

class Background extends StatelessWidget {
  final double opacity;
  final double width;
  final double height;

  const Background({
    super.key,
    required this.opacity,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Opacity(
        opacity: opacity,
        child: Image.asset(
          AppAssets.blackLogo,
          width: width,
          height: height,
          errorBuilder: (context, error, stackTrace) => const SizedBox(),
        ),
      ),
    );
  }
}
