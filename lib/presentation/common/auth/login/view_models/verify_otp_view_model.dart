import 'dart:async';
import 'package:flutter/material.dart';
import 'package:zent_fe/domain/usecases/auth/verify_otp_usecase.dart';

class VerifyOtpViewModel extends ChangeNotifier {
  final VerifyOtpUseCase verifyOtpUseCase;

  String? _email;
  String _otp = '';
  bool _isLoading = false;
  String? _errorMessage;
  int _countdownSeconds = 30;
  Timer? _resendTimer;

  VerifyOtpViewModel({required this.verifyOtpUseCase});

  String get email => _email ?? '';
  String get otp => _otp;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get countdownSeconds => _countdownSeconds;
  bool get canResendOTP => _countdownSeconds == 0;

  void init({required String email}) {
    _email = email;
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
      await verifyOtpUseCase.call(email: _email!, otp: _otp);

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

  @override
  void dispose() {
    _resendTimer?.cancel();
    super.dispose();
  }
}
