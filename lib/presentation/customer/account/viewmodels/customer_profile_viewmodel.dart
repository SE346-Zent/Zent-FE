import 'package:flutter/material.dart';

class CustomerProfileViewModel extends ChangeNotifier {
  final String userName = "Hung dep zai";
  final String userRole = "Senior electrician";
  final String? avatarUrl = null;

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
