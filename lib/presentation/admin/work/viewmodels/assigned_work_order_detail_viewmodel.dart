import 'package:zent_fe/presentation/common/core/safe_change_notifier.dart';
import 'package:flutter/foundation.dart';
import 'package:zent_fe/di/injection_container.dart';
import 'package:zent_fe/domain/repositories/work_order_repository.dart';
import 'package:zent_fe/data/models/refuse_work_order_request.dart';
import 'package:intl/intl.dart';

class AssignedWorkOrderDetailViewModel extends ChangeNotifier
    with SafeChangeNotifier {
  String _orderId = '';

  String get orderId => _orderId;

  String techAssignedTime = '';
  String symptom = '';
  String description = '';
  String location = '';
  String time = '';
  String appointment = 'Not set';

  Map<String, dynamic> technician = {
    'id': 'TECH-9999',
    'name': 'Unknown Tech',
    'rating': 5.0,
  };

  bool _isRejectInReview = false;
  bool get isRejectInReview => _isRejectInReview;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> initData(String id) async {
    _orderId = id.startsWith('#') ? id : '#$id';
    _isLoading = true;
    notifyListeners();

    try {
      final repo = sl<WorkOrderRepository>();
      final cleanId = id.replaceAll('#', '');

      final workOrder = await repo.getWorkOrderDetail(id: cleanId);

      symptom = workOrder.symptomName ?? 'N/A';
      description = workOrder.description;
      location = workOrder.addressString;

      time = DateFormat(
        'MMM dd, yyyy - hh:mm a',
      ).format(workOrder.createdAt.toLocal());
      techAssignedTime = DateFormat(
        'MMM dd, hh:mm a',
      ).format(workOrder.updatedAt.toLocal());
      if (workOrder.appointment != null) {
        appointment = DateFormat(
          'MMM dd, yyyy - hh:mm a',
        ).format(workOrder.appointment!.toLocal());
      } else {
        appointment = 'Not set';
      }
      final backendStatus = workOrder.status.name;
      _isRejectInReview = backendStatus == 'rejectInReview';

      final techs = await repo.getTechnicians();
      final tech = techs.firstWhere(
        (t) => t['id'] == workOrder.technicianId,
        orElse: () => <String, dynamic>{},
      );

      technician = {
        'id': workOrder.technicianId,
        'name':
            (workOrder.technicianName != null &&
                workOrder.technicianName!.isNotEmpty)
            ? workOrder.technicianName
            : (tech['fullName'] ?? tech['name'] ?? 'Tech (ID: ${workOrder.technicianId.substring(0, 4)})'),
        'rating': tech.isNotEmpty
            ? (tech['averageRating'] ?? tech['rating'] ?? 0.0)
            : (workOrder.technicianRating ?? 0.0),
      };
    } catch (e) {
      debugPrint("Lỗi lấy chi tiết đơn hàng: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> approveRefusal() async {
    _isLoading = true;
    notifyListeners();
    try {
      final repo = sl<WorkOrderRepository>();
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
      final repo = sl<WorkOrderRepository>();
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
