import 'dart:async';
import 'package:flutter/material.dart';
import 'package:zent_fe/domain/usecases/auth/register_usecase.dart';
import 'package:zent_fe/domain/usecases/auth/logout_usecase.dart';

class VerifyOtpViewModel extends ChangeNotifier {
  final RegisterUseCase registerUseCase;
  final LogoutUseCase logoutUseCase;

  String? _email;
  String _otp = '';
  bool _isLoading = false;
  String? _errorMessage;
  int _countdownSeconds = 30;
  Timer? _resendTimer;

  bool _isRegistration = false;

  VerifyOtpViewModel({
    required this.registerUseCase,
    required this.logoutUseCase,
  });

  String get email => _email ?? '';
  String get otp => _otp;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get countdownSeconds => _countdownSeconds;
  bool get canResendOTP => _countdownSeconds == 0;

  bool get isRegistration => _isRegistration;

  void init({required String email, bool isRegistration = false}) {
    _email = email;
    _isRegistration = isRegistration;
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
    if (_otp.isEmpty || _email == null) return false;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await registerUseCase.verifyOtp(email: _email!, otp: _otp);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> resendOtp() async {
    if (_email == null || !canResendOTP) return;

    _errorMessage = null;
    notifyListeners();

    try {
      await registerUseCase.resendOtp(_email!);
      startResendTimer();
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    super.dispose();
  }
}
