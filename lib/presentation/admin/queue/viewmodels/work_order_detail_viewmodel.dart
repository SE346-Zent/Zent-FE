import 'package:flutter/material.dart';

class WorkOrderDetailViewModel extends ChangeNotifier {
  final String orderId = '#WO-1234';
  final String deviceName = 'IdeaPad 16ARH7';
  final String customerName = 'John Doe';
  final String location = '123 Hoa Binh, Quan\nTan Phu, HCM';
  final String time = 'Oct 30, 2026 - 10h00\nAM';

  final List<Map<String, dynamic>> technicians = [
    {'name': 'John Doe Doe', 'rating': 4.5, 'workload': 2},
    {'name': 'John Doe Doe', 'rating': 4.5, 'workload': 2},
  ];
}
