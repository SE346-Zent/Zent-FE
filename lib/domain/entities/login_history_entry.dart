class LoginHistoryEntry {
  final String id;
  final String sessionId;
  final String deviceName;
  final String ipAddress;
  final String? location;
  final DateTime createdAt;

  LoginHistoryEntry({
    required this.id,
    required this.sessionId,
    required this.deviceName,
    required this.ipAddress,
    this.location,
    required this.createdAt,
  });
}
