import 'package:zent_fe/presentation/common/core/safe_change_notifier.dart';
import 'package:flutter/material.dart';

class AdminNotificationsViewModel extends ChangeNotifier
    with SafeChangeNotifier {
  final int todayCount = 3;

  final List<Map<String, dynamic>> todayNotifications = [
    {
      'name': 'John Doe',
      'action': 'John Doe has assigned you WO-12345',
      'isUnread': true,
      'avatar': 'https://i.pravatar.cc/150?img=11',
    },
    {
      'name': 'John Doe',
      'action': 'John Doe has assigned you WO-12345',
      'isUnread': true,
      'avatar': 'https://i.pravatar.cc/150?img=12',
    },
    {
      'name': 'John Doe',
      'action': 'John Doe has assigned you WO-12345',
      'isUnread': true,
      'avatar': 'https://i.pravatar.cc/150?img=13',
    },
  ];

  final List<Map<String, dynamic>> thisWeekNotifications = [
    {
      'name': 'John Doe',
      'action': 'John Doe has assigned you WO-12345',
      'isUnread': false,
      'avatar': 'https://i.pravatar.cc/150?img=14',
    },
    {
      'name': 'John Doe',
      'action': 'John Doe has assigned you WO-12345',
      'isUnread': false,
      'avatar': 'https://i.pravatar.cc/150?img=15',
    },
  ];
}
