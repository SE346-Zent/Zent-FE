import 'package:flutter/material.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';

class SuccessCheckmark extends StatelessWidget {
  const SuccessCheckmark({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: const Center(
        child: Icon(
          Icons.check_circle_outline,
          size: 60,
          color: AppColors.tertiary500,
        ),
      ),
    );
  }
}