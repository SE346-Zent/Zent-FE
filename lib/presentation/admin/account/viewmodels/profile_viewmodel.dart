import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:zent_fe/di/injection_container.dart';
import 'package:zent_fe/domain/repositories/auth_repository.dart';
import 'package:zent_fe/presentation/common/auth/auth_view_model.dart';
import 'package:zent_fe/presentation/common/core/safe_change_notifier.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zent_fe/routing/route_names.dart';
import 'package:zent_fe/presentation/customer/account/viewmodels/detailed_chat_viewmodel.dart';
import 'package:zent_fe/domain/usecases/auth/get_current_user_usecase.dart';
import '../../../../domain/usecases/auth/logout_usecase.dart';
import '../../../../domain/entities/enums/user_roles.dart';

class UserProfileInfo {
  final String userName;
  final String role;
  final String avatarUrl;

  UserProfileInfo({
    required this.userName,
    required this.role,
    required this.avatarUrl,
  });
}

class ProfileViewModel extends ChangeNotifier with SafeChangeNotifier {
  final LogoutUseCase logoutUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final AuthViewModel authViewModel;

  ProfileViewModel(
    this.logoutUseCase,
    this.getCurrentUserUseCase,
    this.authViewModel,
  ) {
    _loadUserInfo();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  UserProfileInfo userInfo = UserProfileInfo(
    userName: 'Loading...',
    role: '',
    avatarUrl: '',
  );

  Future<void> _loadUserInfo() async {
    try {
      final user = await getCurrentUserUseCase.execute();
      if (user != null) {
        userInfo = UserProfileInfo(
          userName: user.name,
          role: _mapRoleToDisplay(user.role),
          avatarUrl: user.avatarUrl ?? '',
        );
        authViewModel.setLoggedInUser(user);
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error loading user info: $e");
    }
  }

  bool _isPicking = false;

  Future<void> updateAvatar(BuildContext context) async {
    if (_isPicking) return;
    _isPicking = true;
    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );
      if (image == null) {
        _isPicking = false;
        return;
      }

      String uploadPath = image.path;
      final ext = uploadPath.split('.').last.toLowerCase();
      if (ext == 'heic' || ext == 'heif') {
        try {
          final bytes = await File(image.path).readAsBytes();
          final decoded = img.decodeImage(bytes);
          if (decoded != null) {
            final jpegBytes = img.encodeJpg(decoded, quality: 85);
            final tempDir = await getTemporaryDirectory();
            final newPath =
                '${tempDir.path}/avatar_${DateTime.now().millisecondsSinceEpoch}.jpg';
            await File(newPath).writeAsBytes(jpegBytes);
            uploadPath = newPath;
          }
        } catch (e) {
          debugPrint("Failed to convert HEIC image: $e");
        }
      }

      final authRepo = sl<AuthRepository>();
      await authRepo.uploadAvatar(uploadPath);
      await _loadUserInfo();
    } catch (e) {
      debugPrint("Error picking/uploading avatar: $e");
    } finally {
      _isPicking = false;
    }
  }

  String _mapRoleToDisplay(UserRoles role) {
    switch (role) {
      case UserRoles.superAdmin:
        return 'Super Admin';
      case UserRoles.admin:
        return 'Administrator';
      case UserRoles.technician:
        return 'Technician';
      case UserRoles.customer:
        return 'Customer';
      default:
        return 'User';
    }
  }

  Future<void> logout(BuildContext context) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      DetailedChatViewModel.clearCache();
      await logoutUseCase.execute();
    } catch (e) {
      final errorStr = e.toString();
      // If the session is already revoked (400), don't show an error, just proceed to logout locally
      if (!errorStr.contains('400') &&
          !errorStr.toLowerCase().contains('revoked')) {
        _errorMessage = errorStr.replaceFirst('Exception: ', '');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
      if (context.mounted) {
        context.go('/login');
      }
    }
  }

  void handleMenuTap(BuildContext context, String menuName) {
    debugPrint("action triggered: Viewmodel logic navigated to $menuName");
    switch (menuName) {
      case 'User Management':
        context.goNamed(RouteNames.adminUserManagement);
        break;
      case 'Security Settings':
        context.goNamed(RouteNames.adminSecuritySettings);
        break;
      case 'Personal Info':
        context.goNamed(RouteNames.adminPersonalInfo);
        break;
      case 'Add Part Request':
        context.goNamed(RouteNames.adminPartRequests);
        break;
      default:
        break;
    }
  }
}
