import 'package:zent_fe/presentation/common/core/safe_change_notifier.dart';
import 'package:flutter/material.dart';
import 'package:zent_fe/di/injection_container.dart';
import 'package:zent_fe/presentation/common/auth/auth_view_model.dart';

import 'package:zent_fe/domain/usecases/auth/get_current_user_usecase.dart';

class ServiceViewModel extends ChangeNotifier with SafeChangeNotifier {
  final GetCurrentUserUseCase? getCurrentUserUseCase;

  ServiceViewModel({this.getCurrentUserUseCase}) {
    _initUser();
  }

  String? _fetchedUserName;
  String get userName =>
      _fetchedUserName ?? sl<AuthViewModel>().currentUser?.name ?? 'Customer';

  // When backend adds avatar_url to User entity, use: sl<AuthViewModel>().currentUser?.avatarUrl
  String? get avatarUrl => null;

  Future<void> _initUser() async {
    try {
      final user = await getCurrentUserUseCase?.execute();
      if (user != null) {
        _fetchedUserName = user.name.isNotEmpty ? user.name : user.email;
        if (sl<AuthViewModel>().currentUser == null) {
          sl<AuthViewModel>().setLoggedInUser(user);
        }
        notifyListeners();
      }
    } catch (_) {}
  }

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
