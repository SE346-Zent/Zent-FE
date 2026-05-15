import 'package:flutter/material.dart';
import '../../../../domain/usecases/work_order/get_many_work_orders_usecase.dart';
import '../../../../domain/usecases/auth/get_current_user_usecase.dart';
import '../../../../domain/entities/work_order.dart';
import '../../../../domain/entities/enums/work_order_status.dart';

class ActiveRepairsViewModel extends ChangeNotifier {
  final GetManyWorkOrdersUseCase getManyWorkOrdersUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;

  ActiveRepairsViewModel({
    required this.getManyWorkOrdersUseCase,
    required this.getCurrentUserUseCase,
  });

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<WorkOrder> _activeWorkOrders = [];
  List<WorkOrder> get activeWorkOrders => _activeWorkOrders;

  List<WorkOrder> _completedWorkOrders = [];
  List<WorkOrder> get completedWorkOrders => _completedWorkOrders;

  // For the tracking card (singular)
  WorkOrder? get currentTrackingOrder =>
      _activeWorkOrders.isNotEmpty ? _activeWorkOrders.first : null;

  int get currentStatusStep {
    final order = currentTrackingOrder;
    if (order == null) return 0;
    // Map status to 1-3 steps for the UI
    return switch (order.status) {
      WorkOrderStatus.pending => 1,
      WorkOrderStatus.inProg => 2,
      WorkOrderStatus.complete => 3,
      _ => 1,
    };
  }

  Future<void> fetchWorkOrders() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await getCurrentUserUseCase.execute();
      if (user == null) throw Exception("User not found");

      final results = await getManyWorkOrdersUseCase.execute(
        user.id,
        role: 'customer',
      );

      // The server already filters work orders by the user's token identity.
      // We rely on backend-side authorization for security and privacy.
      final myWorkOrders = results;

      _activeWorkOrders = myWorkOrders
          .where(
            (wo) =>
                wo.status != WorkOrderStatus.complete &&
                wo.status != WorkOrderStatus.rejected,
          )
          .toList();

      _completedWorkOrders = myWorkOrders
          .where((wo) => wo.status == WorkOrderStatus.complete)
          .toList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
}
