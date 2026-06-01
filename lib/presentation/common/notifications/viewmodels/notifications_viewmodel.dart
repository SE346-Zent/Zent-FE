import 'package:zent_fe/presentation/common/core/safe_change_notifier.dart';
import 'package:flutter/material.dart';
import 'package:zent_fe/domain/entities/notification_item.dart';
import 'package:zent_fe/domain/usecases/notification/get_notifications_usecase.dart';
import 'package:zent_fe/domain/usecases/notification/get_unread_count_usecase.dart';
import 'package:zent_fe/di/injection_container.dart';

class NotificationsViewModel extends ChangeNotifier with SafeChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<NotificationItem> _notifications = [];
  List<NotificationItem> get notifications => _notifications;

  int _unreadCount = 0;
  int get unreadCount => _unreadCount;

  int _currentPage = 1;
  final int _limit = 20;
  bool _hasMore = true;
  bool get hasMore => _hasMore;

  List<NotificationItem> get todayNotifications {
    final now = DateTime.now();
    return _notifications.where((n) {
      final date = n.createdAt.toLocal();
      return date.year == now.year &&
          date.month == now.month &&
          date.day == now.day;
    }).toList();
  }

  List<NotificationItem> get thisWeekNotifications {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return _notifications.where((n) {
      final date = n.createdAt.toLocal();
      final notificationDate = DateTime(date.year, date.month, date.day);
      return notificationDate.isBefore(today);
    }).toList();
  }

  void fetchUnreadCount() async {
    try {
      final useCase = sl<GetUnreadCountUseCase>();
      _unreadCount = await useCase.execute();
      notifyListeners();
    } catch (e) {
      debugPrint("Error fetching unread count: $e");
    }
  }

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
        _notifications = List<NotificationItem>.from(results);
      } else {
        _notifications.addAll(results);
      }

      if (results.length < _limit) {
        _hasMore = false;
      } else {
        _currentPage++;
      }

      // Update unread count locally if needed
      _unreadCount = _notifications.where((n) => !n.isRead).length;

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
      final old = _notifications[index];
      _notifications[index] = NotificationItem(
        notificationId: old.notificationId,
        categoryId: old.categoryId,
        categoryName: old.categoryName,
        title: old.title,
        body: old.body,
        isRead: true,
        createdAt: old.createdAt,
        data: old.data,
      );
      _unreadCount = (_unreadCount > 0) ? _unreadCount - 1 : 0;
      notifyListeners();
    }
  }
}
