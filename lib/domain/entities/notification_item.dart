class NotificationItem {
  final String notificationId;
  final int categoryId;
  final String categoryName;
  final String title;
  final String body;
  final bool isRead;
  final DateTime createdAt;
  final Map<String, dynamic>? data;

  /// Avatar object name for the sender (PAR read key, relative path to OCI storage).
  final String? senderAvatarName;

  /// Display name of the user who triggered this notification.
  final String? senderName;

  const NotificationItem({
    required this.notificationId,
    required this.categoryId,
    required this.categoryName,
    required this.title,
    required this.body,
    required this.isRead,
    required this.createdAt,
    this.data,
    this.senderAvatarName,
    this.senderName,
  });
}
