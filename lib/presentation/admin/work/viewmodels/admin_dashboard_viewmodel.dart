import 'package:zent_fe/presentation/common/core/safe_change_notifier.dart';
import 'package:flutter/material.dart';
import 'package:zent_fe/di/injection_container.dart';
import 'package:zent_fe/presentation/common/auth/auth_view_model.dart';
import 'package:zent_fe/domain/usecases/auth/get_current_user_usecase.dart';
import 'package:zent_fe/domain/usecases/work_order/get_reject_forms_usecase.dart';
import 'package:zent_fe/domain/usecases/inventory/get_inventory_usecases.dart';
import 'package:zent_fe/domain/entities/reject_form.dart';
import 'package:zent_fe/domain/entities/new_part_form.dart';

class AdminDashboardViewModel extends ChangeNotifier with SafeChangeNotifier {
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final GetRejectFormsUseCase getRejectFormsUseCase;
  final GetPartRequestsUseCase getPartRequestsUseCase;

  final int _activeJobs = 120;
  final double _activeJobsTrend = 10.0;
  final double _overallRating = 4.64;
  final double _ratingTrend = -10.0;

  String get userName => sl<AuthViewModel>().currentUser?.name ?? 'Admin';
  int get activeJobs => _activeJobs;
  double get activeJobsTrend => _activeJobsTrend;
  double get overallRating => _overallRating;
  double get ratingTrend => _ratingTrend;

  List<RejectForm> _rejectedWorkOrders = [];
  List<RejectForm> get rejectedWorkOrders => _rejectedWorkOrders;

  List<NewPartForm> _partRequests = [];
  List<NewPartForm> get partRequests => _partRequests;

  bool _isLoadingData = false;
  bool get isLoadingData => _isLoadingData;

  AdminDashboardViewModel({
    required this.getCurrentUserUseCase,
    required this.getRejectFormsUseCase,
    required this.getPartRequestsUseCase,
  }) {
    _loadUserInfo();
    loadDashboardData();
  }

  Future<void> _loadUserInfo() async {
    try {
      final user = await getCurrentUserUseCase.execute();
      if (user != null) {
        sl<AuthViewModel>().setLoggedInUser(user);
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error loading admin user info: $e");
    }
  }

  Future<void> loadDashboardData() async {
    _isLoadingData = true;
    notifyListeners();

    try {
      final Future<List<RejectForm>> rejectFormsFuture = getRejectFormsUseCase
          .execute();
      final Future<(List<NewPartForm>, NewPartFormStatusSummary)>
      partRequestsFuture = getPartRequestsUseCase.execute(page: 1, limit: 100);

      final results = await Future.wait([
        rejectFormsFuture,
        partRequestsFuture,
      ]);

      final forms = results[0] as List<RejectForm>;
      final (partItems, _) =
          results[1] as (List<NewPartForm>, NewPartFormStatusSummary);

      // Sort and take the 3 most recent reject forms
      forms.sort((a, b) {
        if (a.createdAt == null && b.createdAt == null) return 0;
        if (a.createdAt == null) return 1;
        if (b.createdAt == null) return -1;
        return a.createdAt!.compareTo(b.createdAt!);
      });
      _rejectedWorkOrders = forms.take(3).toList();

      // Filter and sort part requests (pending first)
      List<NewPartForm> pendingParts = partItems
          .where((p) => p.status.toLowerCase() == 'pending')
          .toList();
      if (pendingParts.isEmpty) {
        pendingParts = partItems;
      }
      pendingParts.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      _partRequests = pendingParts.take(3).toList();
    } catch (e) {
      debugPrint("Error loading admin dashboard data: $e");
    } finally {
      _isLoadingData = false;
      notifyListeners();
    }
  }
}
