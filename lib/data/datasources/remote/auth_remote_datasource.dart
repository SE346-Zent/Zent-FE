import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../models/auth_response_model.dart' show AuthResponseModel;
import '../../models/api_response.dart' show ApiResponse;

abstract class AuthRemoteDatasource {
  Future<AuthResponseModel> login(String email, String password);
  Future<void> signup({
    required String fullName,
    required String phone,
    required String email,
    required String password,
  });
  Future<void> verifyOtp(String email, String otp);
  Future<void> resendOtp(String email);
  Future<void> logout(String accessToken, String refreshToken);
  Future<AuthResponseModel> refreshToken(String email, String refreshToken);
  Future<void> forgotPassword(String email);
  Future<String> verifyForgotOtp(String email, String otp);
  Future<bool> resetPassword({
    required String email,
    required String token,
    required String newPassword,
  });
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final http.Client client;
  static final String _baseURL = dotenv.get("BASE_URL");
  static final Duration _timeOut = Duration(
    seconds: int.tryParse(dotenv.get("TIMEOUT_SECONDS", fallback: "20")) ?? 20,
  );

  AuthRemoteDatasourceImpl(this.client);

  @override
  Future<AuthResponseModel> login(String email, String password) async {
    final url = Uri.parse('$_baseURL/auth/login');
    try {
      final response = await client
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({'email': email, 'password': password}),
          )
          .timeout(_timeOut);

      if (response.statusCode != 200) {
        _handleErrorResponse(response);
      }

      final jsonMap = jsonDecode(response.body);
      final apiResponse = ApiResponse<AuthResponseModel>.fromJson(
        jsonMap,
        (data) => AuthResponseModel.fromJson(data),
      );

      if (apiResponse.isSuccessful && apiResponse.data != null) {
        return apiResponse.data!;
      } else {
        throw Exception(apiResponse.message ?? 'Login Failed');
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Login error: $e');
    }
  }

  @override
  Future<void> signup({
    required String fullName,
    required String phone,
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$_baseURL/auth/register');
    try {
      final response = await client
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({
              'email': email,
              'fullName': fullName,
              'password': password,
              'phoneNumber': phone,
            }),
          )
          .timeout(_timeOut);

      if (response.statusCode != 200 && response.statusCode != 201) {
        _handleErrorResponse(response);
      }

      final jsonMap = jsonDecode(response.body);
      final apiResponse = ApiResponse<dynamic>.fromJson(
        jsonMap,
        (data) => data,
      );
      if (!apiResponse.isSuccessful) {
        throw Exception(apiResponse.message ?? 'Signup Failed');
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Sign up error: $e');
    }
  }

  @override
  Future<void> verifyOtp(String email, String otp) async {
    final url = Uri.parse('$_baseURL/auth/verify-otp');
    try {
      final response = await client
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({'otpCode': otp, 'email': email}),
          )
          .timeout(_timeOut);

      if (response.statusCode != 200) {
        _handleErrorResponse(response);
      }

      final jsonMap = jsonDecode(response.body);
      final apiResponse = ApiResponse<dynamic>.fromJson(
        jsonMap,
        (data) => data,
      );

      if (!apiResponse.isSuccessful) {
        throw Exception(apiResponse.message ?? 'Verify OTP Failed');
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Verify OTP error: $e');
    }
  }

  @override
  Future<void> resendOtp(String email) async {
    final url = Uri.parse('$_baseURL/auth/resend-otp');
    try {
      final response = await client
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({'email': email}),
          )
          .timeout(_timeOut);

      if (response.statusCode != 200) {
        _handleErrorResponse(response);
      }

      final jsonMap = jsonDecode(response.body);
      final apiResponse = ApiResponse<dynamic>.fromJson(
        jsonMap,
        (data) => data,
      );

      if (!apiResponse.isSuccessful) {
        throw Exception(apiResponse.message ?? 'Resend OTP Failed');
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Resend OTP error: $e');
    }
  }

  @override
  Future<void> logout(String accessToken, String refreshToken) async {
    final url = Uri.parse('$_baseURL/auth/logout');
    try {
      final response = await client
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $accessToken',
            },
            body: jsonEncode({'refresh_token': refreshToken}),
          )
          .timeout(_timeOut);

      if (response.statusCode != 200) {
        _handleErrorResponse(response);
      }

      final jsonMap = jsonDecode(response.body);
      final apiResponse = ApiResponse<dynamic>.fromJson(
        jsonMap,
        (data) => data,
      );

      if (!apiResponse.isSuccessful) {
        throw Exception(apiResponse.message ?? 'Logout Failed');
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Logout error: $e');
    }
  }

