import 'package:zent_fe/presentation/common/core/safe_change_notifier.dart';
import 'package:flutter/foundation.dart';
import '../../../../domain/entities/work_order.dart';
import '../../../../domain/entities/enums/work_order_status.dart';
import '../../../../domain/usecases/work_order/get_many_work_orders_usecase.dart';
import '../../../../domain/usecases/work_order/approve_refusal_usecase.dart';
import '../../../../domain/usecases/work_order/deny_refusal_usecase.dart';
import '../../../../data/models/refuse_work_order_request.dart';

class RejectedWorkOrdersViewModel extends ChangeNotifier
    with SafeChangeNotifier {
  final GetManyWorkOrdersUseCase getManyWorkOrdersUseCase;
  final ApproveRefusalUseCase approveRefusalUseCase;
  final DenyRefusalUseCase denyRefusalUseCase;

  RejectedWorkOrdersViewModel({
    required this.getManyWorkOrdersUseCase,
    required this.approveRefusalUseCase,
    required this.denyRefusalUseCase,
  });

  List<WorkOrder> _workOrders = [];
  List<WorkOrder> get workOrders => _workOrders;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isDisposed = false;

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  Future<void> loadRejectedWorkOrders() async {
    _isLoading = true;
    notifyListeners();

    try {
      final allOrders = await getManyWorkOrdersUseCase.execute(limit: 100);
      _workOrders = allOrders
          .where((wo) => wo.status == WorkOrderStatus.rejectInReview)
          .toList();
    } catch (e) {
      debugPrint('Error loading rejected work orders: $e');
    } finally {
      _isLoading = false;
      if (!_isDisposed) {
        notifyListeners();
      }
    }
  }

  Future<String?> approveRejection(WorkOrder workOrder) async {
    _isLoading = true;
    notifyListeners();

    try {
      await approveRefusalUseCase.execute(
        workOrder.id,
        ApproveRefusalRequest(technicianId: workOrder.technicianId),
      );
      await loadRejectedWorkOrders();
      return null;
    } catch (e) {
      debugPrint('Error approving rejection: $e');
      _isLoading = false;
      if (!_isDisposed) {
        notifyListeners();
      }
      return e.toString();
    }
  }

  Future<String?> denyRejection(String id) async {
    _isLoading = true;
    notifyListeners();

    try {
      await denyRefusalUseCase.execute(id);
      await loadRejectedWorkOrders();
      return null;
    } catch (e) {
      debugPrint('Error denying rejection: $e');
      _isLoading = false;
      if (!_isDisposed) {
        notifyListeners();
      }
      return e.toString();
    }
  }
}
