import 'package:zent_fe/presentation/common/core/safe_change_notifier.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zent_fe/domain/usecases/auth/get_current_user_usecase.dart';
import 'package:zent_fe/domain/usecases/auth/logout_usecase.dart';
import 'package:zent_fe/routing/routes.dart';
import 'package:zent_fe/presentation/customer/account/viewmodels/detailed_chat_viewmodel.dart';

class CustomerProfileViewModel extends ChangeNotifier with SafeChangeNotifier {
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final LogoutUseCase logoutUseCase;

  CustomerProfileViewModel(this.getCurrentUserUseCase, this.logoutUseCase) {
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

  Future<void> logout(BuildContext context) async {
    try {
      DetailedChatViewModel.clearCache();
      await logoutUseCase.execute();
    } catch (e) {
      final errorStr = e.toString();
      if (!errorStr.contains('400') &&
          !errorStr.toLowerCase().contains('revoked')) {
        debugPrint("Error during logout: $e");
      }
    } finally {
      if (context.mounted) {
        context.go(Routes.login);
      }
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
