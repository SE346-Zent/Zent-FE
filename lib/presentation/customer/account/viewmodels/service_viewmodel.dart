import 'package:flutter/material.dart';

class ServiceViewModel extends ChangeNotifier {
  final String userName = "Zent";
  final String? avatarUrl = null;

  final List<Map<String, dynamic>> serviceActions = [
    {
      "title": "My Products",
      "subtitle": "Manage registered devices and check warranties",
      "icon": Icons.inventory_2_outlined,
    },
    {
      "title": "Request Service",
      "subtitle": "Open a new repair or maintenance ticket",
      "icon": Icons.build_outlined,
    },
    {
      "title": "Active Repairs",
      "subtitle": "Track ongoing work orders and status updates",
      "icon": Icons.local_shipping_outlined,
    },
  ];
}
