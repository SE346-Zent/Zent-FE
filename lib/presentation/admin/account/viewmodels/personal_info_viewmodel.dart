import 'package:flutter/material.dart';
import 'package:zent_fe/presentation/common/core/safe_change_notifier.dart';
import 'package:zent_fe/domain/usecases/auth/get_current_user_usecase.dart';
import 'package:zent_fe/domain/usecases/auth/update_profile_usecase.dart';
import 'package:zent_fe/presentation/common/auth/auth_view_model.dart';
import 'package:zent_fe/presentation/common/core/ui/zent_error_popup.dart';
import 'package:zent_fe/di/injection_container.dart';

import 'package:zent_fe/domain/entities/enums/user_roles.dart';

class AdminPersonalInfoViewModel extends ChangeNotifier
    with SafeChangeNotifier {
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final UpdateProfileUseCase updateProfileUseCase;

  String fullName = "";
  String adminId = 'ADMIN-1234';
  String email = "";
  String phoneNumber = '';
  String? avatarUrl;
  UserRoles role = UserRoles.admin;
  bool isLoading = false;

  AdminPersonalInfoViewModel({
    required this.getCurrentUserUseCase,
    required this.updateProfileUseCase,
  }) {
    loadAdminInfo();
  }

  Future<void> loadAdminInfo() async {
    try {
      final user = await getCurrentUserUseCase.execute();
      if (user != null) {
        fullName = user.name;
        email = user.email;
        phoneNumber = user.phoneNumber;
        avatarUrl = user.avatarUrl;
        role = user.role;
        final rawId = user.employeeId ?? user.id;
        adminId = rawId.length > 10
            ? rawId.substring(0, 10).toUpperCase()
            : rawId.toUpperCase();

        sl<AuthViewModel>().setLoggedInUser(user);
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error loading admin personal info: $e");
    }
  }

  Future<bool> saveChanges(BuildContext context) async {
    if (phoneNumber.length != 10 || !phoneNumber.startsWith('0')) {
      ZentErrorPopup.show(
        context,
        "Phone number must be 10 digits and start with 0",
      );
      return false;
    }

    try {
      isLoading = true;
      notifyListeners();

      await updateProfileUseCase.execute(
        fullName: fullName,
        phone: phoneNumber,
        email: email,
      );

      // Fetch the updated user profile from local cache and refresh AuthViewModel
      final updatedUser = await getCurrentUserUseCase.execute();
      if (updatedUser != null) {
        sl<AuthViewModel>().setLoggedInUser(updatedUser);
      }
      return true;
    } catch (e) {
      if (context.mounted) {
        ZentErrorPopup.show(
          context,
          e.toString().replaceAll('Exception: ', ''),
        );
      }
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
