import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../routing/routes.dart';

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
        context.push(Routes.adminTeam);
        break;
      case 'Security Settings':
        context.push('/admin/security-settings');
        break;
      case 'Company Settings':
        context.push('/admin/company-settings');
        break;
      case 'System Log':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('System Log not implemented yet')),
        );
        break;
      default:
        break;
    }
  }
}
