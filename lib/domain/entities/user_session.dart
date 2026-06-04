class UserSession {
  final String id;
  final String deviceName;
  final String ipAddress;
  final bool isCurrent;
  final DateTime createdAt;
  final DateTime expiresAt;

  UserSession({
    required this.id,
    required this.deviceName,
    required this.ipAddress,
    required this.isCurrent,
    required this.createdAt,
    required this.expiresAt,
  });
}
