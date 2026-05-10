import 'package:flutter/material.dart';

class AssignedWorkOrderDetailViewModel extends ChangeNotifier {
  String _orderId = '';

  String get orderId => _orderId;

  final String techAssignedTime = '45 minutes ago';
  final String symptom = 'ABC XYZ';
  final String description =
      'ABC XYZasdfdsadffffffffffffffffffffffffasdfasdfasdfsaefe';
  final String location = '123 Hoa Binh, Quan Tan Phu, HCM';
  final String time = 'Oct 30, 2026 - 10h00 AM';

  final Map<String, dynamic> technician = {
    'name': 'John Doe Doe',
    'rating': 4.5,
  };

  void initData(String id) {
    _orderId = id.startsWith('#') ? id : '#$id';
    notifyListeners();
  }
}
