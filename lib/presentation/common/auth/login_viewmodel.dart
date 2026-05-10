import 'package:flutter/material.dart';
import '../../../domain/usecases/auth/login_usecase.dart';
import '../../../domain/usecases/auth/logout_usecase.dart';
import '../../../domain/entities/user.dart';

class LoginViewModel extends ChangeNotifier {
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;

  LoginViewModel({required this.loginUseCase, required this.logoutUseCase});

  bool _isLoading = false;
  String? _errorMessage;
  User? _user;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  User? get user => _user;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _user = await loginUseCase.execute(email, password);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll("Exception: ", "");
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();
    try {
      await logoutUseCase.execute();
      _user = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
