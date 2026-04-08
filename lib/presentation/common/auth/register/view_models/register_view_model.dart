import 'package:flutter/material.dart';

class RegisterViewModel extends ChangeNotifier {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> register() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final fullName = fullNameController.text.trim();
      final email = emailController.text.trim();
      final phone = phoneController.text.trim();
      final password = passwordController.text.trim();

      if (fullName.isEmpty ||
          email.isEmpty ||
          phone.isEmpty ||
          password.isEmpty) {
        _errorMessage = 'All fields are required';
        return false;
      }

      // Currently a mock delay placeholders
      debugPrint(
        "action triggered: register with name=$fullName, email=$email, phone=$phone",
      );

      await Future.delayed(const Duration(seconds: 1));
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
