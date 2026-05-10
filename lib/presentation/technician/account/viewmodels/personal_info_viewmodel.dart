import 'package:flutter/material.dart';

class TechPersonalInfoViewModel extends ChangeNotifier {
  String fullName = 'Hung dep zai';
  String employeeId = 'TECH-1234';
  String email = 'hungdepzai@zent.com';
  String phoneNumber = '1235578';

  bool isLoading = false;

  void saveChanges(BuildContext context) {
    debugPrint('Viewmodel logic: Saving changes (Fake data)...');

    notifyListeners();

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Successfully updated!')));
  }
}
