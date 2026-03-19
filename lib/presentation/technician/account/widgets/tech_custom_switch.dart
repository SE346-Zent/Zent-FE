import 'package:flutter/material.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';

class TechCustomSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const TechCustomSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 56.0,
        height: 28.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14.0),
          color: value ? AppColors.tertiary500 : AppColors.surface600,
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              top: 2.0, 
              left: value ? 30.0 : 2.0,
              right: value ? 2.0 : 30.0,
              child: Container(
                width: 24.0, 
                height: 24.0,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}