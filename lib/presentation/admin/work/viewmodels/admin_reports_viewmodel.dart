import 'package:flutter/material.dart';

class AdminReportsViewModel extends ChangeNotifier {
  int _activeTabIndex = 0; // 0 for 'Last 7 days', 1 for 'Last 30 days'
  int get activeTabIndex => _activeTabIndex;

  void changeTab(int index) {
    if (_activeTabIndex != index) {
      _activeTabIndex = index;
      notifyListeners();
    }
  }

  // --- Mock Data ---
  String get totalJobs => _activeTabIndex == 0 ? '1,200' : '5,400';
  String get totalJobsTrend => _activeTabIndex == 0 ? '10%' : '15%';

  String get totalImported => _activeTabIndex == 0 ? '4,600' : '18,500';
  String get totalImportedTrend => _activeTabIndex == 0 ? '10%' : '12%';

  String get totalReturned => _activeTabIndex == 0 ? '2,100' : '8,200';
  String get totalReturnedTrend => _activeTabIndex == 0 ? '10%' : '8%';

  List<Map<String, double>> get chartData {
    if (_activeTabIndex == 0) {
      return [
        {'current': 60, 'previous': 80, 'complaint': 0},
        {'current': 40, 'previous': 70, 'complaint': 0},
        {'current': 80, 'previous': 90, 'complaint': 0},
        {'current': 80, 'previous': 75, 'complaint': 0},
        {'current': 50, 'previous': 65, 'complaint': 0},
        {'current': 70, 'previous': 85, 'complaint': 0},
        {'current': 65, 'previous': 60, 'complaint': 0},
      ];
    } else {
      return [
        {'current': 60, 'previous': 80, 'complaint': 0},
        {'current': 40, 'previous': 70, 'complaint': 0},
        {'current': 80, 'previous': 90, 'complaint': 0},
        {'current': 80, 'previous': 75, 'complaint': 0},
      ];
    }
  }

  List<String> get chartLabels {
    if (_activeTabIndex == 0) {
      return [
        'DAY\n1',
        'DAY\n2',
        'DAY\n3',
        'DAY\n4',
        'DAY\n5',
        'DAY\n6',
        'DAY\n7',
      ];
    } else {
      return ['WEEK\n1', 'WEEK\n2', 'WEEK\n3', 'WEEK\n4'];
    }
  }

  List<Map<String, dynamic>> get partCategories {
    return [
      {'name': 'ELECTRICAL COMPONENTS', 'percentage': 0.47, 'label': '47%'},
      {'name': 'HVAC SPARATES', 'percentage': 0.30, 'label': '30%'},
      {'name': 'ABC', 'percentage': 0.20, 'label': '20%'},
      {'name': 'Other', 'percentage': 0.03, 'label': '3%'},
    ];
  }
}
