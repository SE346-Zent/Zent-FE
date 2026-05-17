import '../../entities/notification_item.dart';
import '../../repositories/notification_repository.dart';

class GetNotificationsUseCase {
  final NotificationRepository repository;

  GetNotificationsUseCase(this.repository);

  Future<List<NotificationItem>> call({
    int page = 1,
    int limit = 20,
    int? categoryId,
  }) async {
    return await repository.getNotifications(
      page: page,
      limit: limit,
      categoryId: categoryId,
    );
  }
}
