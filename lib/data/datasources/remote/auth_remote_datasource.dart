import 'dart:convert';
import 'package:http/http.dart' as http;
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
    required String role,
  });
  Future<AuthResponseModel> verifyOtp(String email, String otp);
  Future<void> resendOtp(String email);
  Future<void> logout(String email, String refreshToken);
  Future<AuthResponseModel> refreshToken(String email, String refreshToken);
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final http.Client client;
  static final String _baseURL = dotenv.get(
    "BASE_URL",
    fallback: "http://localhost:3000/api",
  );
  static const Duration _timeOut = Duration(seconds: 20);

  AuthRemoteDatasourceImpl(this.client);

  @override
  Future<AuthResponseModel> login(String email, String password) async {
    final url = Uri.parse('$_baseURL/auth/signin');
    try {
      final response = await client
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'email': email, 'password': password}),
          )
          .timeout(_timeOut);

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
      throw Exception('Login error: $e');
    }
  }

  @override
  Future<void> signup({
    required String fullName,
    required String phone,
    required String email,
    required String password,
    required String role,
  }) async {
    final url = Uri.parse('$_baseURL/auth/signup/initiate');
    try {
      final mappedRole = adaptRoleFromFEToBE(role);
      final response = await client
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'email': email,
              'phonenumber': phone,
              'fullName': fullName,
              'password': password,
              'userRoles': mappedRole,
            }),
          )
          .timeout(_timeOut);

      final jsonMap = jsonDecode(response.body);

      final apiResponse = ApiResponse<dynamic>.fromJson(
        jsonMap,
        (data) => data,
      );
      if (!apiResponse.isSuccessful) {
        throw Exception(apiResponse.message ?? 'Signup Failed');
      }
    } catch (e) {
      throw Exception('Sign up error: $e');
    }
  }

  @override
  Future<AuthResponseModel> verifyOtp(String email, String otp) async {
    final url = Uri.parse('$_baseURL/auth/signup/finish');
    try {
      final response = await client
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'otp': otp, 'email': email}),
          )
          .timeout(_timeOut);

      final jsonMap = jsonDecode(response.body);

      final apiResponse = ApiResponse<AuthResponseModel>.fromJson(
        jsonMap,
        (data) => AuthResponseModel.fromJson(data),
      );

      if (apiResponse.isSuccessful && apiResponse.data != null) {
        return apiResponse.data!;
      } else {
        throw Exception(apiResponse.message ?? 'Verify OTP Failed');
      }
    } catch (e) {
      throw Exception('Verify OTP error: $e');
    }
  }

  @override
  Future<void> resendOtp(String email) async {
    final url = Uri.parse('$_baseURL/auth/signup/resend-otp');
    try {
      final response = await client
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'email': email}),
          )
          .timeout(_timeOut);

      final jsonMap = jsonDecode(response.body);
      final apiResponse = ApiResponse<dynamic>.fromJson(
        jsonMap,
        (data) => data,
      );

      if (!apiResponse.isSuccessful) {
        throw Exception(apiResponse.message ?? 'Resend OTP Failed');
      }
    } catch (e) {
      throw Exception('Resend OTP error: $e');
    }
  }

  @override
  Future<void> logout(String email, String refreshToken) async {
    final url = Uri.parse('$_baseURL/auth/logout');
    try {
      final response = await client
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $refreshToken',
            },
            body: jsonEncode({'email': email}),
          )
          .timeout(_timeOut);

      final jsonMap = jsonDecode(response.body);
      final apiResponse = ApiResponse<dynamic>.fromJson(
        jsonMap,
        (data) => data,
      );

      if (!apiResponse.isSuccessful) {
        throw Exception(apiResponse.message ?? 'Logout Failed');
      }
    } catch (e) {
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
              'Authorization': 'Bearer $refreshToken',
            },
            body: jsonEncode({'email': email}),
          )
          .timeout(_timeOut);

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
      throw Exception('Refresh token error: $e');
    }
  }

  String adaptRoleFromFEToBE(String role) {
    switch (role.toUpperCase()) {
      case 'SUPERADMIN':
        return 'SUPER_ADMIN';
      case 'TECHNICIAN':
        return 'TECHNICIAN';
      case 'CUSTOMER':
        return 'CUSTOMER';
      case 'ADMIN':
      default:
        return 'ADMIN';
    }
  }
}
