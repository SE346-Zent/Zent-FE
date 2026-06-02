import 'package:zent_fe/presentation/common/core/safe_change_notifier.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zent_fe/presentation/customer/account/viewmodels/detailed_chat_viewmodel.dart';
import 'package:zent_fe/domain/usecases/auth/get_current_user_usecase.dart';
import '../../../../domain/usecases/auth/logout_usecase.dart';
import '../../../../domain/entities/enums/user_roles.dart';

class UserProfileInfo {
  final String userName;
  final String role;
  final String avatarUrl;

  UserProfileInfo({
    required this.userName,
    required this.role,
    required this.avatarUrl,
  });
}

class ProfileViewModel extends ChangeNotifier with SafeChangeNotifier {
  final LogoutUseCase logoutUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;

  ProfileViewModel(this.logoutUseCase, this.getCurrentUserUseCase) {
    _loadUserInfo();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  UserProfileInfo userInfo = UserProfileInfo(
    userName: 'Loading...',
    role: '',
    avatarUrl: 'https://picsum.photos/200',
  );

  Future<void> _loadUserInfo() async {
    try {
      final user = await getCurrentUserUseCase.execute();
      if (user != null) {
        userInfo = UserProfileInfo(
          userName: user.name,
          role: _mapRoleToDisplay(user.role),
          avatarUrl: 'https://picsum.photos/200',
        );
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error loading user info: $e");
    }
  }

  String _mapRoleToDisplay(UserRoles role) {
    switch (role) {
      case UserRoles.admin:
        return 'Administrator';
      case UserRoles.technician:
        return 'Technician';
      case UserRoles.customer:
        return 'Customer';
      default:
        return 'User';
    }
  }

  Future<void> logout(BuildContext context) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      DetailedChatViewModel.clearCache();
      await logoutUseCase.execute();
    } catch (e) {
      final errorStr = e.toString();
      // If the session is already revoked (400), don't show an error, just proceed to logout locally
      if (!errorStr.contains('400') &&
          !errorStr.toLowerCase().contains('revoked')) {
        _errorMessage = errorStr.replaceFirst('Exception: ', '');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
      if (context.mounted) {
        context.go('/login');
      }
    }
  }

  void handleMenuTap(BuildContext context, String menuName) {
    debugPrint("action triggered: Viewmodel logic navigated to $menuName");
    switch (menuName) {
      case 'User Management':
        context.goNamed('adminUserManagement');
        break;
      case 'Security Settings':
        context.goNamed('adminSecuritySettings');
        break;
      case 'Add Part Request':
        context.goNamed('adminPartRequests');
        break;
      case 'Available Roles':
        context.goNamed('adminAvailableRoles');
        break;
      case 'Inventory Assets':
        context.goNamed('adminInventoryAssets');
        break;
      default:
        break;
    }
  }
}
