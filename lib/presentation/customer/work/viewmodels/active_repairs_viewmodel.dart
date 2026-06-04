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

  Future<void> fetchWorkOrders({String? workOrderId}) async {
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

      if (workOrderId != null && workOrderId.isNotEmpty) {
        // If a specific workOrderId was requested, find it from the entire list first
        try {
          activeWorkOrder = customerOrders.firstWhere(
            (o) => o.id == workOrderId,
          );
          currentStatusStep = _mapStatusToStep(activeWorkOrder!);
        } catch (_) {
          activeWorkOrder = null;
        }
      } else {
        if (activeOrders.isNotEmpty) {
          activeOrders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          activeWorkOrder = activeOrders.first;
          currentStatusStep = _mapStatusToStep(activeWorkOrder!);
        } else {
          activeWorkOrder = null;
          currentStatusStep = 0;
        }
      }

      final otherActiveOrders = customerOrders
          .where(
            (o) =>
                (o.status == WorkOrderStatus.pending ||
                    o.status == WorkOrderStatus.assigned ||
                    o.status == WorkOrderStatus.rejectInReview) &&
                o.id != activeWorkOrder?.id,
          )
          .toList();
      otherActiveOrders.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      recentCompleted = otherActiveOrders;

      isLoading = false;
      notifyListeners();
    } catch (e) {
      errorMessage = e.toString().replaceAll('Exception: ', '');
      isLoading = false;
      notifyListeners();
    }
  }

  void selectActiveWorkOrder(WorkOrder selected) {
    if (activeWorkOrder == null) {
      activeWorkOrder = selected;
      currentStatusStep = _mapStatusToStep(selected);
      recentCompleted.removeWhere((o) => o.id == selected.id);
    } else {
      final previousActive = activeWorkOrder!;
      activeWorkOrder = selected;
      currentStatusStep = _mapStatusToStep(selected);

      recentCompleted.removeWhere((o) => o.id == selected.id);
      if (!recentCompleted.any((o) => o.id == previousActive.id)) {
        recentCompleted.add(previousActive);
      }

      recentCompleted.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }
    notifyListeners();
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
