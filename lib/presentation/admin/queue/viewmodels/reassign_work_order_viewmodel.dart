import 'package:flutter/material.dart';

class ReassignWorkOrderViewModel extends ChangeNotifier {
  String _orderId = '';
  String get orderId => _orderId;

  final List<Map<String, dynamic>> technicians = [
    {'name': 'John Doe Doe', 'rating': 4.5, 'workload': 2},
    {'name': 'John Doe Doe', 'rating': 4.5, 'workload': 2},
  ];

  void initData(String id) {
    _orderId = id.startsWith('#') ? id : '#$id';
    notifyListeners();
  }
}
