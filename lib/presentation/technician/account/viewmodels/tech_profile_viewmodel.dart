import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zent_fe/domain/usecases/auth/get_current_user_usecase.dart';
import 'package:zent_fe/routing/routes.dart';

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

class TechProfileViewModel extends ChangeNotifier {
  final GetCurrentUserUseCase getCurrentUserUseCase;

  TechProfileViewModel(this.getCurrentUserUseCase) {
    _loadUserInfo();
  }

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
          role: 'Technician', // Or map from user.role
          avatarUrl: 'https://picsum.photos/200',
        );
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error loading tech profile: $e");
    }
  }

  void handleMenuTap(BuildContext context, String menuName) {
    debugPrint("action triggered: Viewmodel logic navigated to $menuName");

    switch (menuName) {
      case 'Personal Info':
        context.push('${Routes.techMe}/${Routes.personalInfo}');
        break;

      case 'Help me':
        // Add Route for Help
        break;

      case 'Security':
        context.push('${Routes.techMe}/${Routes.techSecuritySettings}');
        break;

      case 'Notifications':
        context.push('${Routes.techMe}/${Routes.notifications}');
        break;

      default:
        break;
    }
  }
}
