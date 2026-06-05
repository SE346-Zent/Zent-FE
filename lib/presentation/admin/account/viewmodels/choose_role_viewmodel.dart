import 'package:zent_fe/presentation/common/core/safe_change_notifier.dart';
import 'package:flutter/foundation.dart';
import 'package:zent_fe/domain/usecases/auth/get_current_user_usecase.dart';
import 'package:zent_fe/domain/entities/enums/user_roles.dart';

class ChooseRoleViewModel extends ChangeNotifier with SafeChangeNotifier {
  final GetCurrentUserUseCase getCurrentUserUseCase;

  String _selectedRole = 'Technicians';
  bool _canCreateAdmin = false;
  bool _isLoading = true;

  String get selectedRole => _selectedRole;
  bool get canCreateAdmin => _canCreateAdmin;
  bool get isLoading => _isLoading;

  ChooseRoleViewModel({required this.getCurrentUserUseCase}) {
    _init();
  }

  Future<void> _init() async {
    final user = await getCurrentUserUseCase.execute();
    if (user != null && user.role == UserRoles.superAdmin) {
      _canCreateAdmin = true;
    }
    _isLoading = false;
    notifyListeners();
  }

  void selectRole(String role) {
    if (_selectedRole != role) {
      _selectedRole = role;
      notifyListeners();
    }
  }
}
