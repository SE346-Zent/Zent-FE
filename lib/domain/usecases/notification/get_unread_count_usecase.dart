import '../../repositories/notification_repository.dart';

class GetUnreadCountUseCase {
  final NotificationRepository repository;

  GetUnreadCountUseCase(this.repository);

  Future<int> execute() async {
    return await repository.getUnreadCount();
  }
}
