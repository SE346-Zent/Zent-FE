import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/user_model.dart';
import '../../../domain/entities/user.dart';

abstract class AuthLocalDataSource {
  Future<void> saveCredentials(
    String accessToken,
    String refreshToken, {
    String? sessionId,
  });
  Future<String?> getAccessToken();
  Future<String?> getRefreshToken();
  Future<String?> getSessionId();
  Future<void> clearCredentials();

  Future<void> saveUser(User user);
  Future<User?> getUser();

  Future<bool> isFirstTime();
  Future<void> setFirstTimeDone();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage secureStorage;
  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl({
    required this.secureStorage,
    required this.sharedPreferences,
  });

  @override
  Future<void> saveCredentials(
    String accessToken,
    String refreshToken, {
    String? sessionId,
  }) async {
    await secureStorage.write(key: 'ACCESS_TOKEN', value: accessToken);
    await secureStorage.write(key: 'REFRESH_TOKEN', value: refreshToken);
    if (sessionId != null) {
      await secureStorage.write(key: 'session_id', value: sessionId);
    }
  }

  @override
  Future<String?> getAccessToken() async {
    return await secureStorage.read(key: 'ACCESS_TOKEN');
  }

  @override
  Future<String?> getRefreshToken() async {
    return await secureStorage.read(key: 'REFRESH_TOKEN');
  }

  @override
  Future<String?> getSessionId() async {
    return await secureStorage.read(key: 'session_id');
  }

  @override
  Future<void> clearCredentials() async {
    await secureStorage.delete(key: 'ACCESS_TOKEN');
    await secureStorage.delete(key: 'REFRESH_TOKEN');
    await secureStorage.delete(key: 'session_id');
    await sharedPreferences.remove('USER_DATA');
  }

  @override
  Future<void> saveUser(User user) async {
    final userModel = UserModel.fromEntity(user);
    final jsonString = jsonEncode(userModel.toJson());
    await sharedPreferences.setString('USER_DATA', jsonString);
  }

  @override
  Future<User?> getUser() async {
    final jsonString = sharedPreferences.getString('USER_DATA');
    if (jsonString == null) return null;
    try {
      final jsonMap = jsonDecode(jsonString);
      return UserModel.fromJson(jsonMap);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> isFirstTime() async {
    return sharedPreferences.getBool('IS_FIRST_TIME') ?? true;
  }

  @override
  Future<void> setFirstTimeDone() async {
    await sharedPreferences.setBool('IS_FIRST_TIME', false);
  }
}
