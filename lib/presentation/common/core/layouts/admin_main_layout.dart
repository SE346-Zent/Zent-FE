import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../themes/colors.dart';
import '../themes/text_styles.dart';
import '../themes/dimens.dart';

class AdminMainLayout extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const AdminMainLayout({super.key, required this.navigationShell});

  void _onNavTap(int index) {
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
      bottomNavigationBar: _AdminBottomNavBar(
        currentIndex: navigationShell.currentIndex,
        onTap: _onNavTap,
      ),
    );
  }
}

class _AdminBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _AdminBottomNavBar({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 84.0,
      margin: const EdgeInsets.only(bottom: 24.0),
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
            icon: Icons.grid_view_outlined,
            label: 'Dashboard',
            isSelected: currentIndex == 0,
            onTap: () => onTap(0),
          ),
          _NavBarItem(
            icon: Icons.insert_chart_outlined, // Changed to linear chart
            label: 'Reports',
            isSelected: currentIndex == 1,
            onTap: () => onTap(1),
          ),
          _NavBarItem(
            icon: Icons.groups_outlined,
            label: 'Team',
            isSelected: currentIndex == 2,
            onTap: () => onTap(2),
          ),
          _NavBarItem(
            icon: Icons.person_outline, // Changed to businessperson type icon
            label: 'Admin',
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
    final color = isSelected ? AppColors.tertiary300 : AppColors.secondary300;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 34.0,
              height: 34.0,
              child: Icon(icon, size: 24.0, color: color),
            ),
            const SizedBox(height: AppDimens.spaceXs),
            Text(label, style: TextStyles.bodyMedium.copyWith(color: color)),
          ],
        ),
      ),
    );
  }
}
