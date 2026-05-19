import 'dart:convert';
import 'user_model.dart' show UserModel;
import '../../domain/entities/user.dart' show User;

class AuthResponseModel {
  final String accessToken;
  final String refreshToken;
  final User user;
  final String tokenType;

  AuthResponseModel({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
    required this.tokenType,
  });

  //* from json
  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    final accessToken = (json['accessToken'] ?? '').toString();
    
    // Extract real user ID from accessToken if possible
    String parsedUserId = 'temp_id';
    if (accessToken.isNotEmpty) {
      try {
        final parts = accessToken.split('.');
        if (parts.length == 3) {
          final payload = utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
          final payloadMap = jsonDecode(payload) as Map<String, dynamic>;
          if (payloadMap['sub'] != null) {
            parsedUserId = payloadMap['sub'].toString();
          }
        }
      } catch (_) {}
    }

    final userJson = json['user'] as Map<String, dynamic>? ?? {};
    if (userJson['id'] == null && userJson['_id'] == null) {
      userJson['id'] = parsedUserId;
    }

    return AuthResponseModel(
      accessToken: accessToken,
      refreshToken: (json['refreshToken'] ?? '').toString(),
      user: UserModel.fromJson(userJson),
      tokenType: (json['tokenType'] ?? 'Bearer').toString(),
    );
  }

  //* to json
  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'user': UserModel.fromEntity(user).toJson(),
      'tokenType': tokenType,
    };
  }
}
