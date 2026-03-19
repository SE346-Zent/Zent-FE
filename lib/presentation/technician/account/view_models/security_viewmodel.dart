import 'package:flutter/material.dart';

class LoginHistoryItem {
  final String device;
  final String location;
  final String date;

  LoginHistoryItem(this.device, this.location, this.date);
}

class TechSecurityViewModel extends ChangeNotifier {
  final List<LoginHistoryItem> loginHistory = [
    LoginHistoryItem('IPhone 14 ProMax', 'San Fransico, US', 'Oct 15'),
    LoginHistoryItem('IPhone 15 ProMax', 'San Fransico, US', 'Oct 14'),
    LoginHistoryItem('IPhone 16 ProMax', 'San Fransico, US', 'Oct 10'), 
  ];

  void saveChanges(BuildContext context) {
    debugPrint('Viewmodel: Saving Security changes...');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Security changes saved!')),
    );
  }
}