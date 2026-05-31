import 'package:flutter/material.dart';

class ViewScheduleViewModel extends ChangeNotifier {
  String _techId = '';
  String get techId => _techId;

  int _selectedDateIndex = 2;
  int get selectedDateIndex => _selectedDateIndex;

  final Map<String, dynamic> technician = {
    'name': 'John Doe Doe',
    'email': 'JohnDoe@gmail.com',
    'rating': 4.5,
    'avatar': 'https://i.pravatar.cc/150?img=11',
  };

  final List<Map<String, dynamic>> scheduleDays = [
    {'day': 'Mon', 'date': '20'},
    {'day': 'Tue', 'date': '21'},
    {'day': 'Wed', 'date': '22'},
    {'day': 'Thu', 'date': '23'},
    {'day': 'Fri', 'date': '24'},
    {'day': 'Sat', 'date': '25'},
    {'day': 'Sun', 'date': '26'},
  ];

  final List<Map<String, dynamic>> workOrders = [
    {
      'id': '#WO-1234',
      'deviceName': 'IdeaPad 16ARH7',
      'customer': 'John Doe',
      'location': '123 Hoa Binh, Quan Tan Phu, TPHCM',
      'time': '12h30 PM, Oct 20, 2026',
    },
  ];

  void initData(String id) {
    _techId = id;
    notifyListeners();
  }

  void selectDate(int index) {
    if (_selectedDateIndex != index) {
      _selectedDateIndex = index;
      notifyListeners();
    }
  }
}
