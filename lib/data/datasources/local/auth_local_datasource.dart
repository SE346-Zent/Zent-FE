import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthLocalDataSource {
  Future<void> saveCredentials(String accessToken, String refreshToken);
  Future<String?> getAccessToken();
  Future<String?> getRefreshToken();
  Future<void> clearCredentials();

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
  Future<void> saveCredentials(String accessToken, String refreshToken) async {
    await secureStorage.write(key: 'ACCESS_TOKEN', value: accessToken);
    await secureStorage.write(key: 'REFRESH_TOKEN', value: refreshToken);
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
  Future<void> clearCredentials() async {
    await secureStorage.delete(key: 'ACCESS_TOKEN');
    await secureStorage.delete(key: 'REFRESH_TOKEN');
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
