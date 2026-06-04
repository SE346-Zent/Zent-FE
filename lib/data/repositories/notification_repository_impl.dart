import '../../domain/entities/notification_item.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasources/remote/notification_remote_datasource.dart';
import '../models/notification_preference_model.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource remoteDataSource;

  NotificationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<NotificationItem>> getNotifications({
    int page = 1,
    int limit = 20,
    int? categoryId,
  }) async {
    return await remoteDataSource.getNotifications(
      page: page,
      limit: limit,
      categoryId: categoryId,
    );
  }

  @override
  Future<int> getUnreadCount() async {
    return await remoteDataSource.getUnreadCount();
  }

  @override
  Future<List<NotificationPreferenceModel>> getNotificationPreferences() async {
    return await remoteDataSource.getNotificationPreferences();
  }

  @override
  Future<void> updateNotificationPreference(
    int categoryId,
    bool osEnabled,
  ) async {
    await remoteDataSource.updateNotificationPreference(categoryId, osEnabled);
  }
}
