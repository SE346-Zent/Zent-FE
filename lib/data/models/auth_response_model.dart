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
    return AuthResponseModel(
      accessToken: json['accessToken'] as String? ?? '',
      refreshToken: json['refreshToken'] as String? ?? '',
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>? ?? {}),
      tokenType: json['tokenType'] as String? ?? 'Bearer',
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
