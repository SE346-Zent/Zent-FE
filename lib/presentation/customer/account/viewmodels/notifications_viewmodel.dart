import 'package:zent_fe/presentation/common/core/safe_change_notifier.dart';
import 'package:flutter/material.dart';

class CustomerNotificationsViewModel extends ChangeNotifier
    with SafeChangeNotifier {
  bool directMessage = true;
  bool tracking = true;
  bool appointmentReminders = true;
  bool invoice = true;

  void toggleSetting(String key, bool value) {
    switch (key) {
      case 'directMessage':
        directMessage = value;
        break;
      case 'tracking':
        tracking = value;
        break;
      case 'appointmentReminders':
        appointmentReminders = value;
        break;
      case 'invoice':
        invoice = value;
        break;
    }
    notifyListeners();
  }

  void saveSettings(BuildContext context) {
    debugPrint('Viewmodel: Saving Notifications settings...');
    debugPrint('Notifications settings saved!');
  }
}
