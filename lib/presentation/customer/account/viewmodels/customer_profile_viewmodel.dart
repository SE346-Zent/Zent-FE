import 'dart:io';
import 'package:zent_fe/presentation/common/core/safe_change_notifier.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:zent_fe/di/injection_container.dart';
import 'package:zent_fe/domain/repositories/auth_repository.dart';
import 'package:zent_fe/domain/usecases/auth/get_current_user_usecase.dart';
import 'package:zent_fe/domain/usecases/auth/logout_usecase.dart';
import 'package:zent_fe/routing/routes.dart';
import 'package:zent_fe/presentation/common/auth/auth_view_model.dart';
import 'package:zent_fe/presentation/customer/account/viewmodels/detailed_chat_viewmodel.dart';

class CustomerProfileViewModel extends ChangeNotifier with SafeChangeNotifier {
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final LogoutUseCase logoutUseCase;
  final AuthViewModel authViewModel;

  CustomerProfileViewModel(
    this.getCurrentUserUseCase,
    this.logoutUseCase,
    this.authViewModel,
  ) {
    _loadUserInfo();
  }

  String userName = "Loading...";
  String userEmail = "";
  String? avatarUrl;

  Future<void> _loadUserInfo() async {
    try {
      final user = await getCurrentUserUseCase.execute();
      if (user != null) {
        userName = user.name;
        userEmail = user.email;
        avatarUrl = user.avatarUrl;
        authViewModel.setLoggedInUser(user);
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error loading customer profile: $e");
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

  Future<void> closeAccount(BuildContext context) async {
    try {
      DetailedChatViewModel.clearCache();
      await sl<AuthRepository>().closeAccount();
    } catch (e) {
      debugPrint("Error closing account: $e");
    } finally {
      if (context.mounted) {
        context.go(Routes.login);
      }
    }
  }

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
