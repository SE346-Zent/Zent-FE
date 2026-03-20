import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../themes/colors.dart';
import '../themes/text_styles.dart';

class TechMainLayout extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const TechMainLayout({super.key, required this.navigationShell});

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background500,
      body: navigationShell,
      
      floatingActionButton: GestureDetector(
        onTap: () {
          debugPrint('🔧 Đã bấm nút cờ lê sửa chữa!');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Sẵn sàng sửa chữa! 🔧')),
          );
        },
        child: Container(
          width: 48.0,
          height: 48.0,
          decoration: const BoxDecoration(
            color: AppColors.tertiary500,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(Icons.build, color: Colors.white, size: 24.0),
        ),
      ),
      
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: _TechBottomNavBar(
        currentIndex: navigationShell.currentIndex,
        onTap: _goBranch,
      ),
    );
  }
}

class _TechBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _TechBottomNavBar({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.0,
      decoration: const BoxDecoration(
        color: AppColors.surface100,
        border: Border(
          top: BorderSide(color: AppColors.surface700, width: 1.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavBarItem(
            icon: Icons.home_outlined,
            label: 'Home',
            isSelected: currentIndex == 0,
            onTap: () => onTap(0),
          ),
          _NavBarItem(
            icon: Icons.assignment_outlined,
            label: 'Work Orders',
            isSelected: currentIndex == 1,
            onTap: () => onTap(1),
          ),

          const SizedBox(width: 48.0),

          _NavBarItem(
            icon: Icons.send_outlined,
            label: 'Messages',
            isSelected: currentIndex == 2,
            onTap: () => onTap(2),
          ),
          _NavBarItem(
            icon: Icons.person_outline,
            label: 'Profile',
            isSelected: currentIndex == 3,
            onTap: () => onTap(3),
          ),
        ],
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? AppColors.tertiary500 : AppColors.secondary300;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 24.0,
              height: 24.0,
              child: Icon(icon, size: 24.0, color: color),
            ),
            const SizedBox(height: 4.0),
            Text(label, style: TextStyles.bodyMedium.copyWith(color: color, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
