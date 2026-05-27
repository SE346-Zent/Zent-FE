import 'package:flutter/foundation.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/local/auth_local_datasource.dart';
import '../datasources/remote/auth_remote_datasource.dart';
import 'package:zent_fe/di/injection_container.dart';
import 'package:zent_fe/presentation/common/auth/auth_view_model.dart';

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

    // 2. Save User Info
    await authLocalDataSource.saveUser(response.user);

    return response.user;
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

    // 2. Save User Info
    await authLocalDataSource.saveUser(response.user);

    return response.user;
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
        // Luôn thử refresh token để lấy access token mới khi khởi động
        final response = await authRemoteService.refreshToken(
          user.email,
          refreshTokenStr,
        );

        await authLocalDataSource.saveCredentials(
          response.accessToken,
          response.refreshToken,
        );
        await authLocalDataSource.saveUser(response.user);

        try {
          sl<AuthViewModel>().setLoggedInUser(response.user);
        } catch (e) {
          debugPrint("Could not set user in AuthViewModel: $e");
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
  Future<void> forgotPassword(String email) async {
    await authRemoteService.forgotPassword(email);
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
}