  @override
  Future<AuthResponseModel> refreshToken(
    String email,
    String refreshToken,
  ) async {
    final url = Uri.parse('$_baseURL/auth/refresh-token');
    try {
      final response = await client
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $refreshToken',
            },
            body: jsonEncode({'refresh_token': refreshToken}),
          )
          .timeout(_timeOut);

      if (response.statusCode != 200) {
        _handleErrorResponse(response);
      }

      final jsonMap = jsonDecode(response.body);
      final apiResponse = ApiResponse<AuthResponseModel>.fromJson(
        jsonMap,
        (data) => AuthResponseModel.fromJson(data),
      );

      if (apiResponse.isSuccessful && apiResponse.data != null) {
        return apiResponse.data!;
      } else {
        throw Exception(apiResponse.message ?? 'Refresh token Failed');
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Refresh token error: $e');
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    final url = Uri.parse('$_baseURL/auth/forgot-password');
    try {
      final response = await client
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({'email': email}),
          )
          .timeout(_timeOut);

      if (response.statusCode != 200) {
        _handleErrorResponse(response);
      }

      final jsonMap = jsonDecode(response.body);
      final apiResponse = ApiResponse<dynamic>.fromJson(
        jsonMap,
        (data) => data,
      );

      if (!apiResponse.isSuccessful) {
        throw Exception(apiResponse.message ?? 'Forgot Password Failed');
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Forgot password error: $e');
    }
  }

  @override
  Future<String> verifyForgotOtp(String email, String otp) async {
    final url = Uri.parse('$_baseURL/auth/verify-forgot-password-otp');
    try {
      final response = await client
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'email': email, 'otp_code': otp}),
          )
          .timeout(_timeOut);

      if (response.statusCode != 200) {
        final errorMap = jsonDecode(response.body);
        throw Exception(errorMap['message'] ?? 'Verify OTP Failed');
      }

      final jsonMap = jsonDecode(response.body);
      final apiResponse = ApiResponse<dynamic>.fromJson(
        jsonMap,
        (data) => data,
      );
      final data = apiResponse.data;

      if (data is String) return data;
      if (data is Map<String, dynamic> && data['resetToken'] != null) {
        return data['resetToken'].toString();
      }

      throw Exception('Reset token not found in server response');
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Verify forgot OTP error: $e');
    }
  }

  @override
  Future<bool> resetPassword({
    required String email,
    required String token,
    required String newPassword,
  }) async {
    final url = Uri.parse('$_baseURL/auth/reset-password');
    try {
      final response = await client
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({
              'reset_token': token,
              'new_password': newPassword,
            }),
          )
          .timeout(_timeOut);

      if (response.statusCode != 200) {
        _handleErrorResponse(response);
      }

      return true;
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Reset password error: $e');
    }
  }

  void _handleErrorResponse(http.Response response) {
    final statusCode = response.statusCode;
    final body = response.body;

    // Log lỗi chi tiết ra Console để lập trình viên theo dõi
    debugPrint('--- API Error $statusCode ---');
    debugPrint('Body: $body');
    debugPrint('-----------------------------');

    if (body.isEmpty) {
      throw Exception('Server Error ($statusCode)');
    }

    final contentType = response.headers['content-type'] ?? '';
    if (contentType.contains('application/json')) {
      try {
        final errorMap = jsonDecode(body);
        throw Exception(
          errorMap['message'] ?? 'Something went wrong ($statusCode)',
        );
      } catch (_) {
        // Nếu không parse được JSON, trả về thông báo chung chung
        throw Exception('Server response error ($statusCode)');
      }
    } else {
      // Nếu là HTML hoặc text khác, không hiện lên UI mà chỉ báo lỗi chung
      if (statusCode == 401) {
        throw Exception('Invalid email or password');
      }
      throw Exception('Server error ($statusCode)');
    }
  }
}
