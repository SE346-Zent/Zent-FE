import 'package:flutter/material.dart';

class CompletedRepairItem {
  final String title;
  final String woNumber;
  final String date;

  CompletedRepairItem({
    required this.title,
    required this.woNumber,
    required this.date,
  });
}

class ActiveRepairsViewModel extends ChangeNotifier {
  int currentStatusStep = 2;

  final List<CompletedRepairItem> recentCompleted = [
    CompletedRepairItem(
      title: 'Laptop Repair',
      woNumber: 'WO-12345678',
      date: 'Oct 30, 2026',
    ),
    CompletedRepairItem(
      title: 'Laptop Repair',
      woNumber: 'WO-12345678',
      date: 'Oct 30, 2026',
    ),
    CompletedRepairItem(
      title: 'Laptop Repair',
      woNumber: 'WO-12345678',
      date: 'Oct 30, 2026',
    ),
  ];
}
