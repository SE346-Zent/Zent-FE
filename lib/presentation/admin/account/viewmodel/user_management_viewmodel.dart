import 'package:flutter/material.dart';
// Enum removed as it's replaced by Bloc states. String values are used for mock data.

class UserManagementViewModel extends ChangeNotifier {
  int _activeTabIndex = 0;
  int get activeTabIndex => _activeTabIndex;

  final List<Map<String, dynamic>> _techniciansData = [
    {
      'userName': 'John Doe',
      'userRole': 'Senior Electrician',
      'avatarUrl': 'https://i.pravatar.cc/150?img=11',
      'status': 'Active',
    },
    {
      'userName': 'Jane Smith',
      'userRole': 'Junior Electrician',
      'avatarUrl': 'https://i.pravatar.cc/150?img=5',
      'status': 'Away',
    },
  ];

  final List<Map<String, dynamic>> _adminsData = [
    {
      'userName': 'Alice Admin',
      'userRole': 'System Administrator',
      'avatarUrl': 'https://i.pravatar.cc/150?img=1',
      'status': 'Active',
    },
    {
      'userName': 'Bob Manager',
      'userRole': 'Regional Manager',
      'avatarUrl': 'https://i.pravatar.cc/150?img=13',
      'status': 'Inactive',
    },
  ];

  List<Map<String, dynamic>> get activeData =>
      _activeTabIndex == 0 ? _techniciansData : _adminsData;

  Map<String, String> get initialStatusMap {
    final map = <String, String>{};
    for (var user in _techniciansData) {
      map[user['userName'] as String] = user['status'] as String;
    }
    for (var user in _adminsData) {
      map[user['userName'] as String] = user['status'] as String;
    }
    return map;
  }

  void changeTab(int index) {
    if (_activeTabIndex != index) {
      _activeTabIndex = index;
      notifyListeners();
      debugPrint("action triggered: Viewmodel logic changed tab to $index");
    }
  }

  void addUser() {
    debugPrint("action triggered: Viewmodel logic addUser");
  }

  void editUser(int index) {
    debugPrint("action triggered: Viewmodel logic editUser for user $index");
  }
}
