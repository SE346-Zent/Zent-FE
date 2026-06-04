import 'package:zent_fe/presentation/common/core/safe_change_notifier.dart';
import 'package:flutter/material.dart';
import 'package:zent_fe/domain/usecases/auth/create_user_usecase.dart';
import 'package:zent_fe/data/models/create_user_request.dart';

class CreateAccountViewModel extends ChangeNotifier with SafeChangeNotifier {
  final CreateUserUseCase createUserUseCase;

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

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  CreateAccountViewModel({required this.createUserUseCase}) {
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

  Future<bool> submitCreateAccount() async {
    final fullName = fullNameController.text.trim();
    final email = emailController.text.trim();
    final phone = phoneController.text.trim();

    if (fullName.isEmpty || email.isEmpty) {
      _errorMessage = 'Full Name and Email are required';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final isTech = basicRole == 'Technicians';
      final roleId = isTech ? 4 : 2;

      final request = CreateUserRequest(
        email: email,
        fullName: fullName,
        roleId: roleId,
        phone: phone.isNotEmpty ? phone : null,
        generatePassword: true,
      );

      await createUserUseCase(request);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString().replaceAll('Exception:', '').trim();
      notifyListeners();
      return false;
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
