import 'package:flutter/foundation.dart';

class ChooseRoleViewModel extends ChangeNotifier {
  String _selectedRole = 'Technicians';

  String get selectedRole => _selectedRole;

  void selectRole(String role) {
    if (_selectedRole != role) {
      _selectedRole = role;
      notifyListeners();
    }
  }
}
