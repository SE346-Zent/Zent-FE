import 'package:zent_fe/presentation/common/core/safe_change_notifier.dart';
import 'package:flutter/foundation.dart';
import '../../../../domain/entities/reject_form.dart';
import '../../../../domain/usecases/work_order/get_reject_forms_usecase.dart';
import '../../../../domain/usecases/work_order/get_single_work_order_usecase.dart';
import '../../../../domain/usecases/work_order/approve_refusal_usecase.dart';
import '../../../../domain/usecases/work_order/deny_refusal_usecase.dart';
import '../../../../data/models/refuse_work_order_request.dart';

class RejectedWorkOrdersViewModel extends ChangeNotifier
    with SafeChangeNotifier {
  final GetRejectFormsUseCase getRejectFormsUseCase;
  final GetSingleWorkOrderUseCase getSingleWorkOrderUseCase;
  final ApproveRefusalUseCase approveRefusalUseCase;
  final DenyRefusalUseCase denyRefusalUseCase;

  RejectedWorkOrdersViewModel({
    required this.getRejectFormsUseCase,
    required this.getSingleWorkOrderUseCase,
    required this.approveRefusalUseCase,
    required this.denyRefusalUseCase,
  });

  List<RejectForm> _rejectForms = [];
  List<RejectForm> get rejectForms => _rejectForms;

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
      _rejectForms = await getRejectFormsUseCase.execute();
    } catch (e) {
      debugPrint('Error loading rejected work orders: $e');
    } finally {
      _isLoading = false;
      if (!_isDisposed) {
        notifyListeners();
      }
    }
  }

  Future<String?> approveRejection(RejectForm form) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Fetch the full work order to get technicianId required by approve endpoint
      final workOrder = await getSingleWorkOrderUseCase.execute(
        form.workOrderId,
      );
      await approveRefusalUseCase.execute(
        form.workOrderId,
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

  Future<String?> denyRejection(String workOrderId) async {
    _isLoading = true;
    notifyListeners();

    try {
      await denyRefusalUseCase.execute(workOrderId);
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
