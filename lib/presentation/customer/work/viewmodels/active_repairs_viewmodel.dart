import 'package:flutter/material.dart';
import '../../../../domain/usecases/work_order/get_many_work_orders_usecase.dart';
import '../../../../domain/entities/work_order.dart';
import '../../../../domain/entities/enums/work_order_status.dart';
import '../../../common/core/safe_change_notifier.dart';

class ActiveRepairsViewModel extends ChangeNotifier with SafeChangeNotifier {
  final GetManyWorkOrdersUseCase getManyWorkOrdersUseCase;

  ActiveRepairsViewModel({required this.getManyWorkOrdersUseCase});

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

      final activeOrders = orders
          .where(
            (o) =>
                o.status == WorkOrderStatus.pending ||
                o.status == WorkOrderStatus.assigned ||
                o.status == WorkOrderStatus.rejectInReview,
          )
          .toList();

      if (activeOrders.isNotEmpty) {
        activeOrders.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
        activeWorkOrder = activeOrders.first;
        currentStatusStep = _mapStatusToStep(activeWorkOrder!.status);
      } else {
        activeWorkOrder = null;
        currentStatusStep = 0;
      }

      final completedOrders = orders
          .where(
            (o) =>
                o.status == WorkOrderStatus.complete ||
                o.status == WorkOrderStatus.rejected,
          )
          .toList();
      completedOrders.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

      recentCompleted = completedOrders;

      isLoading = false;
      notifyListeners();
    } catch (e) {
      errorMessage = e.toString().replaceAll('Exception: ', '');
      isLoading = false;
      notifyListeners();
    }
  }

  int _mapStatusToStep(WorkOrderStatus status) {
    switch (status) {
      case WorkOrderStatus.pending:
        return 1;
      case WorkOrderStatus.assigned:
      case WorkOrderStatus.rejectInReview:
        return 2;
      case WorkOrderStatus.complete:
        return 3;
      default:
        return 0;
    }
  }
}
