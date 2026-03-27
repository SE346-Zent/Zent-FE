import 'dart:async';
import 'package:flutter/material.dart';

class VerifyOtpViewModel extends ChangeNotifier {
  final String email;

  VerifyOtpViewModel({required this.email}) {
    startResendTimer();
  }

  String _otp = '';
  bool _isLoading = false;
  String? _errorMessage;

  int _countdownSeconds = 30;
  Timer? _resendTimer;

  String get otp => _otp;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get countdownSeconds => _countdownSeconds;
  bool get canResendOTP => _countdownSeconds == 0;

  void setOtp(String value) {
    _otp = value.trim();
    _errorMessage = null;
    notifyListeners();
  }

  void startResendTimer() {
    _countdownSeconds = 30;
    _resendTimer?.cancel();
    notifyListeners();

    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdownSeconds > 0) {
        _countdownSeconds--;
        notifyListeners();
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> resendOTP() async {
    if (!canResendOTP) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));

    _isLoading = false;
    startResendTimer();
  }

  Future<String?> verifyOTP() async {
    if (_otp.isEmpty) return null;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));

    if (_otp == '0000') {
      _errorMessage = "Invalid OTP";
      _isLoading = false;
      notifyListeners();
      return null;
    }

    _isLoading = false;
    notifyListeners();
    return "MOCK_SECURE_TOKEN_123";
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    super.dispose();
  }
}
