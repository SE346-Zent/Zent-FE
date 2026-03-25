import 'package:flutter/material.dart';
import 'package:zent_fe/domain/entities/enums/account_status.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';

class UserManagementViewModel extends ChangeNotifier {
  int _activeTabIndex = 0;
  int get activeTabIndex => _activeTabIndex;

  final List<Map<String, dynamic>> _techniciansData = [
    {
      'userName': 'John Doe',
      'userRole': 'Senior Electrician',
      'avatarUrl': 'https://i.pravatar.cc/150?img=11',
      'status': AccountStatus.active,
    },
    {
      'userName': 'Jane Smith',
      'userRole': 'Junior Electrician',
      'avatarUrl': 'https://i.pravatar.cc/150?img=5',
      'status': AccountStatus.away,
    },
  ];

  final List<Map<String, dynamic>> _adminsData = [
    {
      'userName': 'Alice Admin',
      'userRole': 'System Administrator',
      'avatarUrl': 'https://i.pravatar.cc/150?img=1',
      'status': AccountStatus.active,
    },
    {
      'userName': 'Bob Manager',
      'userRole': 'Regional Manager',
      'avatarUrl': 'https://i.pravatar.cc/150?img=13',
      'status': AccountStatus.inactive,
    },
  ];

  late Map<String, AccountStatus> _userStatuses;

  UserManagementViewModel() {
    _userStatuses = {};
    for (var user in _techniciansData) {
      _userStatuses[user['userName'] as String] = user['status'] as AccountStatus;
    }
    for (var user in _adminsData) {
      _userStatuses[user['userName'] as String] = user['status'] as AccountStatus;
    }
  }

  List<Map<String, dynamic>> get activeData =>
      _activeTabIndex == 0 ? _techniciansData : _adminsData;

  AccountStatus getStatusFor(String userName) =>
      _userStatuses[userName] ?? AccountStatus.active;

  void updateUserStatus(String userName, AccountStatus status) {
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
  static Color getBackgroundColor(AccountStatus status) {
    switch (status) {
      case AccountStatus.active:
        return AppColors.success50;
      case AccountStatus.away:
        return AppColors.warning50;
      case AccountStatus.inactive:
        return AppColors.secondary50;
      case AccountStatus.terminated:
        return AppColors.error50;
      case AccountStatus.pending:
        return AppColors.tertiary50;
    }
  }

  static Color getTextColor(AccountStatus status) {
    switch (status) {
      case AccountStatus.active:
        return AppColors.success500;
      case AccountStatus.away:
        return AppColors.warning500;
      case AccountStatus.inactive:
        return AppColors.secondary500;
      case AccountStatus.terminated:
        return AppColors.error500;
      case AccountStatus.pending:
        return AppColors.tertiary500;
    }
  }

  static Color getDotColor(AccountStatus status) {
    switch (status) {
      case AccountStatus.active:
        return AppColors.success500;
      case AccountStatus.away:
        return AppColors.warning500;
      case AccountStatus.inactive:
        return AppColors.secondary500;
      case AccountStatus.terminated:
        return AppColors.error500;
      case AccountStatus.pending:
        return AppColors.tertiary500;
    }
  }
}
