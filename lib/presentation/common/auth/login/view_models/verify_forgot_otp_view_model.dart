import 'package:zent_fe/presentation/common/core/safe_change_notifier.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:zent_fe/domain/usecases/auth/forgot_password_usecase.dart';
import 'package:zent_fe/domain/usecases/auth/verify_forgot_otp_usecase.dart';

class VerifyForgotOtpViewModel extends ChangeNotifier with SafeChangeNotifier {
  final VerifyForgotOtpUseCase verifyForgotOtpUseCase;
  final ForgotPasswordUseCase forgotPasswordUseCase;

  String _email = '';
  String _otp = '';
  bool _isLoading = false;
  String? _errorMessage;
  String? _resetToken;

  int _countdownSeconds = 30;
  Timer? _resendTimer;

  bool _useRecoveryEmail = false;

  VerifyForgotOtpViewModel({
    required this.verifyForgotOtpUseCase,
    required this.forgotPasswordUseCase,
  });

  String get email => _email;
  String get otp => _otp;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get resetToken => _resetToken;
  int get countdownSeconds => _countdownSeconds;
  bool get canResendOTP => _countdownSeconds == 0;
  bool get useRecoveryEmail => _useRecoveryEmail;

  void init({required String email, bool useRecoveryEmail = false}) {
    _email = email;
    _useRecoveryEmail = useRecoveryEmail;
    startResendTimer();
  }

  void setOtp(String value) {
    _otp = value.trim();
    _errorMessage = null;
    notifyListeners();
  }

  void startResendTimer() {
    _countdownSeconds = 30;
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdownSeconds > 0) {
        _countdownSeconds--;
        notifyListeners();
      } else {
        timer.cancel();
      }
    });
  }

  Future<bool> submitOtp() async {
    if (_otp.isEmpty || _email.isEmpty) return false;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final token = await verifyForgotOtpUseCase.call(email: _email, otp: _otp);
      _resetToken = token;

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

  Future<void> resendOtp() async {
    if (_email.isEmpty || !canResendOTP) return;

    _errorMessage = null;
    notifyListeners();

    try {
      await forgotPasswordUseCase.call(
        _email,
        useRecoveryEmail: _useRecoveryEmail,
      );
      startResendTimer();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    super.dispose();
  }
}
