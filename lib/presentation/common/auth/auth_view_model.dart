import 'package:zent_fe/presentation/common/core/safe_change_notifier.dart';
import 'package:flutter/material.dart';
import 'package:zent_fe/domain/entities/user.dart';
import 'package:zent_fe/domain/entities/enums/user_roles.dart';

class AuthViewModel extends ChangeNotifier with SafeChangeNotifier {
  User? _currentUser;
  User? get currentUser => _currentUser;

  bool get isLoggedIn => _currentUser != null;

  UserRoles get role => _currentUser?.role ?? UserRoles.unauthenticated;

  void setLoggedInUser(User user) {
    _currentUser = user;
    notifyListeners();
  }

  void clearUser() {
    _currentUser = null;
    notifyListeners();
  }
}
