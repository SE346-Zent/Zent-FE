import 'package:flutter/material.dart';
import '../../../../domain/usecases/work_order/get_many_work_orders_usecase.dart';
import '../../../../domain/usecases/auth/get_current_user_usecase.dart';
import '../../../../domain/entities/work_order.dart';
import '../../../../domain/entities/enums/work_order_status.dart';
import '../../../common/core/safe_change_notifier.dart';

class ActiveRepairsViewModel extends ChangeNotifier with SafeChangeNotifier {
  final GetManyWorkOrdersUseCase getManyWorkOrdersUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;

  ActiveRepairsViewModel({
    required this.getManyWorkOrdersUseCase,
    required this.getCurrentUserUseCase,
  });

  bool isLoading = false;
  String? errorMessage;

  int currentStatusStep = 0;
  WorkOrder? activeWorkOrder;
  List<WorkOrder> recentCompleted = [];

  Future<void> fetchWorkOrders() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final orders = await getManyWorkOrdersUseCase.execute(limit: 1000);
      final customerOrders = orders;

      final activeOrders = customerOrders
          .where(
            (o) =>
                o.status == WorkOrderStatus.pending ||
                o.status == WorkOrderStatus.assigned ||
                o.status == WorkOrderStatus.rejectInReview,
          )
          .toList();

      if (activeOrders.isNotEmpty) {
        // Sort by createdAt descending to always get the newest active repair order!
        activeOrders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        activeWorkOrder = activeOrders.first;
        currentStatusStep = _mapStatusToStep(activeWorkOrder!);
      } else {
        activeWorkOrder = null;
        currentStatusStep = 0;
      }

      final completedOrders = customerOrders
          .where(
            (o) =>
                o.status == WorkOrderStatus.complete ||
                o.status == WorkOrderStatus.rejected,
          )
          .toList();
      completedOrders.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      recentCompleted = completedOrders;

      isLoading = false;
      notifyListeners();
    } catch (e) {
      errorMessage = e.toString().replaceAll('Exception: ', '');
      isLoading = false;
      notifyListeners();
    }
  }

  int _mapStatusToStep(WorkOrder order) {
    final status = order.status;

    switch (status) {
      case WorkOrderStatus.pending:
        return 1;
      case WorkOrderStatus.assigned:
      case WorkOrderStatus.rejectInReview:
        return 2; // Step 2 (Tech Assigned)
      case WorkOrderStatus.complete:
        return 4; // Step 4 (Done)
      case WorkOrderStatus.rejected:
        return 0;
    }
  }
}
