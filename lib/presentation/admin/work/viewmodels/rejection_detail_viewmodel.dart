import 'package:zent_fe/presentation/common/core/safe_change_notifier.dart';
import 'package:flutter/foundation.dart';
import '../../../../domain/entities/work_order.dart';
import '../../../../domain/usecases/work_order/get_single_work_order_usecase.dart';
import '../../../../domain/usecases/work_order/approve_refusal_usecase.dart';
import '../../../../domain/usecases/work_order/deny_refusal_usecase.dart';
import '../../../../data/models/refuse_work_order_request.dart';

class RejectionDetailViewModel extends ChangeNotifier with SafeChangeNotifier {
  final GetSingleWorkOrderUseCase getSingleWorkOrderUseCase;
  final ApproveRefusalUseCase approveRefusalUseCase;
  final DenyRefusalUseCase denyRefusalUseCase;

  RejectionDetailViewModel({
    required this.getSingleWorkOrderUseCase,
    required this.approveRefusalUseCase,
    required this.denyRefusalUseCase,
  });

  WorkOrder? _workOrder;
  WorkOrder? get workOrder => _workOrder;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isApproving = false;
  bool get isApproving => _isApproving;

  bool _isDenying = false;
  bool get isDenying => _isDenying;

  bool _isDisposed = false;

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  Future<void> loadDetails(String id) async {
    _isLoading = true;
    notifyListeners();

    try {
      _workOrder = await getSingleWorkOrderUseCase.execute(id);
    } catch (e) {
      debugPrint('Error loading rejection details: $e');
    } finally {
      _isLoading = false;
      if (!_isDisposed) {
        notifyListeners();
      }
    }
  }

  Future<String?> approveRejection() async {
    if (_workOrder == null) return 'No work order data';
    _isApproving = true;
    notifyListeners();

    try {
      await approveRefusalUseCase.execute(
        _workOrder!.id,
        ApproveRefusalRequest(technicianId: _workOrder!.technicianId),
      );
      await loadDetails(_workOrder!.id);
      return null;
    } catch (e) {
      debugPrint('Error approving rejection: $e');
      return e.toString();
    } finally {
      _isApproving = false;
      if (!_isDisposed) {
        notifyListeners();
      }
    }
  }

  Future<String?> denyRejection() async {
    if (_workOrder == null) return 'No work order data';
    _isDenying = true;
    notifyListeners();

    try {
      await denyRefusalUseCase.execute(_workOrder!.id);
      await loadDetails(_workOrder!.id);
      return null;
    } catch (e) {
      debugPrint('Error denying rejection: $e');
      return e.toString();
    } finally {
      _isDenying = false;
      if (!_isDisposed) {
        notifyListeners();
      }
    }
  }
}
