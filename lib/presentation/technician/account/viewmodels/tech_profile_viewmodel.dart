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
import 'package:zent_fe/domain/usecases/auth/get_current_user_usecase.dart';
import 'package:zent_fe/domain/usecases/auth/logout_usecase.dart';
import 'package:zent_fe/routing/routes.dart';
import 'package:zent_fe/presentation/customer/account/viewmodels/detailed_chat_viewmodel.dart';

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

class TechProfileViewModel extends ChangeNotifier with SafeChangeNotifier {
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final LogoutUseCase logoutUseCase;
  final AuthViewModel authViewModel;

  TechProfileViewModel(
    this.getCurrentUserUseCase,
    this.logoutUseCase,
    this.authViewModel,
  ) {
    _loadUserInfo();
  }

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
          role: 'Technician', // Or map from user.role
          avatarUrl: user.avatarUrl ?? '',
        );
        authViewModel.setLoggedInUser(user);
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error loading tech profile: $e");
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

  Future<void> logout(BuildContext context) async {
    try {
      DetailedChatViewModel.clearCache();
      await logoutUseCase.execute();
    } catch (e) {
      final errorStr = e.toString();
      if (!errorStr.contains('400') &&
          !errorStr.toLowerCase().contains('revoked')) {
        debugPrint("Error during logout: $e");
      }
    } finally {
      if (context.mounted) {
        context.go(Routes.login);
      }
    }
  }

  void handleMenuTap(BuildContext context, String menuName) {
    debugPrint("action triggered: Viewmodel logic navigated to $menuName");

    switch (menuName) {
      case 'Personal Info':
        context.push('${Routes.techMe}/${Routes.personalInfo}');
        break;

      case 'Help me':
        // Add Route for Help
        break;

      case 'Security':
        context.push('${Routes.techMe}/${Routes.techSecuritySettings}');
        break;

      default:
        break;
    }
  }
}
