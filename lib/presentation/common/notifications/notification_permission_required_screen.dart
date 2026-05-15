import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/presentation/common/core/ui/button.dart';

class NotificationPermissionRequiredScreen extends StatefulWidget {
  const NotificationPermissionRequiredScreen({super.key});

  @override
  State<NotificationPermissionRequiredScreen> createState() =>
      _NotificationPermissionRequiredScreenState();
}

class _NotificationPermissionRequiredScreenState
    extends State<NotificationPermissionRequiredScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Re-check permission when user returns to app
      _checkPermission();
    }
  }

  Future<void> _checkPermission() async {
    final settings = await FirebaseMessaging.instance.getNotificationSettings();
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // Permission granted, router will handle redirect back
      if (mounted) {
        // Just trigger a rebuild or navigation refresh
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background500,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.spaceXl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.notifications_off_outlined,
                size: 80,
                color: AppColors.tertiary500,
              ),
              const SizedBox(height: AppDimens.spaceXl),
              Text(
                'Notification Required',
                style: TextStyles.display.copyWith(color: AppColors.primary500),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimens.spaceMd),
              Text(
                'As an Admin or Technician, receiving real-time updates is critical for operation. Please enable notifications in your system settings to continue using the app.',
                style: TextStyles.bodyLarge.copyWith(
                  color: AppColors.secondary500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimens.spaceXl),
              PrimaryActionButton(
                label: 'Open Settings',
                onPressed: () => openAppSettings(),
                width: double.infinity,
              ),
              const SizedBox(height: AppDimens.spaceMd),
              TextButton(
                onPressed: _checkPermission,
                child: Text(
                  'I have enabled it',
                  style: TextStyles.middle.copyWith(
                    color: AppColors.tertiary500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
