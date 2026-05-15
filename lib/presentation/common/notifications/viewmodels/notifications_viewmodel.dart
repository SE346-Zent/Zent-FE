import 'package:flutter/foundation.dart';
import 'package:zent_fe/domain/entities/notification_item.dart';
import 'package:zent_fe/domain/usecases/notification/get_notifications_usecase.dart';
import 'package:zent_fe/di/injection_container.dart';

class NotificationsViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<NotificationItem> _notifications = [];
  List<NotificationItem> get notifications => _notifications;

  int _currentPage = 1;
  final int _limit = 20;
  bool _hasMore = true;
  bool get hasMore => _hasMore;

  void fetchNotifications({bool refresh = false}) async {
    if (_isLoading || (!_hasMore && !refresh)) return;

    if (refresh) {
      _currentPage = 1;
      _hasMore = true;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final useCase = sl<GetNotificationsUseCase>();
      final results = await useCase(page: _currentPage, limit: _limit);

      if (refresh) {
        _notifications = results;
      } else {
        _notifications.addAll(results);
      }

      if (results.length < _limit) {
        _hasMore = false;
      } else {
        _currentPage++;
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  void markAsRead(String id) {
    final index = _notifications.indexWhere((n) => n.notificationId == id);
    if (index != -1 && !_notifications[index].isRead) {
      // Create a copy to update the isRead property
      final old = _notifications[index];
      _notifications[index] = NotificationItem(
        notificationId: old.notificationId,
        categoryId: old.categoryId,
        categoryName: old.categoryName,
        title: old.title,
        body: old.body,
        isRead: true, // Marked locally
        createdAt: old.createdAt,
        data: old.data,
      );
      notifyListeners();

      // Since backend doesn't have an endpoint for single mark as read
      // we only update it locally for now.
    }
  }
}
