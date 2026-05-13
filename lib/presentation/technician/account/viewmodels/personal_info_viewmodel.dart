import 'package:flutter/material.dart';
import 'package:zent_fe/domain/usecases/auth/get_current_user_usecase.dart';

class TechPersonalInfoViewModel extends ChangeNotifier {
  final GetCurrentUserUseCase getCurrentUserUseCase;

  String fullName = "";
  String employeeId = 'TECH-1234';
  String email = "";
  String phoneNumber = '';
  bool isLoading = false;

  TechPersonalInfoViewModel(this.getCurrentUserUseCase) {
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    try {
      final user = await getCurrentUserUseCase.execute();
      if (user != null) {
        fullName = user.name;
        email = user.email;
        phoneNumber = user.phoneNumber;
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error loading tech personal info: $e");
    }
  }

  void saveChanges(BuildContext context) {
    debugPrint('Viewmodel logic: Saving changes (Fake data)...');

    notifyListeners();

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Successfully updated!')));
  }
}
