import 'package:flutter/material.dart';

class SecuritySettingsData {
  final bool isTwoFactorEnabled;

  SecuritySettingsData({required this.isTwoFactorEnabled});

  SecuritySettingsData copyWith({bool? isTwoFactorEnabled}) {
    return SecuritySettingsData(
      isTwoFactorEnabled: isTwoFactorEnabled ?? this.isTwoFactorEnabled,
    );
  }
}

class SecuritySettingsViewModel extends ChangeNotifier {
  SecuritySettingsData settingsData = SecuritySettingsData(
    isTwoFactorEnabled: false,
  );

  void saveChanges() {
    debugPrint("action triggered: Viewmodel logic saveChanges");
  }

  void toggleTwoFactor(bool value) {
    settingsData = settingsData.copyWith(isTwoFactorEnabled: value);
    notifyListeners();
    debugPrint(
      "action triggered: Viewmodel logic toggleTwoFactor ${settingsData.isTwoFactorEnabled}",
    );
  }
}
