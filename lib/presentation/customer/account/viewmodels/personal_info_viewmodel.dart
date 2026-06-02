import 'package:zent_fe/presentation/common/core/safe_change_notifier.dart';
import 'package:flutter/material.dart';
import 'package:zent_fe/domain/usecases/auth/get_current_user_usecase.dart';
import 'package:zent_fe/domain/usecases/auth/update_profile_usecase.dart';
import 'package:zent_fe/presentation/common/core/ui/zent_error_popup.dart';

class PersonalInfoViewModel extends ChangeNotifier with SafeChangeNotifier {
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final UpdateProfileUseCase updateProfileUseCase;

  String fullName = "";
  String emailAddress = "";
  String phoneNumber = "";
  bool isLoading = false;

  PersonalInfoViewModel(this.getCurrentUserUseCase, this.updateProfileUseCase) {
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    try {
      final user = await getCurrentUserUseCase.execute();
      if (user != null) {
        fullName = user.name;
        emailAddress = user.email;
        phoneNumber = user.phoneNumber;
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error loading personal info: $e");
    }
  }

  Future<void> saveChanges(BuildContext context) async {
    if (phoneNumber.length != 10 || !phoneNumber.startsWith('0')) {
      ZentErrorPopup.show(context, "Phone number must be 10 digits and start with 0");
      return;
    }

    try {
      isLoading = true;
      notifyListeners();

      await updateProfileUseCase.execute(
        fullName: fullName,
        phone: phoneNumber,
        email: emailAddress,
      );
    } catch (e) {
      if (context.mounted) {
        ZentErrorPopup.show(context, e.toString().replaceAll('Exception: ', ''));
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void updateFullName(String value) {
    fullName = value;
    notifyListeners();
  }

  void updateEmail(String value) {
    emailAddress = value;
    notifyListeners();
  }

  void updatePhone(String value) {
    phoneNumber = value;
    notifyListeners();
  }
}
