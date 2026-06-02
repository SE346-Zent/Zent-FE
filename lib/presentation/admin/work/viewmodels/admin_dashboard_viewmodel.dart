import 'package:zent_fe/presentation/common/core/safe_change_notifier.dart';
import 'package:flutter/material.dart';
import 'package:zent_fe/di/injection_container.dart';
import 'package:zent_fe/presentation/common/auth/auth_view_model.dart';

class AdminDashboardViewModel extends ChangeNotifier with SafeChangeNotifier {
  final int _activeJobs = 120;
  final double _activeJobsTrend = 10.0;
  final double _overallRating = 4.64;
  final double _ratingTrend = -10.0;

  String get userName => sl<AuthViewModel>().currentUser?.name ?? 'Admin';
  int get activeJobs => _activeJobs;
  double get activeJobsTrend => _activeJobsTrend;
  double get overallRating => _overallRating;
  double get ratingTrend => _ratingTrend;

  AdminDashboardViewModel();
}
