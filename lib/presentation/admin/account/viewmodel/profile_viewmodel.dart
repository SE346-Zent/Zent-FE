import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../routing/routes.dart';
import '../../../../domain/usecases/auth/logout_usecase.dart';

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

class ProfileViewModel extends ChangeNotifier {
  final LogoutUseCase logoutUseCase;

  ProfileViewModel(this.logoutUseCase);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  UserProfileInfo userInfo = UserProfileInfo(
    userName: 'Hung dep zai',
    role: 'Super Admin',
    avatarUrl: 'https://picsum.photos/200',
  );

  Future<void> logout() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await logoutUseCase.execute();
      // Logic for navigation after logout is usually handled by the router
      // listening to the repository or token store changes.
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void handleMenuTap(BuildContext context, String menuName) {
    debugPrint("action triggered: Viewmodel logic navigated to $menuName");
    switch (menuName) {
      case 'User Management':
        context.push(Routes.userManagement);
        break;
      case 'Security Settings':
        context.push(Routes.securitySettings);
        break;
      case 'System Log':
        context.push(Routes.systemLog);
        break;
      default:
        break;
    }
  }
}
