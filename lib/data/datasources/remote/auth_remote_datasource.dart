import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:geolocator/geolocator.dart';

import '../../models/auth_response_model.dart' show AuthResponseModel;
import '../../models/api_response.dart' show ApiResponse;
import '../local/auth_local_datasource.dart';
import '../../../di/injection_container.dart';
import '../../../domain/exceptions/business_exception.dart';

abstract class AuthRemoteDatasource {
  Future<AuthResponseModel> login(
    String email,
    String password, {
    String? fcmToken,
  });
  Future<AuthResponseModel> googleLogin(String idToken, {String? fcmToken});
  Future<void> signup({
    required String fullName,
    required String phone,
    required String email,
    required String password,
  });
  Future<void> verifyOtp(String email, String otp);
  Future<void> resendOtp(String email);
  Future<void> logout(String accessToken, String refreshToken);
  Future<void> updateProfile({
    required String accessToken,
    required String fullName,
    required String phone,
    required String email,
  });
  Future<AuthResponseModel> refreshToken(String email, String refreshToken);
  Future<void> forgotPassword(String email, {bool useRecoveryEmail = false});
  Future<List<Map<String, dynamic>>> getUsers({
    int page = 1,
    int pageSize = 50,
    String? role,
  });
  Future<String> verifyForgotOtp(String email, String otp);
  Future<bool> resetPassword({
    required String email,
    required String token,
    required String newPassword,
  });
  Future<List<Map<String, dynamic>>> getLoginHistory(String accessToken);
  Future<void> setRecoveryEmail({
    required String accessToken,
    required String recoveryEmail,
    required String password,
  });
  Future<void> verifyRecoveryEmail({
    required String accessToken,
    required String otpCode,
  });
  Future<Map<String, dynamic>> getTechnicianMetrics(String accessToken);
  Future<void> changePassword({
    required String accessToken,
    required String currentPassword,
    required String newPassword,
  });
  Future<String> uploadAvatar({
    required String accessToken,
    required String filePath,
  });
  Future<void> updateUserStatus({
    required String accessToken,
    required String userId,
    required int statusId,
  });
  Future<void> closeAccount({required String accessToken});
  Future<Map<String, dynamic>> getMe({required String accessToken});
  Future<Map<String, dynamic>> getUserById({
    required String accessToken,
    required String userId,
  });
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final http.Client client;
  static final String _baseURL = dotenv.get("BASE_URL");
  static final Duration _timeOut = Duration(
    seconds: int.tryParse(dotenv.get("TIMEOUT_SECONDS", fallback: "20")) ?? 20,
  );

  AuthRemoteDatasourceImpl(this.client);

