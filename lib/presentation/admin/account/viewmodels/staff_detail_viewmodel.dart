import 'package:flutter/material.dart';
import 'package:zent_fe/domain/entities/user.dart';
import 'package:zent_fe/domain/repositories/auth_repository.dart';
import 'package:zent_fe/presentation/common/core/safe_change_notifier.dart';

class StaffDetailViewModel extends ChangeNotifier with SafeChangeNotifier {
  final AuthRepository authRepository;
  final String userId;

  User? staffUser;
  bool isLoading = false;
  bool isActionLoading = false;
  String errorMsg = "";

  // Get performance metrics dynamically from real ratingCounts
  Map<String, double> get performanceRatings {
    final counts = staffUser?.ratingCounts;
    if (counts == null || counts.isEmpty) {
      return {
        'Excellent': 0.0,
        'Good': 0.0,
        'Normal': 0.0,
        'Bad': 0.0,
        'Terrible': 0.0,
      };
    }
    final double r5 = (counts['5'] ?? 0).toDouble();
    final double r4 = (counts['4'] ?? 0).toDouble();
    final double r3 = (counts['3'] ?? 0).toDouble();
    final double r2 = (counts['2'] ?? 0).toDouble();
    final double r1 = (counts['1'] ?? 0).toDouble();

    final total = r5 + r4 + r3 + r2 + r1;
    if (total == 0) {
      return {
        'Excellent': 0.0,
        'Good': 0.0,
        'Normal': 0.0,
        'Bad': 0.0,
        'Terrible': 0.0,
      };
    }

    return {
      'Excellent': r5 / total,
      'Good': r4 / total,
      'Normal': r3 / total,
      'Bad': r2 / total,
      'Terrible': r1 / total,
    };
  }

  StaffDetailViewModel({
    required this.authRepository,
    required this.userId,
  }) {
    fetchStaffDetails();
  }

  Future<void> fetchStaffDetails() async {
    try {
      isLoading = true;
      errorMsg = "";
      notifyListeners();

      final users = await authRepository.getUsers(pageSize: 100);
      final index = users.indexWhere((u) => u.id == userId);
      if (index != -1) {
        staffUser = users[index];
      } else {
        errorMsg = "Staff member not found";
      }
    } catch (e) {
      errorMsg = e.toString();
      debugPrint("Error fetching staff details: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> disableAccount() async {
    try {
      isActionLoading = true;
      notifyListeners();

      await authRepository.updateUserStatus(userId, 4); // 4 = Inactive
      return true;
    } catch (e) {
      debugPrint("Error disabling account: $e");
      return false;
    } finally {
      isActionLoading = false;
      notifyListeners();
    }
  }
}
