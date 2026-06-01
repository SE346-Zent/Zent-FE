import 'package:zent_fe/presentation/common/core/safe_change_notifier.dart';
import 'package:flutter/foundation.dart';
import 'package:zent_fe/di/injection_container.dart';
import 'package:zent_fe/data/repositories/work_order_repository_impl.dart';
import 'package:zent_fe/data/models/refuse_work_order_request.dart';

class AssignedWorkOrderDetailViewModel extends ChangeNotifier
    with SafeChangeNotifier {
  String _orderId = '';

  String get orderId => _orderId;

  final String techAssignedTime = '45 minutes ago';
  final String symptom = 'ABC XYZ';
  final String description =
      'ABC XYZasdfdsadffffffffffffffffffffffffasdfasdfasdfsaefe';
  final String location = '123 Hoa Binh, Quan Tan Phu, HCM';
  final String time = 'Oct 30, 2026 - 10h00 AM';

  final Map<String, dynamic> technician = {
    'id': 'TECH-9999',
    'name': 'John Doe Doe',
    'rating': 4.5,
  };

  bool _isRejectInReview =
      true; // Hardcoded for test, should be from WorkOrderModel.status
  bool get isRejectInReview => _isRejectInReview;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void initData(String id) {
    _orderId = id.startsWith('#') ? id : '#$id';
    notifyListeners();
  }

  Future<String?> approveRefusal() async {
    _isLoading = true;
    notifyListeners();
    try {
      final repo = sl<WorkOrderRepositoryImpl>();
      final cleanId = _orderId.replaceAll('#', '');
      await repo.approveRefusal(
        cleanId,
        ApproveRefusalRequest(technicianId: technician['id']),
      );
      _isRejectInReview = false;
      return null;
    } catch (e) {
      return 'Error: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> denyRefusal() async {
    _isLoading = true;
    notifyListeners();
    try {
      final repo = sl<WorkOrderRepositoryImpl>();
      final cleanId = _orderId.replaceAll('#', '');
      await repo.denyRefusal(cleanId);
      _isRejectInReview = false;
      return null;
    } catch (e) {
      return 'Error: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
