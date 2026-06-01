import 'package:flutter/material.dart';
import 'package:zent_fe/domain/entities/login_history_entry.dart';
import 'package:zent_fe/domain/usecases/auth/get_login_history_usecase.dart';
import '../../../common/core/safe_change_notifier.dart';

class SecuritySettingsData {
  final bool isTwoFactorEnabled;

  SecuritySettingsData({required this.isTwoFactorEnabled});

  SecuritySettingsData copyWith({bool? isTwoFactorEnabled}) {
    return SecuritySettingsData(
      isTwoFactorEnabled: isTwoFactorEnabled ?? this.isTwoFactorEnabled,
    );
  }
}

class SecuritySettingsViewModel extends ChangeNotifier with SafeChangeNotifier {
  final GetLoginHistoryUseCase getLoginHistoryUseCase;

  SecuritySettingsData settingsData = SecuritySettingsData(
    isTwoFactorEnabled: false,
  );

  List<LoginHistoryEntry> _loginHistory = [];
  List<LoginHistoryEntry> get loginHistory => _loginHistory;

  bool _isLoadingHistory = false;
  bool get isLoadingHistory => _isLoadingHistory;

  SecuritySettingsViewModel({required this.getLoginHistoryUseCase}) {
    fetchLoginHistory();
  }

  Future<void> fetchLoginHistory() async {
    _isLoadingHistory = true;
    notifyListeners();
    try {
      _loginHistory = await getLoginHistoryUseCase.execute();
    } catch (e) {
      debugPrint('Error fetching login history: $e');
    } finally {
      _isLoadingHistory = false;
      notifyListeners();
    }
  }

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
