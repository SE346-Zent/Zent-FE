import '../entities/notification_item.dart';
import '../../data/models/notification_preference_model.dart';

abstract class NotificationRepository {
  Future<List<NotificationItem>> getNotifications({
    int page = 1,
    int limit = 20,
    int? categoryId,
  });

  Future<int> getUnreadCount();

  Future<List<NotificationPreferenceModel>> getNotificationPreferences();

  Future<void> updateNotificationPreference(int categoryId, bool osEnabled);
}
