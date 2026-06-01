import 'package:zent_fe/presentation/common/core/safe_change_notifier.dart';
import 'package:flutter/material.dart';
import 'package:zent_fe/domain/usecases/auth/get_current_user_usecase.dart';

class PersonalInfoViewModel extends ChangeNotifier with SafeChangeNotifier {
  final GetCurrentUserUseCase getCurrentUserUseCase;

  String fullName = "";
  String emailAddress = "";
  String phoneNumber = "";

  PersonalInfoViewModel(this.getCurrentUserUseCase) {
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

  void saveChanges() {
    // Logic to save
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
