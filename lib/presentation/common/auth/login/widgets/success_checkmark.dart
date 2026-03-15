import 'package:flutter/material.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';

class SuccessCheckmark extends StatelessWidget {
  const SuccessCheckmark({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        // 💡 1. Bóng đổ của cái Vòng tròn bọc ngoài
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
          size: 110,
          color: AppColors.tertiary500,
        ),
      ),
    );
  }
}