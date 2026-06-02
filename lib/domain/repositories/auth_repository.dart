import 'package:zent_fe/domain/entities/user.dart';
import 'package:zent_fe/domain/entities/login_history_entry.dart';

abstract class AuthRepository {
  Future<User> login({
    required String email,
    required String password,
    String? fcmToken,
  });
  Future<User> googleLogin({required String idToken, String? fcmToken});
  Future<User?> getCurrentUser();

  Future<void> signup({
    required String email,
    required String password,
    required String fullName,
    required String phoneNumber,
  });

  Future<void> verifyOtp({required String email, required String otp});

  Future<void> resendOtp(String email);

  Future<void> logout();

  Future<void> refreshToken();
  Future<bool> restoreSession();

  Future<bool> isFirstTime();

  Future<void> setFirstTimeDone();

  Future<void> forgotPassword(String email);

  Future<List<User>> getUsers({int page = 1, int pageSize = 50, String? role});

  Future<String> verifyForgotOtp({required String email, required String otp});

  Future<bool> resetPassword({
    required String email,
    required String token,
    required String newPassword,
  });

  Future<List<LoginHistoryEntry>> getLoginHistory();
}
