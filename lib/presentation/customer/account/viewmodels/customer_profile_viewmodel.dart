import 'package:flutter/material.dart';
import 'package:zent_fe/domain/usecases/auth/get_current_user_usecase.dart';

class CustomerProfileViewModel extends ChangeNotifier {
  final GetCurrentUserUseCase getCurrentUserUseCase;

  CustomerProfileViewModel(this.getCurrentUserUseCase) {
    _loadUserInfo();
  }

  String userName = "Loading...";
  String userEmail = "";
  String? avatarUrl;

  Future<void> _loadUserInfo() async {
    try {
      final user = await getCurrentUserUseCase.execute();
      if (user != null) {
        userName = user.name;
        userEmail = user.email;
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error loading customer profile: $e");
    }
  }

  final List<Map<String, dynamic>> menuItems = [
    {
      "title": "Personal Info",
      "subtitle": "Contact details & address",
      "icon": Icons.person_outline,
    },
    {
      "title": "Security",
      "subtitle": "Password & 2FA",
      "icon": Icons.lock_outline,
    },
    {
      "title": "Notifications",
      "subtitle": "Alerts & messages",
      "icon": Icons.notifications_none,
    },
  ];
}
