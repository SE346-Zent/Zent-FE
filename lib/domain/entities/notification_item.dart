class NotificationItem {
  final String notificationId;
  final int categoryId;
  final String categoryName;
  final String title;
  final String body;
  final bool isRead;
  final DateTime createdAt;
  final Map<String, dynamic>? data;

  const NotificationItem({
    required this.notificationId,
    required this.categoryId,
    required this.categoryName,
    required this.title,
    required this.body,
    required this.isRead,
    required this.createdAt,
    this.data,
  });
}
