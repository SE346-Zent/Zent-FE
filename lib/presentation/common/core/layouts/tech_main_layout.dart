import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:zent_fe/presentation/common/core/utils/tap_debounce.dart';
import 'package:go_router/go_router.dart';
import 'package:zent_fe/routing/route_names.dart';
import 'package:zent_fe/di/injection_container.dart';
import 'package:zent_fe/domain/usecases/work_order/get_many_work_orders_usecase.dart';
import 'package:zent_fe/domain/usecases/auth/get_current_user_usecase.dart';
import 'package:zent_fe/domain/entities/enums/work_order_status.dart';

// Core Theming
import '../themes/colors.dart';
import '../themes/text_styles.dart';
import '../themes/boxshadow.dart';
import '../../../technician/account/widgets/tech_sidebar.dart';
import '../../auth/auth_view_model.dart';

class TechMainLayout extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const TechMainLayout({super.key, required this.navigationShell});

  @override
  State<TechMainLayout> createState() => _TechMainLayoutState();
}

class _TechMainLayoutState extends State<TechMainLayout> {
  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  Future<void> _checkLocationPermission() async {
    try {
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        await Geolocator.requestPermission();
      }
    } catch (e) {
      debugPrint("Error checking/requesting location permission on tech layout init: $e");
    }
  }

  void _goBranch(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  Future<void> _navigateToActiveWO(BuildContext context) async {
    try {
      final user = await sl<GetCurrentUserUseCase>().execute();
      if (user == null) return;

      final orders = await sl<GetManyWorkOrdersUseCase>().execute(
        technicianId: user.id,
        limit: 50,
      );

      // Filter only assigned (in-progress) WOs
      final activeOrders = orders
          .where((o) => o.status == WorkOrderStatus.assigned)
          .toList();

      if (activeOrders.isNotEmpty && context.mounted) {
        final now = DateTime.now();

        // Prioritize upcoming work orders
        final upcomingOrders = activeOrders.where((o) {
          final appt = o.appointment;
          return appt != null && appt.isAfter(now);
        }).toList();

        String targetId;
        if (upcomingOrders.isNotEmpty) {
          // Sort upcoming by appointment time (soonest upcoming first)
          upcomingOrders.sort(
            (a, b) => a.appointment!.compareTo(b.appointment!),
          );
          targetId = upcomingOrders.first.id;
        } else {
          // Fallback: sort all active orders by absolute time difference to now
          activeOrders.sort((a, b) {
            final ta = a.appointment ?? a.createdAt;
            final tb = b.appointment ?? b.createdAt;
            final diffA = (ta.difference(now)).abs();
            final diffB = (tb.difference(now)).abs();
            return diffA.compareTo(diffB);
          });
          targetId = activeOrders.first.id;
        }

        context.pushNamed(
          RouteNames.techWorkOrderDetails,
          pathParameters: {'workOrderId': targetId},
        );
      } else if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No active work order assigned to you.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      debugPrint('_navigateToActiveWO error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUri = GoRouterState.of(context).uri.toString();
    final isWorkOrderDetails = currentUri.toLowerCase().contains(
      'work-order-details',
    );
    final isAddNewPart = currentUri.toLowerCase().contains('add-new-part');
    final isSearchScreen = currentUri.toLowerCase().contains(
      'inventory-search',
    );
    final displayIndex = (isWorkOrderDetails || isAddNewPart || isSearchScreen)
        ? -1
        : widget.navigationShell.currentIndex;
    final userName = sl<AuthViewModel>().currentUser?.name ?? 'Technician';

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
        backgroundColor: widget.navigationShell.currentIndex == 2
            ? AppColors.surface100
            : AppColors.background500,
        resizeToAvoidBottomInset: false,
        drawerScrimColor: AppColors.background500.withValues(alpha: 0.66),
        drawer: TechSidebar(userName: userName, employeeId: 'TECH-1234'),
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
                child: _TechBottomNavBar(
                  currentIndex: displayIndex == -1
                      ? widget.navigationShell.currentIndex
                      : displayIndex,
                  onTap: _goBranch,
                ),
              ),
            ),
            Positioned(
              bottom: MediaQuery.paddingOf(context).bottom + 70.0 - 30.0,
              left: 0,
              right: 0,
              child: Center(
                child: _AnimatedFAB(onTap: () => _navigateToActiveWO(context)),
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
