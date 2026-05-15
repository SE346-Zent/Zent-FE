import '../../domain/entities/notification_item.dart';

class NotificationListItemModel extends NotificationItem {
  const NotificationListItemModel({
    required super.notificationId,
    required super.categoryId,
    required super.categoryName,
    required super.title,
    required super.body,
    required super.isRead,
    required super.createdAt,
    super.data,
  });

  factory NotificationListItemModel.fromJson(Map<String, dynamic> json) {
    return NotificationListItemModel(
      notificationId: json['notificationId'] as String,
      categoryId: json['categoryId'] as int,
      categoryName: json['categoryName'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      isRead: json['isRead'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      data: json['data'] as Map<String, dynamic>?,
    );
  }
}
