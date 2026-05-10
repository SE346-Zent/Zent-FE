import 'package:flutter/material.dart';

class OperationalQueueViewModel extends ChangeNotifier {
  int _activeTabIndex = 0;

  int get activeTabIndex => _activeTabIndex;

  void changeTab(int index) {
    if (_activeTabIndex != index) {
      _activeTabIndex = index;
      notifyListeners();
    }
  }

  // --- Mock Data ---
  List<Map<String, dynamic>> get currentJobs {
    final allJobs = [
      {
        'id': '#WO-1234',
        'title': 'Legion 5 15IRX10',
        'assignee': 'John Doe',
        'location': '123 Hoa Binh, Quan Tan Phu, TPHCM',
        'time': '12h30 PM, Oct 20, 2026',
        'status': 'Pending assignment',
        'statusEnum': 'unassigned', // using enum-like string mapped
      },
      {
        'id': '#WO-1235',
        'title': 'IdeaPad 16ARH7',
        'assignee': 'John Doe',
        'location': '123 Hoa Binh, Quan Tan Phu, TPHCM',
        'time': '12h30 PM, Oct 20, 2026',
        'status': 'Pending assignment',
        'statusEnum': 'unassigned',
      },
      {
        'id': '#WO-1236',
        'title': 'ThinkPad X1 Carbon',
        'assignee': 'Jane Smith',
        'location': '456 Le Loi, Quan 1, TPHCM',
        'time': '09h00 AM, Oct 21, 2026',
        'status': 'In Progress',
        'statusEnum': 'assigned',
      },
      {
        'id': '#WO-1237',
        'title': 'Yoga Slim 7',
        'assignee': 'Alice',
        'location': '789 Nguyen Hue, Quan 1, TPHCM',
        'time': '10h00 AM, Oct 22, 2026',
        'status': 'Resolved',
        'statusEnum': 'completed',
      },
    ];

    switch (_activeTabIndex) {
      case 1:
        return allJobs.where((j) => j['statusEnum'] == 'assigned').toList();
      case 2:
        return allJobs.where((j) => j['statusEnum'] == 'unassigned').toList();
      case 3:
        return allJobs.where((j) => j['statusEnum'] == 'completed').toList();
      case 0:
      default:
        return allJobs;
    }
  }
}
