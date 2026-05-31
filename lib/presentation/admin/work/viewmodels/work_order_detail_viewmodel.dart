import 'package:zent_fe/presentation/common/core/safe_change_notifier.dart';
import 'package:flutter/material.dart';

class WorkOrderDetailViewModel extends ChangeNotifier with SafeChangeNotifier {
  String _orderId = '';

  String get orderId => _orderId;

  final String deviceName = 'IdeaPad 16ARH7';
  final String customerName = 'John Doe';
  final String location = '123 Hoa Binh, Quan Tan Phu, HCM';
  final String time = 'Oct 30, 2026 - 10h00 AM';

  final List<Map<String, dynamic>> technicians = [
    {'name': 'John Doe Doe', 'rating': 4.5, 'workload': 2},
    {'name': 'John Doe Doe', 'rating': 4.5, 'workload': 2},
  ];

  void initData(String id) {
    _orderId = id.startsWith('#') ? id : '#$id';
    notifyListeners();
  }
}
