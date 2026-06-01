import 'package:zent_fe/presentation/common/core/safe_change_notifier.dart';
import 'package:flutter/foundation.dart';

class ChooseRoleViewModel extends ChangeNotifier with SafeChangeNotifier {
  String _selectedRole = 'Technicians';

  String get selectedRole => _selectedRole;

  void selectRole(String role) {
    if (_selectedRole != role) {
      _selectedRole = role;
      notifyListeners();
    }
  }
}
