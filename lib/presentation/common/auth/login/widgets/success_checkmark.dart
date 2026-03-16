import 'package:flutter/material.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';

class SuccessCheckmark extends StatelessWidget {
  const SuccessCheckmark({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 135,
      height: 135,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.20),
            blurRadius: 10.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Icon(
          Icons.check_circle_outline,
          size: 85,
          color: AppColors.tertiary500,
        ),
      ),
    );
  }
}
