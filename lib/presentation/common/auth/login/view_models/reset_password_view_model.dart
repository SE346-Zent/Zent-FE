import 'package:flutter/material.dart';

class ResetPasswordViewModel extends ChangeNotifier {
  final String email;
  final String token;

  ResetPasswordViewModel({required this.email, required this.token});

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
  bool get hasUpperCase => RegExp(r'[A-Z]').hasMatch(_newPassword);
  bool get hasNumber => RegExp(r'[0-9]').hasMatch(_newPassword);
  bool get hasSpecialChar => RegExp(r'[!@#\$&*~]').hasMatch(_newPassword);

  int get passwordStrength {
    if (_newPassword.isEmpty) return 0;

    int strength = 0;
    if (hasMinLength) strength++;
    if (hasUpperCase) strength++;
    if (hasNumber) strength++;
    if (hasSpecialChar) strength++;

    if (strength == 0) return 1;
    if (strength == 1) return 2;
    if (strength == 2 || strength == 3) return 3;
    if (strength == 4) return 4;

    return 0;
  }

  Future<bool> submitNewPassword() async {
    if (!doPasswordsMatch) return false;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));

    _isLoading = false;
    notifyListeners();
    return true;
  }
}
