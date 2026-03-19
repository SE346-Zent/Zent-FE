import 'package:flutter/material.dart';

class MockWorkOrder {
  final String id;
  final String title;
  final String priority; // 'High' or 'Normal'
  final String status; // 'In Progress', 'Pending', 'Completed'
  final String customerName;
  final String time;
  final String address;

  MockWorkOrder(this.id, this.title, this.priority, this.status, this.customerName, this.time, this.address);
}

class TechWorkOrderViewModel extends ChangeNotifier {
  int selectedFilterIndex = 0;
  final List<String> filters = ['All Jobs', 'In Progress', 'Pending', 'Completed'];

  final List<MockWorkOrder> allOrders = [
    MockWorkOrder('#WO-1234', 'Laptop Repair', 'High', 'In Progress', 'John Doe', '10:30 AM - Today', '123 Hoa Binh, Quan Tan Phu, TPHCM'),
    MockWorkOrder('#WO-1235', 'PC Maintenance', 'Normal', 'Pending', 'Jane Smith', '02:00 PM - Tomorrow', '456 Le Loi, Quan 1, TPHCM'),
    MockWorkOrder('#WO-1236', 'Screen Replacement', 'High', 'Completed', 'Peter Parker', '09:00 AM - Yesterday', '789 Nguyen Hue, Quan 1, TPHCM'),
  ];

  List<MockWorkOrder> get filteredOrders {
    if (selectedFilterIndex == 0) return allOrders;
    final statusFilter = filters[selectedFilterIndex];
    return allOrders.where((order) => order.status == statusFilter).toList();
  }

  void setFilter(int index) {
    selectedFilterIndex = index;
    notifyListeners();
  }
}