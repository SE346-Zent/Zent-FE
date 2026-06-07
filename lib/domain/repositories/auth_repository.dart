import 'package:zent_fe/domain/entities/user.dart';
import 'package:zent_fe/domain/entities/login_history_entry.dart';
import 'package:zent_fe/domain/entities/user_session.dart';
import 'package:zent_fe/data/models/create_user_request.dart';

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

  Future<void> updateProfile({
    required String fullName,
    required String phone,
    required String email,
  });

  Future<void> refreshToken();
  Future<bool> restoreSession();

  Future<bool> isFirstTime();

  Future<void> setFirstTimeDone();

  Future<void> forgotPassword(String email, {bool useRecoveryEmail = false});

  Future<List<User>> getUsers({int page = 1, int pageSize = 50, String? role});

  Future<String> verifyForgotOtp({required String email, required String otp});

  Future<bool> resetPassword({
    required String email,
    required String token,
    required String newPassword,
  });

  Future<List<LoginHistoryEntry>> getLoginHistory();

  Future<void> setRecoveryEmail({
    required String recoveryEmail,
    required String password,
  });

  Future<void> verifyRecoveryEmail({required String otpCode});

  Future<Map<String, dynamic>> getTechnicianMetrics();

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });
  Future<String> uploadAvatar(String filePath);
  Future<void> updateUserStatus(String userId, int statusId);
  Future<void> closeAccount();
  Future<User> getMe();
  Future<User> getUserById(String userId);
  Future<List<UserSession>> getActiveSessions();
  Future<void> revokeSession(String sessionId);
  Future<void> revokeAllOtherSessions();
  Future<void> createUser(CreateUserRequest request);
}
