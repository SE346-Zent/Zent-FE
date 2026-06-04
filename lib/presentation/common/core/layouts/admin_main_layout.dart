import 'package:flutter/material.dart';
import 'package:zent_fe/presentation/common/core/utils/tap_debounce.dart';
import 'package:go_router/go_router.dart';

// Core Theming
import '../themes/colors.dart';
import '../themes/text_styles.dart';
import '../themes/boxshadow.dart';
import '../../../admin/account/widgets/admin_sidebar.dart';
import '../../../../routing/route_names.dart';
import 'package:provider/provider.dart';
import '../../auth/auth_view_model.dart';

class AdminMainLayout extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const AdminMainLayout({super.key, required this.navigationShell});

  @override
  State<AdminMainLayout> createState() => _AdminMainLayoutState();
}

class _AdminMainLayoutState extends State<AdminMainLayout> {
  void _goBranch(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUri = GoRouterState.of(context).uri.toString();
    final isQueueScreen = currentUri.toLowerCase().contains('queue');
    final displayIndex = isQueueScreen
        ? -1
        : widget.navigationShell.currentIndex;
    final userName =
        context.watch<AuthViewModel>().currentUser?.name ?? 'Admin';
    final canPop = widget.navigationShell.currentIndex == 0;
    return PopScope(
      canPop: canPop,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (widget.navigationShell.currentIndex != 0) {
          _goBranch(0);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background500,
        resizeToAvoidBottomInset: false,
        drawerScrimColor: AppColors.background500.withValues(alpha: 0.66),
        drawer: AdminSidebar(userName: userName, adminId: 'ADMIN-1234'),
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(
                bottom: 70.0 + MediaQuery.paddingOf(context).bottom,
              ),
              child: widget.navigationShell,
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                color: AppColors.surface100,
                padding: EdgeInsets.only(
                  bottom: MediaQuery.paddingOf(context).bottom,
                ),
                child: _AdminBottomNavBar(
                  currentIndex: displayIndex,
                  onTap: _goBranch,
                ),
              ),
            ),
            Positioned(
              bottom: MediaQuery.paddingOf(context).bottom + 70.0 - 30.0,
              left: 0,
              right: 0,
              child: Center(
                child: _AnimatedFAB(
                  onTap: () {
                    if (!isQueueScreen) {
                      context.pushNamed(RouteNames.adminOperationalQueue);
                    }
                  },
                ),
              ),
            ),
          ],
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
    return ThrottledGestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        TapDebounce.call(widget.onTap)?.call();
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
            boxShadow: [BoxShadowStyles.glowing],
          ),
          child: const Icon(
            Icons.assignment_outlined,
            color: Colors.white,
            size: 30.0,
          ),
        ),
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
            icon: Icons.grid_view_outlined,
            label: 'Dashboard',
            isSelected: currentIndex == 0,
            onTap: () => onTap(0),
          ),
          _NavBarItem(
            icon: Icons.insert_chart_outlined,
            label: 'Reports',
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
    final color = isSelected ? AppColors.tertiary500 : AppColors.secondary300;

    return Expanded(
      child: ThrottledInkWell(
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
