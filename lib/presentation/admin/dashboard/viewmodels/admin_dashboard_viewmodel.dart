import 'package:flutter/material.dart';

class AdminDashboardViewModel extends ChangeNotifier {
  final String _userName = 'Hung dep zai';
  final int _activeJobs = 120;
  final double _activeJobsTrend = 10.0;
  final double _overallRating = 4.64;
  final double _ratingTrend = -10.0;

  String get userName => _userName;
  int get activeJobs => _activeJobs;
  double get activeJobsTrend => _activeJobsTrend;
  double get overallRating => _overallRating;
  double get ratingTrend => _ratingTrend;

  AdminDashboardViewModel();
}
