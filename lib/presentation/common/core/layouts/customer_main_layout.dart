import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../themes/colors.dart';
import '../themes/text_styles.dart';

class CustomerMainLayout extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const CustomerMainLayout({super.key, required this.navigationShell});

  void _onNavTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final canPop = navigationShell.currentIndex == 0;
    return PopScope(
      canPop: canPop,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (navigationShell.currentIndex != 0) {
          _onNavTap(0);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background500,
        body: navigationShell,
        bottomNavigationBar: SafeArea(
          bottom: true,
          child: _CustomerBottomNavBar(
            currentIndex: navigationShell.currentIndex,
            onTap: _onNavTap,
          ),
        ),
      ),
    );
  }
}

class _CustomerBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _CustomerBottomNavBar({
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
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavBarItem(
              icon: Icons.assignment_outlined,
              label: 'Service',
              isSelected: currentIndex == 0,
              onTap: () => onTap(0),
            ),
            _NavBarItem(
              icon: Icons.send_outlined,
              label: 'Messages',
              isSelected: currentIndex == 1,
              onTap: () => onTap(1),
            ),
            _NavBarItem(
              icon: Icons.person_outline,
              label: 'Profile',
              isSelected: currentIndex == 2,
              onTap: () => onTap(2),
            ),
          ],
        ),
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
              width: 24.0,
              height: 24.0,
              child: Icon(icon, size: 24.0, color: color),
            ),
            Text(label, style: TextStyles.bodyMedium.copyWith(color: color)),
          ],
        ),
      ),
    );
  }
}
