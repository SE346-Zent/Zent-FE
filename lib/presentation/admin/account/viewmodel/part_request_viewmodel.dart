import 'package:flutter/material.dart';

class PartRequestItem {
  final String partName;
  final String woId;
  final String date;
  final String status;

  PartRequestItem({
    required this.partName,
    required this.woId,
    required this.date,
    required this.status,
  });
}

class PartRequestsViewModel extends ChangeNotifier {
  int pendingCount = 10;
  int approvedCount = 10;
  int rejectedCount = 10;

  String searchQuery = '';

  List<PartRequestItem> requests = [
    PartRequestItem(
      partName: 'PARTNAME 123',
      woId: 'WO-12345',
      date: 'Oct 10, 2025',
      status: 'Pending',
    ),
    PartRequestItem(
      partName: 'PARTNAME 123',
      woId: 'WO-12345',
      date: 'Oct 10, 2025',
      status: 'Approved',
    ),
    PartRequestItem(
      partName: 'PARTNAME 123',
      woId: 'WO-12345',
      date: 'Oct 10, 2025',
      status: 'Rejected',
    ),
  ];
  void onSearchChanged(String query) {
    searchQuery = query;
    // TODO: Add filtering logic based on searchQuery
    notifyListeners();
  }
}
