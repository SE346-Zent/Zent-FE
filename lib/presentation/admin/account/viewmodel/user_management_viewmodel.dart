import 'package:flutter/material.dart';
import 'package:zent_fe/domain/entities/enums/user_status.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';

class UserManagementViewModel extends ChangeNotifier {
  int _activeTabIndex = 0;
  int get activeTabIndex => _activeTabIndex;

  final List<Map<String, dynamic>> _techniciansData = [
    {
      'userName': 'John Doe',
      'userRole': 'Senior Electrician',
      'avatarUrl': 'https://i.pravatar.cc/150?img=11',
      'status': UserStatus.active,
    },
    {
      'userName': 'Jane Smith',
      'userRole': 'Junior Electrician',
      'avatarUrl': 'https://i.pravatar.cc/150?img=5',
      'status': UserStatus.away,
    },
  ];

  final List<Map<String, dynamic>> _adminsData = [
    {
      'userName': 'Alice Admin',
      'userRole': 'System Administrator',
      'avatarUrl': 'https://i.pravatar.cc/150?img=1',
      'status': UserStatus.active,
    },
    {
      'userName': 'Bob Manager',
      'userRole': 'Regional Manager',
      'avatarUrl': 'https://i.pravatar.cc/150?img=13',
      'status': UserStatus.inactive,
    },
  ];

  late Map<String, UserStatus> _userStatuses;

  UserManagementViewModel() {
    _userStatuses = {};
    for (var user in _techniciansData) {
      _userStatuses[user['userName'] as String] = user['status'] as UserStatus;
    }
    for (var user in _adminsData) {
      _userStatuses[user['userName'] as String] = user['status'] as UserStatus;
    }
  }

  List<Map<String, dynamic>> get activeData =>
      _activeTabIndex == 0 ? _techniciansData : _adminsData;

  UserStatus getStatusFor(String userName) =>
      _userStatuses[userName] ?? UserStatus.active;

  void updateUserStatus(String userName, UserStatus status) {
    _userStatuses[userName] = status;
    notifyListeners();
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

  // --- Status color helpers ---
  static Color getBackgroundColor(UserStatus status) {
    switch (status) {
      case UserStatus.active:
        return AppColors.success50;
      case UserStatus.away:
        return AppColors.warning50;
      case UserStatus.inactive:
        return AppColors.secondary50;
    }
  }

  static Color getTextColor(UserStatus status) {
    switch (status) {
      case UserStatus.active:
        return AppColors.success500;
      case UserStatus.away:
        return AppColors.warning500;
      case UserStatus.inactive:
        return AppColors.secondary500;
    }
  }

  static Color getDotColor(UserStatus status) {
    switch (status) {
      case UserStatus.active:
        return AppColors.success500;
      case UserStatus.away:
        return AppColors.warning500;
      case UserStatus.inactive:
        return AppColors.secondary500;
    }
  }
}
