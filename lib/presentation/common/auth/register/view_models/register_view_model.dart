import 'package:zent_fe/domain/exceptions/business_exception.dart';
import 'package:zent_fe/presentation/common/core/safe_change_notifier.dart';
import 'package:flutter/material.dart';
import 'package:zent_fe/domain/usecases/auth/register_usecase.dart';

class RegisterViewModel extends ChangeNotifier with SafeChangeNotifier {
  final RegisterUseCase registerUseCase;

  RegisterViewModel({required this.registerUseCase});

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

      await registerUseCase.signup(
        fullName: fullName,
        email: email,
        phoneNumber: phone,
        password: password,
      );

      return true;
    } on BusinessException catch (e) {
      _errorMessage = e.message;
      return false;
    } catch (e) {
      // Ignore format errors and server errors for UI
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
