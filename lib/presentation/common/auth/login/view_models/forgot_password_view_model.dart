import 'package:zent_fe/presentation/common/core/safe_change_notifier.dart';
import 'package:flutter/material.dart';
import 'package:zent_fe/domain/usecases/auth/forgot_password_usecase.dart';

class ForgotPasswordViewModel extends ChangeNotifier with SafeChangeNotifier {
  final ForgotPasswordUseCase forgotPasswordUseCase;

  ForgotPasswordViewModel({required this.forgotPasswordUseCase});

  String _email = '';
  bool _isLoading = false;
  String? _errorMessage;

  /// true  = send OTP to recovery email
  /// false = send OTP to primary email  (default)
  bool _useRecoveryEmail = false;

  String get email => _email;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get useRecoveryEmail => _useRecoveryEmail;

  bool get isEmailValid {
    if (_email.isEmpty) return false;
    final emailRegex = RegExp(r'^[\w-\.\+]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(_email);
  }

  void setEmail(String value) {
    _email = value.trim();
    _errorMessage = null;
    notifyListeners();
  }

  void setUseRecoveryEmail(bool value) {
    if (_useRecoveryEmail == value) return;
    _useRecoveryEmail = value;
    _errorMessage = null;
    notifyListeners();
  }

  Future<bool> requestOTP() async {
    if (!isEmailValid) return false;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await forgotPasswordUseCase.call(
        _email,
        useRecoveryEmail: _useRecoveryEmail,
      );

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
