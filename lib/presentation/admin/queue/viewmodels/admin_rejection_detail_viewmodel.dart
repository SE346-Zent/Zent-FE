import 'package:flutter/material.dart';
import '../../../../domain/usecases/work_order/approve_refusal_usecase.dart';
import '../../../../domain/usecases/work_order/deny_refusal_usecase.dart';
import '../../../../domain/usecases/work_order/get_single_work_order_usecase.dart';
import '../../../../domain/entities/work_order.dart';
import '../../../../data/models/refuse_work_order_request.dart';

class AdminRejectionDetailViewModel extends ChangeNotifier {
  final ApproveRefusalUseCase approveRefusalUseCase;
  final DenyRefusalUseCase denyRefusalUseCase;
  final GetSingleWorkOrderUseCase getSingleWorkOrderUseCase;

  AdminRejectionDetailViewModel({
    required this.approveRefusalUseCase,
    required this.denyRefusalUseCase,
    required this.getSingleWorkOrderUseCase,
  });

  WorkOrder? _workOrder;
  WorkOrder? get workOrder => _workOrder;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> loadDetails(String workOrderId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _workOrder = await getSingleWorkOrderUseCase.execute(workOrderId);
    } catch (e) {
      debugPrint("Error loading rejection details: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> handleAction(String action) async {
    if (_workOrder == null) return "Work order not loaded";

    _isLoading = true;
    notifyListeners();

    try {
      if (action == 'approved') {
        // Required technicianId for reassignment.
        // For now using the same tech as placeholder, in real app Admin would pick a new one.
        final request = ApproveRefusalRequest(
          technicianId: _workOrder!.technicianId,
        );
        await approveRefusalUseCase.execute(_workOrder!.id, request);
        return null;
      } else {
        await denyRefusalUseCase.execute(_workOrder!.id);
        return null;
      }
    } catch (e) {
      return e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
