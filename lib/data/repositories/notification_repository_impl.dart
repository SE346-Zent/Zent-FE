import '../../domain/entities/notification_item.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasources/remote/notification_remote_datasource.dart';

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
}
