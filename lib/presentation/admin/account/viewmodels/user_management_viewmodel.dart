import 'package:zent_fe/presentation/common/core/safe_change_notifier.dart';
import 'package:flutter/material.dart';
import 'package:zent_fe/di/injection_container.dart';
import 'package:zent_fe/domain/entities/enums/account_status.dart';
import 'package:zent_fe/domain/entities/enums/user_roles.dart';
import 'package:zent_fe/domain/entities/user.dart';
import 'package:zent_fe/domain/usecases/user/get_users_usecase.dart';
import 'package:zent_fe/presentation/common/auth/auth_view_model.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';

class UserManagementViewModel extends ChangeNotifier with SafeChangeNotifier {
  final GetUsersUseCase getUsersUseCase;

  UserManagementViewModel({required this.getUsersUseCase}) {
    _fetchUsers();
  }

  int _activeTabIndex = 0;
  int get activeTabIndex => _activeTabIndex;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<User> _technicians = [];
  List<User> _admins = [];

  /// True only when the logged-in role is SuperAdmin (reserved for future).
  bool get isSuperAdmin =>
      sl<AuthViewModel>().currentUser?.role == UserRoles.superAdmin;

  /// Show both Technician + Admin tabs (only for SuperAdmin).
  bool get showBothTabs => isSuperAdmin;

  /// Active user list based on current role and tab selection.
  /// Admin → sees only Technicians.
  /// Technician → sees only Technicians (self-view).
  /// SuperAdmin → can switch between Technicians and Admin tabs.
  List<User> get activeUsers {
    if (!showBothTabs) return _technicians;
    return _activeTabIndex == 0 ? _technicians : _admins;
  }

  /// Map userId -> AccountStatus
  final Map<String, AccountStatus> _userStatuses = {};

  Future<void> _fetchUsers() async {
    _isLoading = true;
    notifyListeners();

    try {
      final allUsers = await getUsersUseCase.execute(pageSize: 100);

      _technicians = allUsers
          .where((u) => u.role == UserRoles.technician)
          .toList();

      _admins = allUsers
          .where((u) => u.role == UserRoles.admin || u.role == UserRoles.superAdmin)
          .toList();

      _userStatuses.clear();
      for (final user in [..._technicians, ..._admins]) {
        _userStatuses[user.id] = user.status;
      }
    } catch (e) {
      debugPrint('Error fetching users: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  AccountStatus getStatusForUser(String userId) =>
      _userStatuses[userId] ?? AccountStatus.active;

  void updateUserStatus(String userId, AccountStatus status) {
    _userStatuses[userId] = status;
    notifyListeners();
  }

  void changeTab(int index) {
    if (_activeTabIndex != index) {
      _activeTabIndex = index;
      notifyListeners();
    }
  }

  void addUser() {
    debugPrint("action triggered: Viewmodel logic addUser");
  }

  void editUser(int index) {
    debugPrint("action triggered: Viewmodel logic editUser for user $index");
  }

  void refreshData() {
    _fetchUsers();
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
