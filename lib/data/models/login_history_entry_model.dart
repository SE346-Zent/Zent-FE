import 'package:zent_fe/domain/entities/login_history_entry.dart';

class LoginHistoryEntryModel extends LoginHistoryEntry {
  LoginHistoryEntryModel({
    required super.id,
    required super.sessionId,
    required super.deviceName,
    required super.ipAddress,
    super.location,
    required super.createdAt,
  });

  factory LoginHistoryEntryModel.fromJson(Map<String, dynamic> json) {
    return LoginHistoryEntryModel(
      id: json['id'] as String? ?? '',
      sessionId: json['sessionId'] as String? ?? '',
      deviceName: json['deviceName'] as String? ?? 'Unknown Device',
      ipAddress: json['ipAddress'] as String? ?? '',
      location: json['location'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
    );
  }
}
