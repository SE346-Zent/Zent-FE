import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
  UserProfileInfo userInfo = UserProfileInfo(
    userName: 'Hung dep zai',
    role: 'Senior Electrician',
    avatarUrl: 'https://picsum.photos/200',
  );

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
