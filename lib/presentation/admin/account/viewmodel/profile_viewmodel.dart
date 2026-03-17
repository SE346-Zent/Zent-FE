import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
  UserProfileInfo userInfo = UserProfileInfo(
    userName: 'Hung dep zai',
    role: 'Super Admin',
    avatarUrl: 'https://picsum.photos/200',
  );

  void logout() {
    debugPrint("action triggered: Viewmodel logic logout");
  }

  void handleMenuTap(BuildContext context, String menuName) {
    debugPrint("action triggered: Viewmodel logic navigated to $menuName");
    switch (menuName) {
      case 'User Management':
        context.goNamed('userManagement');
        break;
      case 'Security Settings':
        context.goNamed('securitySettings');
        break;
      case 'System Log':
        context.goNamed('systemLog');
        break;
      default:
        break;
    }
  }
}
