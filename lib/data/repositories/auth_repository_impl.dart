import 'package:flutter/foundation.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:zent_fe/domain/repositories/auth_repository.dart';
import 'package:zent_fe/domain/entities/user.dart';
import 'package:zent_fe/domain/entities/enums/user_roles.dart';
import '../datasources/local/auth_local_datasource.dart';
import '../datasources/remote/auth_remote_datasource.dart';
import '../models/auth_response_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource authRemoteService;
  final AuthLocalDataSource authLocalDataSource;

  AuthRepositoryImpl({
    required this.authRemoteService,
    required this.authLocalDataSource,
  });

  @override
  Future<User> login({required String email, required String password}) async {
    final AuthResponseModel response = await authRemoteService.login(
      email,
      password,
    );

    await authLocalDataSource.saveCredentials(
      response.accessToken,
      response.refreshToken,
    );

    return response.user;
  }

  @override
  Future<User> verifyOtp({required String email, required String otp}) async {
    try {
      final AuthResponseModel response = await authRemoteService.verifyOtp(
        email,
        otp,
      );

      await authLocalDataSource.saveCredentials(
        response.accessToken,
        response.refreshToken,
      );

      return response.user;
    } catch (e, stacktrace) {
      debugPrint("Stacktrace: $stacktrace");
      rethrow;
    }
  }

  @override
  Future<void> resendOtp(String email) async {
    await authRemoteService.resendOtp(email);
  }

  @override
  Future<void> signup({
    required String fullName,
    required String phoneNumber,
    required String email,
    required UserRoles role,
    required String password,
  }) async {
    final roleString = role.name.toUpperCase();

    await authRemoteService.signup(
      fullName: fullName,
      phone: phoneNumber,
      email: email,
      password: password,
      role: roleString,
    );
  }

  @override
  Future<void> logout() async {
    final accessToken = await authLocalDataSource.getAccessToken();
    final refreshToken = await authLocalDataSource.getRefreshToken();
    if (accessToken != null && refreshToken != null) {
      final decodedToken = JwtDecoder.decode(accessToken);
      final email = decodedToken['email'];
      await authRemoteService.logout(email, refreshToken);
    }

    await authLocalDataSource.clearCredentials();
  }

  @override
  Future<void> refreshToken() async {
    final accessToken = await authLocalDataSource.getAccessToken();
    final refreshToken = await authLocalDataSource.getRefreshToken();
    if (accessToken != null && refreshToken != null) {
      final decodedToken = JwtDecoder.decode(accessToken);
      final email = decodedToken['email'];
      final AuthResponseModel response = await authRemoteService.refreshToken(
        email,
        refreshToken,
      );

      await authLocalDataSource.saveCredentials(
        response.accessToken,
        response.refreshToken,
      );
    } else {
      throw Exception("No tokens found to refresh");
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
