import 'package:flutter/material.dart';

class PersonalInfoViewModel extends ChangeNotifier {
  String fullName = "Hung dep zai";
  String employeeId = "TECH-1234";
  String emailAddress = "hungdepzai@zent.com";
  String phoneNumber = "1235578";

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
