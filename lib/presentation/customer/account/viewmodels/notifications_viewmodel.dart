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
  final Map<int, bool> _localToggles = {};
  bool? _localDirectMessage;

  bool _prefsDirectMessageEnabled = true;

  bool get directMessage => _localDirectMessage ?? _prefsDirectMessageEnabled;

  bool isEnabled(int categoryId, bool defaultVal) {
    return _localToggles[categoryId] ?? defaultVal;
  }

  void toggleDirectMessage(bool value) {
    _localDirectMessage = value;
    notifyListeners();
  }

  void toggleSetting(int categoryId, bool value) {
    _localToggles[categoryId] = value;
    notifyListeners();
  }

  Future<void> loadPreferences() async {
    _isLoading = true;
    notifyListeners();
    try {
      _preferences = await notificationRepository.getNotificationPreferences();
      _localToggles.clear();
      _localDirectMessage = null;

      final prefs = await SharedPreferences.getInstance();
      _prefsDirectMessageEnabled =
          prefs.getBool('pref_direct_message_enabled') ?? true;
    } catch (e) {
      debugPrint('Error loading notification preferences: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveSettings(BuildContext context) async {
    _isLoading = true;
    notifyListeners();
    try {
      // Find and update each modified preference on the server
      for (final entry in _localToggles.entries) {
        final categoryId = entry.key;
        final val = entry.value;

        await notificationRepository.updateNotificationPreference(
          categoryId,
          val,
        );

        // Update in-memory immediately so UI reflects the saved state
        final idx = _preferences.indexWhere((p) => p.categoryId == categoryId);
        if (idx != -1) {
          final pref = _preferences[idx];
          _preferences[idx] = NotificationPreferenceModel(
            categoryId: pref.categoryId,
            categoryName: pref.categoryName,
            categorySlug: pref.categorySlug,
            osEnabled: val,
            updatedAt: pref.updatedAt,
          );
        }
      }

      // Clear local overrides now that _preferences reflects the saved state
      _localToggles.clear();

      // Persist direct message setting to SharedPreferences
      if (_localDirectMessage != null) {
        _prefsDirectMessageEnabled = _localDirectMessage!;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool(
          'pref_direct_message_enabled',
          _prefsDirectMessageEnabled,
        );
        _localDirectMessage = null;
      }

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
