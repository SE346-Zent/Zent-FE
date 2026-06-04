import 'package:zent_fe/presentation/common/core/safe_change_notifier.dart';
import 'package:flutter/material.dart';
import 'package:zent_fe/domain/repositories/notification_repository.dart';
import 'package:zent_fe/data/models/notification_preference_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zent_fe/presentation/common/core/ui/zent_success_popup.dart';
import 'package:zent_fe/presentation/common/core/ui/zent_error_popup.dart';

class CustomerNotificationsViewModel extends ChangeNotifier
    with SafeChangeNotifier {
  final NotificationRepository notificationRepository;

  CustomerNotificationsViewModel({required this.notificationRepository}) {
    loadPreferences();
  }

  List<NotificationPreferenceModel> _preferences = [];
  List<NotificationPreferenceModel> get preferences => _preferences;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Local state changes to save on button press
  final Map<String, bool> _localToggles = {};

  bool get directMessage =>
      _localToggles['directMessage'] ??
      _getPrefValue('message') ??
      _getPrefValue('chat') ??
      true;

  bool get tracking =>
      _localToggles['tracking'] ??
      _getPrefValue('tracking') ??
      _getPrefValue('work') ??
      true;

  bool get appointmentReminders =>
      _localToggles['appointmentReminders'] ??
      _getPrefValue('appointment') ??
      _getPrefValue('reminder') ??
      true;

  bool get invoice =>
      _localToggles['invoice'] ??
      _getPrefValue('invoice') ??
      _getPrefValue('bill') ??
      true;

  bool? _getPrefValue(String keyword) {
    try {
      final pref = _preferences.firstWhere(
        (p) =>
            p.categorySlug.toLowerCase().contains(keyword) ||
            p.categoryName.toLowerCase().contains(keyword),
      );
      return pref.osEnabled;
    } catch (_) {
      return null;
    }
  }

  Future<void> loadPreferences() async {
    _isLoading = true;
    notifyListeners();
    try {
      _preferences = await notificationRepository.getNotificationPreferences();
      _localToggles.clear();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('pref_direct_message_enabled', directMessage);
    } catch (e) {
      debugPrint('Error loading notification preferences: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void toggleSetting(String key, bool value) {
    // Map 'directMsg' to 'directMessage' to fix screen key mismatch
    final normalizedKey = key == 'directMsg' ? 'directMessage' : key;
    _localToggles[normalizedKey] = value;
    notifyListeners();
  }

  Future<void> saveSettings(BuildContext context) async {
    _isLoading = true;
    notifyListeners();
    try {
      // Find and update each modified preference
      for (final entry in _localToggles.entries) {
        final key = entry.key;
        final val = entry.value;

        String keyword = '';
        if (key == 'directMessage') {
          keyword = 'message';
        } else if (key == 'tracking') {
          keyword = 'tracking';
        } else if (key == 'appointmentReminders') {
          keyword = 'appointment';
        } else if (key == 'invoice') {
          keyword = 'invoice';
        }

        NotificationPreferenceModel? pref;
        try {
          pref = _preferences.firstWhere(
            (p) =>
                p.categorySlug.toLowerCase().contains(keyword) ||
                p.categoryName.toLowerCase().contains(keyword),
          );
        } catch (_) {
          if (key == 'directMessage') {
            try {
              pref = _preferences.firstWhere(
                (p) =>
                    p.categorySlug.toLowerCase().contains('chat') ||
                    p.categoryName.toLowerCase().contains('chat'),
              );
            } catch (_) {}
          }
        }

        if (pref != null) {
          await notificationRepository.updateNotificationPreference(
            pref.categoryId,
            val,
          );
        }
      }

      await loadPreferences();

      // Explicitly store the updated preference after loadPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('pref_direct_message_enabled', directMessage);

      if (context.mounted) {
        ZentSuccessPopup.show(
          context,
          'Notification settings saved successfully!',
        );
      }
    } catch (e) {
      debugPrint('Error saving notification preferences: $e');
      if (context.mounted) {
        ZentErrorPopup.show(context, 'Failed to save settings: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
