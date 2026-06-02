import 'package:zent_fe/presentation/common/core/safe_change_notifier.dart';
import 'package:flutter/material.dart';
import 'package:zent_fe/domain/usecases/auth/reset_password_usecase.dart';

class ResetPasswordViewModel extends ChangeNotifier with SafeChangeNotifier {
  final ResetPasswordUseCase resetPasswordUseCase;

  ResetPasswordViewModel({required this.resetPasswordUseCase});

  String? _email;
  String? _token;

  void init({required String email, required String token}) {
    _email = email;
    _token = token;
  }

  String _newPassword = '';
  String _confirmPassword = '';
  bool _isLoading = false;
  String? _errorMessage;

  String get newPassword => _newPassword;
  String get confirmPassword => _confirmPassword;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void setNewPassword(String value) {
    _newPassword = value;
    notifyListeners();
  }

  void setConfirmPassword(String value) {
    _confirmPassword = value;
    notifyListeners();
  }

  bool get doPasswordsMatch =>
      _newPassword.isNotEmpty && _newPassword == _confirmPassword;

  // Technical Notes
  bool get hasMinLength => _newPassword.length >= 8;
  bool get hasNumber => RegExp(r'[0-9]').hasMatch(_newPassword);
  bool get hasSpecialChar => RegExp(r'[!@#\$&*~]').hasMatch(_newPassword);

  bool get isPasswordValid =>
      hasMinLength && hasNumber && hasSpecialChar && doPasswordsMatch;

  int get passwordStrength {
    if (_newPassword.isEmpty) return 0;

    int strength = 0;
    if (hasMinLength) strength++;
    if (hasNumber) strength++;
    if (hasSpecialChar) strength++;

    if (strength == 0) return 1;
    if (strength == 1) return 2;
    if (strength == 2) return 3;
    if (strength == 3) return 4;

    return 0;
  }

  Future<bool> submitNewPassword() async {
    if (!isPasswordValid || _email == null || _token == null) return false;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final success = await resetPasswordUseCase.call(
        email: _email!,
        token: _token!,
        newPassword: _newPassword,
      );

      _isLoading = false;
      notifyListeners();
      return success;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
