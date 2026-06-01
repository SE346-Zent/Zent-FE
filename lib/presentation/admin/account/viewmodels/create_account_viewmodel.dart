import 'package:zent_fe/presentation/common/core/safe_change_notifier.dart';
import 'package:flutter/material.dart';

class CreateAccountViewModel extends ChangeNotifier with SafeChangeNotifier {
  String basicRole = '';

  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  final List<String> technicalRoles = [
    'Apprentice Electrician',
    'Journeyman Electrician',
    'Master Electrician',
    'System Integrator',
  ];

  String? _selectedSpecificRole;
  String? get selectedSpecificRole => _selectedSpecificRole;

  CreateAccountViewModel() {
    debugPrint('Init CreateAccountViewModel');
  }

  void initRole(String role) {
    basicRole = role;
    debugPrint('Role initialized to: $basicRole');
  }

  void setSpecificRole(String? role) {
    if (_selectedSpecificRole != role) {
      _selectedSpecificRole = role;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }
}