  Future<String> _getDeviceName() async {
    try {
      final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        return '${androidInfo.manufacturer} ${androidInfo.model}';
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        return iosInfo.name;
      } else if (Platform.isMacOS) {
        final macInfo = await deviceInfo.macOsInfo;
        return macInfo.computerName;
      } else if (Platform.isWindows) {
        final windowsInfo = await deviceInfo.windowsInfo;
        return windowsInfo.computerName;
      } else if (Platform.isLinux) {
        final linuxInfo = await deviceInfo.linuxInfo;
        return linuxInfo.name;
      }
    } catch (e) {
      debugPrint("Error getting device name: $e");
    }
    return 'Unknown Device';
  }

  Future<String?> _getLocationString() async {
    try {
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        final position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.low,
            timeLimit: Duration(seconds: 4),
          ),
        );
        final lat = position.latitude;
        final lon = position.longitude;
        try {
          final url = Uri.parse(
            'https://nominatim.openstreetmap.org/reverse?format=json&lat=$lat&lon=$lon',
          );
          final response = await client
              .get(url, headers: {'User-Agent': 'Zent-FE-App'})
              .timeout(const Duration(seconds: 4));
          if (response.statusCode == 200) {
            final data = jsonDecode(response.body);
            final displayName = data['display_name'] as String?;
            if (displayName != null && displayName.isNotEmpty) {
              return displayName;
            }
          }
        } catch (e) {
          debugPrint("Error reverse geocoding via Nominatim: $e");
        }
        return "$lat, $lon";
      }
    } catch (e) {
      debugPrint("Error getting location: $e");
    }
    return null;
  }

  @override
  Future<AuthResponseModel> login(
    String email,
    String password, {
    String? fcmToken,
  }) async {
    final url = Uri.parse('$_baseURL/auth/login');
    try {
      final Map<String, dynamic> bodyMap = {
        'email': email,
        'password': password,
        'device_name': await _getDeviceName(),
      };
      final loc = await _getLocationString();
      if (loc != null) {
        bodyMap['location'] = loc;
      }
      if (fcmToken != null) {
        bodyMap['fcm_token'] = fcmToken;
      }
      final response = await client
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode(bodyMap),
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
  Future<AuthResponseModel> googleLogin(
    String idToken, {
    String? fcmToken,
  }) async {
    final url = Uri.parse('$_baseURL/auth/google-login');
    try {
      final Map<String, dynamic> bodyMap = {
        'idToken': idToken,
        'deviceName': await _getDeviceName(),
      };
      final loc = await _getLocationString();
      if (loc != null) {
        bodyMap['location'] = loc;
      }
      if (fcmToken != null) {
        bodyMap['fcmToken'] = fcmToken;
      }
      final response = await client
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode(bodyMap),
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
        throw Exception(apiResponse.message ?? 'Google Login Failed');
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Google Login error: $e');
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
  Future<void> updateProfile({
    required String accessToken,
    required String fullName,
    required String phone,
    required String email,
  }) async {
    final url = Uri.parse('$_baseURL/users/me');
    try {
      final response = await client
          .put(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $accessToken',
            },
            body: jsonEncode({
              'fullName': fullName,
              'phone': phone,
              'email': email,
            }),
          )
          .timeout(_timeOut);

      if (response.statusCode == 200) {
        return;
      } else {
        _handleErrorResponse(response);
      }
    } catch (e) {
      if (e is TimeoutException || e is SocketException) {
        throw BusinessException('Network error. Please check your connection.');
      }
      rethrow;
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
  Future<void> forgotPassword(
    String email, {
    bool useRecoveryEmail = false,
  }) async {
    final url = Uri.parse('$_baseURL/auth/forgot-password');
    try {
      final Map<String, dynamic> body = {'email': email};
      if (useRecoveryEmail) body['use_recovery_email'] = true;

      final response = await client
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode(body),
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
        _handleErrorResponse(response);
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
  Future<List<Map<String, dynamic>>> getUsers({
    int page = 1,
    int pageSize = 50,
    String? role,
  }) async {
    final queryParameters = <String, String>{
      'page': page.toString(),
      'page_size': pageSize.toString(),
    };
    if (role != null) queryParameters['role'] = role;

    final url = Uri.parse(
      '$_baseURL/users',
    ).replace(queryParameters: queryParameters);

    try {
      final token = await sl<AuthLocalDataSource>().getAccessToken();
      final response = await client
          .get(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              if (token != null) 'Authorization': 'Bearer $token',
            },
          )
          .timeout(_timeOut);

      if (response.statusCode != 200) {
        _handleErrorResponse(response);
      }

      final jsonMap = jsonDecode(response.body);
      // API returns { data: { users: [...], total: N } } per ApiResponse_UserListResponseData
      final dataMap = jsonMap['data'] as Map<String, dynamic>?;
      if (dataMap == null) return [];

      final usersList = dataMap['users'] as List<dynamic>? ?? [];
      return usersList.map((item) => item as Map<String, dynamic>).toList();
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Error fetching users: $e');
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

  @override
  Future<List<Map<String, dynamic>>> getLoginHistory(String accessToken) async {
    final url = Uri.parse('$_baseURL/auth/login-history');
    try {
      final response = await client
          .get(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $accessToken',
            },
          )
          .timeout(_timeOut);

      if (response.statusCode != 200) {
        _handleErrorResponse(response);
      }

      final jsonMap = jsonDecode(response.body);
      final apiResponse = ApiResponse<List<dynamic>>.fromJson(
        jsonMap,
        (data) => data as List<dynamic>,
      );

      if (apiResponse.isSuccessful && apiResponse.data != null) {
        return apiResponse.data!
            .map((item) => item as Map<String, dynamic>)
            .toList();
      } else {
        throw Exception(apiResponse.message ?? 'Failed to fetch login history');
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Login history error: $e');
    }
  }

  @override
  Future<void> setRecoveryEmail({
    required String accessToken,
    required String recoveryEmail,
    required String password,
  }) async {
    final url = Uri.parse('$_baseURL/auth/recovery-email');
    try {
      final response = await client
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $accessToken',
            },
            body: jsonEncode({
              'recoveryEmail': recoveryEmail,
              'password': password,
            }),
          )
          .timeout(_timeOut);

      if (response.statusCode != 200) {
        _handleErrorResponse(response);
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Set recovery email error: $e');
    }
  }

  @override
  Future<void> verifyRecoveryEmail({
    required String accessToken,
    required String otpCode,
  }) async {
    final url = Uri.parse('$_baseURL/auth/verify-recovery-email');
    try {
      final response = await client
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $accessToken',
            },
            body: jsonEncode({'otpCode': otpCode}),
          )
          .timeout(_timeOut);

      if (response.statusCode != 200) {
        _handleErrorResponse(response);
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Verify recovery email error: $e');
    }
  }

  @override
  Future<void> changePassword({
    required String accessToken,
    required String currentPassword,
    required String newPassword,
  }) async {
    final url = Uri.parse('$_baseURL/auth/change-password');
    try {
      final response = await client
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $accessToken',
            },
            body: jsonEncode({
              'oldPassword': currentPassword,
              'newPassword': newPassword,
            }),
          )
          .timeout(_timeOut);

      if (response.statusCode != 200) {
        _handleErrorResponse(response);
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Change password error: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getTechnicianMetrics(String accessToken) async {
    final url = Uri.parse('$_baseURL/work_orders/technician/metrics');
    try {
      final response = await client
          .get(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $accessToken',
            },
          )
          .timeout(_timeOut);

      if (response.statusCode != 200) {
        _handleErrorResponse(response);
      }

      final jsonMap = jsonDecode(response.body);
      return (jsonMap['data'] as Map<String, dynamic>?) ?? {};
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Fetch technician metrics error: $e');
    }
  }

  @override
  Future<String> uploadAvatar({
    required String accessToken,
    required String filePath,
  }) async {
    final url = Uri.parse('$_baseURL/users/me/avatar');
    try {
      final request = http.MultipartRequest('POST', url);
      request.headers.addAll({
        'Authorization': 'Bearer $accessToken',
        'Accept': 'application/json',
      });
      final ext = filePath.split('.').last.toLowerCase();
      MediaType mediaType;
      if (ext == 'png') {
        mediaType = MediaType('image', 'png');
      } else if (ext == 'webp') {
        mediaType = MediaType('image', 'webp');
      } else {
        mediaType = MediaType('image', 'jpeg');
      }

      final file = await http.MultipartFile.fromPath(
        'file',
        filePath,
        contentType: mediaType,
      );
      request.files.add(file);

      final streamedResponse = await request.send().timeout(_timeOut);
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode != 200) {
        _handleErrorResponse(response);
      }

      final jsonMap = jsonDecode(response.body);
      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        jsonMap,
        (data) => data as Map<String, dynamic>,
      );

      if (apiResponse.isSuccessful && apiResponse.data != null) {
        return (apiResponse.data!['avatarName'] ?? '').toString();
      } else {
        throw Exception(apiResponse.message ?? 'Upload avatar failed');
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Upload avatar error: $e');
    }
  }

  @override
  Future<void> updateUserStatus({
    required String accessToken,
    required String userId,
    required int statusId,
  }) async {
    final url = Uri.parse('$_baseURL/users/$userId/status');
    try {
      final response = await client
          .patch(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $accessToken',
            },
            body: jsonEncode({'accountStatusId': statusId}),
          )
          .timeout(_timeOut);

      if (response.statusCode != 200) {
        _handleErrorResponse(response);
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Update user status error: $e');
    }
  }

  @override
  Future<void> closeAccount({required String accessToken}) async {
    final url = Uri.parse('$_baseURL/users/me/close');
    try {
      final response = await client
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $accessToken',
            },
          )
          .timeout(_timeOut);

      if (response.statusCode != 200) {
        _handleErrorResponse(response);
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Close account error: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getMe({required String accessToken}) async {
    final url = Uri.parse('$_baseURL/users/me');
    try {
      final response = await client
          .get(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $accessToken',
            },
          )
          .timeout(_timeOut);

      if (response.statusCode != 200) {
        _handleErrorResponse(response);
      }

      final jsonMap = jsonDecode(response.body);
      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        jsonMap,
        (data) => data as Map<String, dynamic>,
      );

      if (apiResponse.isSuccessful && apiResponse.data != null) {
        return apiResponse.data!;
      } else {
        throw Exception(apiResponse.message ?? 'Failed to get user profile');
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Get user profile error: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getUserById({
    required String accessToken,
    required String userId,
  }) async {
    final url = Uri.parse('$_baseURL/users/$userId');
    try {
      final response = await client
          .get(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $accessToken',
            },
          )
          .timeout(_timeOut);

      if (response.statusCode != 200) {
        _handleErrorResponse(response);
      }

      final jsonMap = jsonDecode(response.body);
      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        jsonMap,
        (data) => data as Map<String, dynamic>,
      );

      if (apiResponse.isSuccessful && apiResponse.data != null) {
        return apiResponse.data!;
      } else {
        throw Exception(
          apiResponse.message ?? 'Failed to get user profile by ID',
        );
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Get user profile by ID error: $e');
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
      if (statusCode == 401) {
        throw BusinessException('Invalid email or password');
      }
      throw Exception('Silent server error');
    }

    try {
      final errorMap = jsonDecode(body);
      if (errorMap is Map<String, dynamic>) {
        final message = errorMap['message'];
        if (statusCode >= 400 && statusCode < 500 && message is String) {
          throw BusinessException(message);
        }
      }
    } catch (e) {
      if (e is BusinessException) rethrow;
    }

    if (statusCode == 401) {
      throw BusinessException('Invalid email or password');
    }
    throw Exception('Silent server error');
  }
}
