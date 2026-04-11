import 'package:flutter/material.dart';

class CreateAccountViewModel extends ChangeNotifier {
  final String basicRole;

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

  CreateAccountViewModel({required this.basicRole}) {
    debugPrint('Init CreateAccountViewModel with role $basicRole');
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
