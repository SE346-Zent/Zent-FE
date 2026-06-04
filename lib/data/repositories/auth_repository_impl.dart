import 'package:flutter/foundation.dart';
import '../../domain/entities/user.dart';
import '../../domain/entities/login_history_entry.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/local/auth_local_datasource.dart';
import '../datasources/remote/auth_remote_datasource.dart';
import '../models/user_model.dart';
import '../models/login_history_entry_model.dart';
import 'package:zent_fe/di/injection_container.dart';
import 'package:zent_fe/presentation/common/auth/auth_view_model.dart';
import 'package:zent_fe/domain/exceptions/business_exception.dart';
import 'package:zent_fe/presentation/common/core/ui/avatar_utils.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource authRemoteService;
  final AuthLocalDataSource authLocalDataSource;

  AuthRepositoryImpl({
    required this.authRemoteService,
    required this.authLocalDataSource,
  });

  @override
  Future<User> login({
    required String email,
    required String password,
    String? fcmToken,
  }) async {
    final response = await authRemoteService.login(
      email,
      password,
      fcmToken: fcmToken,
    );

    // 1. Save to Secure Storage (Persistence)
    await authLocalDataSource.saveCredentials(
      response.accessToken,
      response.refreshToken,
    );

    // 2. Fetch fresh user info to get the actual uploaded avatar url, etc.
    User latestUser;
    try {
      latestUser = await getMe();
    } catch (e) {
      debugPrint("Failed to fetch fresh user profile on login: $e");
      latestUser = response.user;
    }

    // 3. Save User Info
    await authLocalDataSource.saveUser(latestUser);

    return latestUser;
  }

  @override
  Future<User> googleLogin({required String idToken, String? fcmToken}) async {
    final response = await authRemoteService.googleLogin(
      idToken,
      fcmToken: fcmToken,
    );

    // 1. Save to Secure Storage (Persistence)
    await authLocalDataSource.saveCredentials(
      response.accessToken,
      response.refreshToken,
    );

    // 2. Fetch fresh user info
    User latestUser;
    try {
      latestUser = await getMe();
    } catch (e) {
      debugPrint("Failed to fetch fresh user profile on googleLogin: $e");
      latestUser = response.user;
    }

    // 3. Save User Info
    await authLocalDataSource.saveUser(latestUser);

    return latestUser;
  }

  @override
  Future<User?> getCurrentUser() async {
    return await authLocalDataSource.getUser();
  }

  @override
  Future<void> verifyOtp({required String email, required String otp}) async {
    await authRemoteService.verifyOtp(email, otp);
  }

  @override
  Future<void> resendOtp(String email) async {
    await authRemoteService.resendOtp(email);
  }

  @override
  Future<void> signup({
    required String email,
    required String password,
    required String fullName,
    required String phoneNumber,
  }) async {
    await authRemoteService.signup(
      fullName: fullName,
      phone: phoneNumber,
      email: email,
      password: password,
    );
  }

  @override
  Future<void> logout() async {
    try {
      final accessToken = await authLocalDataSource.getAccessToken();
      final refreshToken = await authLocalDataSource.getRefreshToken();
      if (accessToken != null && refreshToken != null) {
        await authRemoteService.logout(accessToken, refreshToken);
      }
    } catch (e) {
      debugPrint("Remote logout failed: $e");
    } finally {
      await authLocalDataSource.clearCredentials();
    }
  }

  @override
  Future<void> updateProfile({
    required String fullName,
    required String phone,
    required String email,
  }) async {
    final accessToken = await authLocalDataSource.getAccessToken();
    if (accessToken == null) {
      throw BusinessException('User is not authenticated');
    }

    await authRemoteService.updateProfile(
      accessToken: accessToken,
      fullName: fullName,
      phone: phone,
      email: email,
    );

    // Update the locally cached user object
    final currentUser = await authLocalDataSource.getUser();
    if (currentUser != null) {
      final updatedUser = UserModel(
        id: currentUser.id,
        email: email,
        name: fullName,
        phoneNumber: phone,
        role: currentUser.role,
        province: currentUser.province,
      );
      await authLocalDataSource.saveUser(updatedUser);
    }
  }

  @override
  Future<void> refreshToken() async {
    final email = (await authLocalDataSource.getUser())?.email ?? '';
    final refreshToken = await authLocalDataSource.getRefreshToken() ?? '';
    if (email.isNotEmpty && refreshToken.isNotEmpty) {
      final response = await authRemoteService.refreshToken(
        email,
        refreshToken,
      );
      await authLocalDataSource.saveCredentials(
        response.accessToken,
        response.refreshToken,
      );
    }
  }

  @override
  Future<bool> restoreSession() async {
    try {
      final user = await authLocalDataSource.getUser();
      final refreshTokenStr = await authLocalDataSource.getRefreshToken();

      if (user != null && refreshTokenStr != null) {
        try {
          // Luôn thử refresh token để lấy access token mới khi khởi động
          final response = await authRemoteService.refreshToken(
            user.email,
            refreshTokenStr,
          );

          await authLocalDataSource.saveCredentials(
            response.accessToken,
            response.refreshToken,
          );

          User latestUser;
          try {
            latestUser = await getMe();
          } catch (e) {
            debugPrint(
              "Failed to fetch fresh user profile on restoreSession: $e",
            );
            latestUser = response.user;
          }

          await authLocalDataSource.saveUser(latestUser);

          try {
            sl<AuthViewModel>().setLoggedInUser(latestUser);
          } catch (e) {
            debugPrint("Could not set user in AuthViewModel: $e");
          }
        } catch (refreshError) {
          debugPrint(
            "Restore session: Refresh token attempt failed: $refreshError",
          );
          final errStr = refreshError.toString().toLowerCase();

          // Only force a logout if it is a definitive authentication failure (e.g. invalid credentials, 400, 401).
          // If it is a connection/transient error, keep the current session intact so they remain logged in offline.
          if (errStr.contains('unauthorized') ||
              errStr.contains('invalid') ||
              errStr.contains('401') ||
              errStr.contains('400')) {
            await logout();
            return false;
          }

          // Otherwise, set the cached user in AuthViewModel so they can continue offline
          try {
            sl<AuthViewModel>().setLoggedInUser(user);
          } catch (e) {
            debugPrint("Could not set cached user in AuthViewModel: $e");
          }
        }

        return true;
      }
      return false;
    } catch (e) {
      debugPrint("Restore session failed: $e");
      await logout();
      return false;
    }
  }

  @override
  Future<bool> isFirstTime() async {
    return await authLocalDataSource.isFirstTime();
  }

  @override
  Future<void> setFirstTimeDone() async {
    await authLocalDataSource.setFirstTimeDone();
  }

  @override
  Future<void> forgotPassword(
    String email, {
    bool useRecoveryEmail = false,
  }) async {
    await authRemoteService.forgotPassword(
      email,
      useRecoveryEmail: useRecoveryEmail,
    );
  }

  @override
  Future<String> verifyForgotOtp({
    required String email,
    required String otp,
  }) async {
    try {
      return await authRemoteService.verifyForgotOtp(email, otp);
    } catch (e, stacktrace) {
      debugPrint("Stacktrace: $stacktrace");
      rethrow;
    }
  }

  @override
  @override
  Future<List<User>> getUsers({
    int page = 1,
    int pageSize = 50,
    String? role,
  }) async {
    final usersJson = await authRemoteService.getUsers(
      page: page,
      pageSize: pageSize,
      role: role,
    );
    return usersJson.map((json) => UserModel.fromJson(json)).toList();
  }

  @override
  Future<bool> resetPassword({
    required String email,
    required String token,
    required String newPassword,
  }) async {
    return await authRemoteService.resetPassword(
      email: email,
      token: token,
      newPassword: newPassword,
    );
  }

  @override
  Future<List<LoginHistoryEntry>> getLoginHistory() async {
    final accessToken = await authLocalDataSource.getAccessToken() ?? '';
    if (accessToken.isEmpty) {
      throw Exception('Unauthenticated: Access token is missing');
    }
    final historyJson = await authRemoteService.getLoginHistory(accessToken);
    return historyJson
        .map((json) => LoginHistoryEntryModel.fromJson(json))
        .toList();
  }

  @override
  Future<void> setRecoveryEmail({
    required String recoveryEmail,
    required String password,
  }) async {
    final accessToken = await authLocalDataSource.getAccessToken();
    if (accessToken == null) {
      throw BusinessException('User is not authenticated');
    }
    await authRemoteService.setRecoveryEmail(
      accessToken: accessToken,
      recoveryEmail: recoveryEmail,
      password: password,
    );
  }

  @override
  Future<void> verifyRecoveryEmail({required String otpCode}) async {
    final accessToken = await authLocalDataSource.getAccessToken();
    if (accessToken == null) {
      throw BusinessException('User is not authenticated');
    }
    await authRemoteService.verifyRecoveryEmail(
      accessToken: accessToken,
      otpCode: otpCode,
    );
  }

  @override
  Future<Map<String, dynamic>> getTechnicianMetrics() async {
    final accessToken = await authLocalDataSource.getAccessToken();
    if (accessToken == null) {
      throw BusinessException('User is not authenticated');
    }
    return await authRemoteService.getTechnicianMetrics(accessToken);
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final accessToken = await authLocalDataSource.getAccessToken();
    if (accessToken == null) {
      throw BusinessException('User is not authenticated');
    }
    await authRemoteService.changePassword(
      accessToken: accessToken,
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
  }

  @override
  Future<String> uploadAvatar(String filePath) async {
    final accessToken = await authLocalDataSource.getAccessToken();
    if (accessToken == null) {
      throw BusinessException('User is not authenticated');
    }

    final avatarName = await authRemoteService.uploadAvatar(
      accessToken: accessToken,
      filePath: filePath,
    );

    final fullUrl = AvatarUtils.getAvatarUrl(avatarName);

    final currentUser = await authLocalDataSource.getUser();
    if (currentUser != null) {
      final updatedUser = UserModel(
        id: currentUser.id,
        email: currentUser.email,
        name: currentUser.name,
        phoneNumber: currentUser.phoneNumber,
        role: currentUser.role,
        province: currentUser.province,
        avatarUrl: fullUrl,
      );
      await authLocalDataSource.saveUser(updatedUser);
      sl<AuthViewModel>().setLoggedInUser(updatedUser);
    }

    return avatarName;
  }

  @override
  Future<void> updateUserStatus(String userId, int statusId) async {
    final accessToken = await authLocalDataSource.getAccessToken();
    if (accessToken == null) {
      throw BusinessException('User is not authenticated');
    }
    await authRemoteService.updateUserStatus(
      accessToken: accessToken,
      userId: userId,
      statusId: statusId,
    );
  }

  @override
  Future<void> closeAccount() async {
    final accessToken = await authLocalDataSource.getAccessToken();
    if (accessToken == null) {
      throw BusinessException('User is not authenticated');
    }
    await authRemoteService.closeAccount(accessToken: accessToken);
    await logout();
    sl<AuthViewModel>().clearUser();
  }

  @override
  Future<User> getMe() async {
    final accessToken = await authLocalDataSource.getAccessToken();
    if (accessToken == null) {
      throw BusinessException('User is not authenticated');
    }
    final userMap = await authRemoteService.getMe(accessToken: accessToken);
    return UserModel.fromJson(userMap);
  }

  @override
  Future<User> getUserById(String userId) async {
    final accessToken = await authLocalDataSource.getAccessToken();
    if (accessToken == null) {
      throw BusinessException('User is not authenticated');
    }
    final userMap = await authRemoteService.getUserById(
      accessToken: accessToken,
      userId: userId,
    );
    return UserModel.fromJson(userMap);
  }
}
