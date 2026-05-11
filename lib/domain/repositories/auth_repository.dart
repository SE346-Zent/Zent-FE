import 'package:zent_fe/domain/entities/user.dart';

abstract class AuthRepository {
  Future<User> login({required String email, required String password});
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
  Future<void> restoreSession();

  Future<bool> isFirstTime();

  Future<void> setFirstTimeDone();

  Future<void> forgotPassword(String email);

  Future<bool> resetPassword({
    required String email,
    required String token,
    required String newPassword,
  });
}
