import 'package:flutter/material.dart';
import 'package:zent_fe/domain/entities/login_history_entry.dart';
import 'package:zent_fe/domain/exceptions/business_exception.dart';
import 'package:zent_fe/domain/usecases/auth/get_login_history_usecase.dart';
import 'package:zent_fe/domain/usecases/auth/change_password_usecase.dart';
import 'package:zent_fe/domain/usecases/auth/recovery_and_metrics_usecases.dart';
import '../../../common/core/safe_change_notifier.dart';

enum RecoveryEmailStep { idle, awaitingOtp, done }

class TechSecurityViewModel extends ChangeNotifier with SafeChangeNotifier {
  final GetLoginHistoryUseCase getLoginHistoryUseCase;
  final SetRecoveryEmailUseCase setRecoveryEmailUseCase;
  final VerifyRecoveryEmailUseCase verifyRecoveryEmailUseCase;
  final ChangePasswordUseCase changePasswordUseCase;

  List<LoginHistoryEntry> _loginHistory = [];
  List<LoginHistoryEntry> get loginHistory => _loginHistory;

  bool _isLoadingHistory = false;
  bool get isLoadingHistory => _isLoadingHistory;

  bool _isRecoveryLoading = false;
  bool get isRecoveryLoading => _isRecoveryLoading;

  RecoveryEmailStep _recoveryStep = RecoveryEmailStep.idle;
  RecoveryEmailStep get recoveryStep => _recoveryStep;

  String? _recoveryError;
  String? get recoveryError => _recoveryError;

  bool _isChangePasswordLoading = false;
  bool get isChangePasswordLoading => _isChangePasswordLoading;

  String? _changePasswordError;
  String? get changePasswordError => _changePasswordError;

  bool _changePasswordSuccess = false;
  bool get changePasswordSuccess => _changePasswordSuccess;

  TechSecurityViewModel({
    required this.getLoginHistoryUseCase,
    required this.setRecoveryEmailUseCase,
    required this.verifyRecoveryEmailUseCase,
    required this.changePasswordUseCase,
  }) {
    fetchLoginHistory();
  }

  Future<void> fetchLoginHistory() async {
    _isLoadingHistory = true;
    notifyListeners();
    try {
      _loginHistory = await getLoginHistoryUseCase.execute();
    } catch (e) {
      debugPrint('Error fetching login history: $e');
    } finally {
      _isLoadingHistory = false;
      notifyListeners();
    }
  }

  /// Step 1 – send OTP to the recovery email
  Future<void> requestRecoveryEmailOtp({
    required BuildContext context,
    required String recoveryEmail,
    required String password,
  }) async {
    _recoveryError = null;
    _isRecoveryLoading = true;
    notifyListeners();
    try {
      await setRecoveryEmailUseCase.execute(
        recoveryEmail: recoveryEmail,
        password: password,
      );
      _recoveryStep = RecoveryEmailStep.awaitingOtp;
    } on BusinessException catch (e) {
      _recoveryError = e.message;
    } catch (e) {
      _recoveryError = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isRecoveryLoading = false;
      notifyListeners();
    }
  }

  /// Step 2 – verify the OTP
  Future<void> verifyRecoveryOtp({
    required BuildContext context,
    required String otpCode,
  }) async {
    _recoveryError = null;
    _isRecoveryLoading = true;
    notifyListeners();
    try {
      await verifyRecoveryEmailUseCase.execute(otpCode: otpCode);
      _recoveryStep = RecoveryEmailStep.done;
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Recovery email verified successfully!'),
          ),
        );
      }
    } on BusinessException catch (e) {
      _recoveryError = e.message;
    } catch (e) {
      _recoveryError = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isRecoveryLoading = false;
      notifyListeners();
    }
  }

  void resetRecoveryFlow() {
    _recoveryStep = RecoveryEmailStep.idle;
    _recoveryError = null;
    notifyListeners();
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    _changePasswordError = null;
    _changePasswordSuccess = false;
    _isChangePasswordLoading = true;
    notifyListeners();
    try {
      await changePasswordUseCase.execute(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      _changePasswordSuccess = true;
    } on BusinessException catch (e) {
      _changePasswordError = e.message;
    } catch (e) {
      _changePasswordError = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isChangePasswordLoading = false;
      notifyListeners();
    }
  }

  void resetChangePasswordState() {
    _changePasswordError = null;
    _changePasswordSuccess = false;
    notifyListeners();
  }

  void saveChanges(BuildContext context) {
    debugPrint('TechSecurityViewModel: saveChanges called');
  }
}
