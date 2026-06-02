import 'package:zent_fe/presentation/common/core/safe_change_notifier.dart';
import 'package:flutter/material.dart';

class TechNotificationsViewModel extends ChangeNotifier
    with SafeChangeNotifier {
  bool newJobAssignments = true;
  bool urgentDispatches = false;
  bool equipmentMaintenance = true;
  bool directMessage = true;
  bool customerFeedback = true;

  void toggleSetting(String key, bool value) {
    switch (key) {
      case 'newJob':
        newJobAssignments = value;
        break;
      case 'urgent':
        urgentDispatches = value;
        break;
      case 'equipment':
        equipmentMaintenance = value;
        break;
      case 'directMsg':
        directMessage = value;
        break;
      case 'feedback':
        customerFeedback = value;
        break;
    }
    notifyListeners(); // Notify UI to update when a setting changes
  }
}
