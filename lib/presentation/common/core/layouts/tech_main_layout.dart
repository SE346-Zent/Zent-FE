import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Core Theming
import '../themes/colors.dart';
import '../themes/text_styles.dart';
import '../themes/boxshadow.dart';
import '../../../technician/account/widgets/tech_sidebar.dart';

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
      drawerScrimColor: AppColors.background500.withValues(alpha: 0.66),
      drawer: const TechSidebar(
        userName: 'Hung dep zai',
        employeeId: 'TECH-1234',
      ),
      body: navigationShell,

      floatingActionButton: _AnimatedFAB(
        onTap: () {
          debugPrint('🔧 Đã bấm nút cờ lê sửa chữa!');
        },
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: SafeArea(
        bottom: true,
        child: _TechBottomNavBar(
          currentIndex: navigationShell.currentIndex,
          onTap: _goBranch,
        ),
      ),
    );
  }
}

class _AnimatedFAB extends StatefulWidget {
  final VoidCallback onTap;
  const _AnimatedFAB({required this.onTap});

  @override
  State<_AnimatedFAB> createState() => _AnimatedFABState();
}

class _AnimatedFABState extends State<_AnimatedFAB> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.9 : 1.0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeInOut,
        child: Container(
          width: 60.0,
          height: 60.0,
          decoration: BoxDecoration(
            color: AppColors.tertiary500,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.tertiary200, width: 2.0),
            boxShadow: [BoxShadowStyles.raised],
          ),
          child: const Icon(Icons.build, color: Colors.white, size: 30.0),
        ),
      ),
    );
  }
}

class _TechBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _TechBottomNavBar({required this.currentIndex, required this.onTap});

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

          const SizedBox(width: 70.0),

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
        borderRadius: BorderRadius.circular(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedScale(
              scale: isSelected ? 1.15 : 1.0,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutBack,
              child: SizedBox(
                width: 30.0,
                height: 30.0,
                child: Icon(icon, size: 30.0, color: color),
              ),
            ),
            const SizedBox(height: 2.0),
            Text(
              label,
              style: TextStyles.bodyMedium.copyWith(color: color, fontSize: 12),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
