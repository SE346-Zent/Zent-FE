import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:zent_fe/di/injection_container.dart';
import 'package:zent_fe/presentation/common/auth/auth_view_model.dart';
import 'package:zent_fe/routing/router.dart';
import 'package:zent_fe/routing/routes.dart';

class InterceptedHttpClient extends http.BaseClient {
  final http.Client _inner;
  final FlutterSecureStorage _secureStorage;

  InterceptedHttpClient(this._inner, this._secureStorage);

  Future<String?>? _refreshFuture;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    // 1. Send the original request
    var response = await _inner.send(request);

    final path = request.url.path;

    // 2. Intercept 401 unauthorized errors (excluding login, registration and refresh token endpoints themselves)
    if (response.statusCode == 401 &&
        !path.contains('/auth/login') &&
        !path.contains('/auth/google-login') &&
        !path.contains('/auth/refresh-token') &&
        !path.contains('/auth/register')) {
      debugPrint(
        "InterceptedHttpClient: Intercepted 401 on ${request.url}. Attempting silent token refresh...",
      );

      try {
        final newAccessToken = await _performTokenRefresh();
        if (newAccessToken != null) {
          debugPrint(
            "InterceptedHttpClient: Token refresh succeeded. Retrying request to ${request.url}...",
          );
          final retriedRequest = _copyRequest(request, newAccessToken);
          return await _inner.send(retriedRequest);
        } else {
          debugPrint(
            "InterceptedHttpClient: Token refresh failed. Proceeding with original 401 response and logging out.",
          );
          await _secureStorage.delete(key: 'ACCESS_TOKEN');
          await _secureStorage.delete(key: 'REFRESH_TOKEN');
          try { sl<AuthViewModel>().clearUser(); } catch (_) {}
          try { appRouter.go(Routes.login); } catch (_) {}
        }
      } catch (e) {
        debugPrint(
          "InterceptedHttpClient: Error during token refresh interception: $e",
        );
      }
    }

    return response;
  }

  Future<String?> _performTokenRefresh() async {
    // If there is an active refresh token operation running, reuse it to avoid duplicate network requests
    if (_refreshFuture != null) {
      debugPrint(
        "InterceptedHttpClient: Reusing ongoing token refresh operation...",
      );
      return _refreshFuture;
    }

    _refreshFuture = _refreshTokenCall();
    try {
      final token = await _refreshFuture;
      return token;
    } finally {
      _refreshFuture = null;
    }
  }

  Future<String?> _refreshTokenCall() async {
    try {
      final refreshToken = await _secureStorage.read(key: 'REFRESH_TOKEN');
      if (refreshToken == null || refreshToken.isEmpty) {
        debugPrint("InterceptedHttpClient: No stored refresh token found.");
        return null;
      }

      final String baseURL = dotenv.get("BASE_URL");
      final url = Uri.parse('$baseURL/auth/refresh-token');

      // Make direct request using _inner client to avoid recursive interception
      final response = await _inner
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $refreshToken',
            },
            body: jsonEncode({'refresh_token': refreshToken}),
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final jsonMap = jsonDecode(response.body);
        final data = jsonMap['data'];
        if (data != null) {
          final newAccessToken = data['accessToken']?.toString();
          final newRefreshToken = data['refreshToken']?.toString();

          if (newAccessToken != null && newAccessToken.isNotEmpty) {
            debugPrint(
              "InterceptedHttpClient: Token refresh succeeded. Saving fresh credentials.",
            );
            await _secureStorage.write(
              key: 'ACCESS_TOKEN',
              value: newAccessToken,
            );
            if (newRefreshToken != null && newRefreshToken.isNotEmpty) {
              await _secureStorage.write(
                key: 'REFRESH_TOKEN',
                value: newRefreshToken,
              );
            }
            return newAccessToken;
          }
        }
      }

      debugPrint(
        "InterceptedHttpClient: Token refresh request returned status ${response.statusCode}: ${response.body}",
      );
    } catch (e) {
      debugPrint("InterceptedHttpClient: Exception in _refreshTokenCall: $e");
    }
    return null;
  }

  http.BaseRequest _copyRequest(
    http.BaseRequest original,
    String newAccessToken,
  ) {
    http.BaseRequest request;

    if (original is http.Request) {
      final newReq = http.Request(original.method, original.url);
      newReq.headers.addAll(original.headers);
      newReq.bodyBytes = original.bodyBytes;
      newReq.encoding = original.encoding;
      newReq.followRedirects = original.followRedirects;
      newReq.maxRedirects = original.maxRedirects;
      newReq.persistentConnection = original.persistentConnection;
      request = newReq;
    } else if (original is http.MultipartRequest) {
      final newReq = http.MultipartRequest(original.method, original.url);
      newReq.headers.addAll(original.headers);
      newReq.fields.addAll(original.fields);
      newReq.files.addAll(original.files);
      newReq.followRedirects = original.followRedirects;
      newReq.maxRedirects = original.maxRedirects;
      newReq.persistentConnection = original.persistentConnection;
      request = newReq;
    } else {
      original.headers['Authorization'] = 'Bearer $newAccessToken';
      return original;
    }

    request.headers['Authorization'] = 'Bearer $newAccessToken';
    return request;
  }
}
