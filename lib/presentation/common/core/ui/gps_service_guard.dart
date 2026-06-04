import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:zent_fe/presentation/common/auth/auth_view_model.dart';
import 'package:zent_fe/domain/entities/enums/user_roles.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';

class GpsServiceGuard extends StatefulWidget {
  final Widget child;

  const GpsServiceGuard({super.key, required this.child});

  @override
  State<GpsServiceGuard> createState() => _GpsServiceGuardState();
}

class _GpsServiceGuardState extends State<GpsServiceGuard> with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  bool _isGpsEnabled = true;
  bool _isChecking = false;
  StreamSubscription<ServiceStatus>? _serviceStatusSubscription;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _checkGpsStatus();

    // Subscribe to service status updates
    _serviceStatusSubscription = Geolocator.getServiceStatusStream().listen((ServiceStatus status) {
      final isEnabled = status == ServiceStatus.enabled;
      if (mounted) {
        setState(() {
          _isGpsEnabled = isEnabled;
        });
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _serviceStatusSubscription?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkGpsStatus();
    }
  }

  Future<void> _checkGpsStatus() async {
    if (_isChecking) return;
    if (mounted) {
      setState(() {
        _isChecking = true;
      });
    }

    try {
      final isEnabled = await Geolocator.isLocationServiceEnabled();
      if (mounted) {
        setState(() {
          _isGpsEnabled = isEnabled;
        });
      }
    } catch (e) {
      debugPrint("GpsServiceGuard: Error checking GPS status: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isChecking = false;
        });
      }
    }
  }

  Future<void> _openLocationSettings() async {
    try {
      await Geolocator.openLocationSettings();
    } catch (e) {
      debugPrint("GpsServiceGuard: Error opening location settings: $e");
      try {
        await Geolocator.openAppSettings();
      } catch (_) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = context.watch<AuthViewModel>();
    final isTechnician = authViewModel.isLoggedIn && authViewModel.role == UserRoles.technician;

    // Only block if the user is a technician and GPS is disabled
    if (isTechnician && !_isGpsEnabled) {
      return PopScope(
        canPop: false, // Prevent physical back button pop
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Scaffold(
            body: Stack(
              children: [
                // Premium deep dark blue gradient background
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.primary700,
                        AppColors.primary500,
                        Color(0xFF1E1E2F),
                      ],
                    ),
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimens.spaceLg,
                      vertical: AppDimens.spaceXl,
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Spacer(),
                          // Pulsing animated radar effect & icon
                          AnimatedBuilder(
                            animation: _animationController,
                            builder: (context, child) {
                              return Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    width: 120 * (1.0 + _animationController.value * 0.15),
                                    height: 120 * (1.0 + _animationController.value * 0.15),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.red.withAlpha((255 * 0.1 * (1.0 - _animationController.value)).round()),
                                    ),
                                  ),
                                  Container(
                                    width: 90 * (1.0 + _animationController.value * 0.1),
                                    height: 90 * (1.0 + _animationController.value * 0.1),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.red.withAlpha((255 * 0.15 * (1.0 - _animationController.value)).round()),
                                    ),
                                  ),
                                  Container(
                                    width: 70,
                                    height: 70,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.error500,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.redAccent,
                                          blurRadius: 16.0,
                                          spreadRadius: 2.0,
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.location_off_rounded,
                                      color: Colors.white,
                                      size: 36,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                          const SizedBox(height: AppDimens.spaceXl),
                          // Title
                          Text(
                            "Location Services Required",
                            textAlign: TextAlign.center,
                            style: TextStyles.headline.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: AppDimens.spaceMd),
                          // Description
                          Text(
                            "GPS/Location services are disabled on your device. As a Technician, you must enable GPS to proceed with tasks, start jobs, and update work orders.",
                            textAlign: TextAlign.center,
                            style: TextStyles.middle.copyWith(
                              color: Colors.white.withAlpha((255 * 0.7).round()),
                              height: 1.5,
                            ),
                          ),
                          const Spacer(),
                          // Action buttons
                          ElevatedButton.icon(
                            onPressed: _openLocationSettings,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: AppColors.primary500,
                              minimumSize: const Size(double.infinity, 52),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(AppDimens.boraMd),
                              ),
                              elevation: 2.0,
                            ),
                            icon: const Icon(Icons.settings_suggest_outlined),
                            label: Text(
                              "Enable GPS Settings",
                              style: TextStyles.middle.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary500,
                              ),
                            ),
                          ),
                          const SizedBox(height: AppDimens.spaceMd),
                          OutlinedButton.icon(
                            onPressed: _isChecking ? null : _checkGpsStatus,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: BorderSide(color: Colors.white.withAlpha((255 * 0.4).round())),
                              minimumSize: const Size(double.infinity, 52),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(AppDimens.boraMd),
                              ),
                            ),
                            icon: _isChecking
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                : const Icon(Icons.refresh),
                            label: Text(
                              _isChecking ? "Checking status..." : "I've Enabled It",
                              style: TextStyles.middle.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: AppDimens.spaceLg),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return widget.child;
  }
}
