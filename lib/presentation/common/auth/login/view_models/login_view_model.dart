import 'package:flutter/material.dart';
import 'package:zent_fe/domain/usecases/auth/login_usecase.dart';
import 'package:zent_fe/domain/entities/user.dart';

class LoginViewModel extends ChangeNotifier {
  final LoginUseCase loginUseCase;

  LoginViewModel(this.loginUseCase);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<User?> login() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      if (email.isEmpty || password.isEmpty) {
        _errorMessage = 'Email and password are required';
        return null;
      }

      final user = await loginUseCase.execute(email, password);
      return user;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
