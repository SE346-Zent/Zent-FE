import '../../domain/entities/user_session.dart';

class UserSessionModel extends UserSession {
  UserSessionModel({
    required super.id,
    required super.deviceName,
    required super.ipAddress,
    required super.isCurrent,
    required super.createdAt,
    required super.expiresAt,
  });

  factory UserSessionModel.fromJson(
    Map<String, dynamic> json, {
    String? currentSessionId,
  }) {
    final id = (json['id'] ?? '').toString();
    return UserSessionModel(
      id: id,
      deviceName:
          (json['deviceName'] ?? json['device_name'] ?? 'Unknown Device')
              .toString(),
      ipAddress: (json['ipAddress'] ?? json['ip_address'] ?? '').toString(),
      isCurrent: currentSessionId != null
          ? id == currentSessionId
          : (json['isCurrent'] ?? json['is_current'] ?? false) as bool,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : (json['created_at'] != null
                ? DateTime.parse(json['created_at'] as String)
                : DateTime.now()),
      expiresAt: json['expiresAt'] != null
          ? DateTime.parse(json['expiresAt'] as String)
          : (json['expires_at'] != null
                ? DateTime.parse(json['expires_at'] as String)
                : DateTime.now()),
    );
  }
}
