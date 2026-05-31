import 'package:zent_fe/presentation/common/core/safe_change_notifier.dart';
import 'package:flutter/material.dart';

class ServiceViewModel extends ChangeNotifier with SafeChangeNotifier {
  final String userName = "Zent";
  final String? avatarUrl = null;

  final List<Map<String, dynamic>> serviceActions = [
    {
      "title": "My Products",
      "subtitle": "Manage registered devices and check warranties",
      "icon": Icons.inventory_2_outlined,
      "routeName": "customerMyProducts",
    },
    {
      "title": "Request Service",
      "subtitle": "Open a new repair or maintenance ticket",
      "icon": Icons.build_outlined,
      "routeName": "customerRequestService",
    },
    {
      "title": "Active Repairs",
      "subtitle": "Track ongoing work orders and status updates",
      "icon": Icons.local_shipping_outlined,
      "routeName": "customerActiveRepairs",
    },
    {
      "title": "Work Order History",
      "subtitle": "Find all my created work orders",
      "icon": Icons.history,
      "routeName": "customerWorkOrderHistory",
    },
  ];
}
