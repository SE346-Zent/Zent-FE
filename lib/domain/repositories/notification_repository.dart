import '../entities/notification_item.dart';

abstract class NotificationRepository {
  Future<List<NotificationItem>> getNotifications({
    int page = 1,
    int limit = 20,
    int? categoryId,
  });
}
