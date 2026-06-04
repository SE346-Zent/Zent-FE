import 'package:flutter/foundation.dart';
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
    super.senderAvatarName,
    super.senderName,
  });

  factory NotificationListItemModel.fromJson(Map<String, dynamic> json) {
    DateTime parseDateTime(String dateStr) {
      try {
        return DateTime.parse(dateStr);
      } catch (_) {
        // Handle formats like "2026-05-15 11:34:18.285 UTC"
        String normalized = dateStr
            .replaceAll(' UTC', 'Z')
            .replaceFirst(' ', 'T');
        try {
          return DateTime.parse(normalized);
        } catch (e) {
          debugPrint('Error parsing date "$dateStr": $e');
          return DateTime.now(); // Fallback to current time
        }
      }
    }

    return NotificationListItemModel(
      notificationId: json['notificationId'] as String,
      categoryId: json['categoryId'] as int,
      categoryName: json['categoryName'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      isRead: json['isRead'] as bool? ?? false,
      createdAt: parseDateTime(json['createdAt'] as String),
      data: json['data'] as Map<String, dynamic>?,
      senderAvatarName: json['senderAvatarName'] as String? ??
          (json['data'] is Map ? (json['data'] as Map)['senderAvatarName']?.toString() : null) ??
          (json['data'] is Map ? (json['data'] as Map)['avatarUrl']?.toString() : null),
      senderName: json['senderName'] as String? ??
          (json['data'] is Map ? (json['data'] as Map)['senderName']?.toString() : null),
    );
  }
}
