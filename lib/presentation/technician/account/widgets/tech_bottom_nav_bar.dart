import 'package:flutter/material.dart';

// Themes 
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/presentation/common/core/themes/boxshadow.dart';

class TechBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final VoidCallback onCenterButtonTap;

  const TechBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.onCenterButtonTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          height: 80.0,
          decoration: const BoxDecoration(
            color: AppColors.surface100,
            border: Border(
              top: BorderSide(color: AppColors.surface700, width: 1.0),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, 'Home', Icons.home_outlined, Icons.home),
              _buildNavItem(1, 'Work Orders', Icons.assignment_outlined, Icons.assignment),
              
              const SizedBox(width: 70.0), 
              
              _buildNavItem(2, 'Messages', Icons.send_outlined, Icons.send),
              _buildNavItem(3, 'Profile', Icons.person_outline, Icons.person),
            ],
          ),
        ),

        Positioned(
          top: -30.0,
          child: GestureDetector(
            onTap: onCenterButtonTap,
            child: Container(
              width: 70.0,
              height: 70.0,
              decoration: BoxDecoration(
                color: AppColors.tertiary500,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.tertiary200, 
                  width: 4.0,
                ),
                boxShadow: [BoxShadowStyles.raised],
              ),
              child: const Icon(
                Icons.build,
                color: AppColors.surface100,
                size: 36.0,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNavItem(
    int index, 
    String label, 
    IconData inactiveIcon, 
    IconData activeIcon,
  ) {
    final isSelected = currentIndex == index;
    final color = isSelected ? AppColors.tertiary500 : AppColors.primary300;
    final icon = isSelected ? activeIcon : inactiveIcon;

    return Expanded(
      child: InkWell(
        onTap: () => onTap(index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30.0, color: color),
            const SizedBox(height: 4.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label,
                  style: TextStyles.bodyLarge.copyWith(color: color),
                  maxLines: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}