import 'package:flutter/material.dart';
import '../../../../domain/usecases/work_order/get_many_work_orders_usecase.dart'; // Sửa lại đường dẫn import này cho đúng nhé
import '../../../../domain/entities/work_order.dart';
import '../../../../domain/entities/enums/work_order_status.dart';

class CompletedRepairItem {
  final String title;
  final String woNumber;
  final String date;

  CompletedRepairItem({
    required this.title,
    required this.woNumber,
    required this.date,
  });
}

class ActiveRepairsViewModel extends ChangeNotifier {
  final GetManyWorkOrdersUseCase getManyWorkOrdersUseCase;

  ActiveRepairsViewModel({required this.getManyWorkOrdersUseCase});

  bool isLoading = false;
  String? errorMessage;

  int currentStatusStep = 0;
  WorkOrder? activeWorkOrder;
  List<CompletedRepairItem> recentCompleted = [];

  Future<void> fetchWorkOrders() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final orders = await getManyWorkOrdersUseCase.execute(limit: 50);

      final activeOrders = orders
          .where(
            (o) =>
                o.status == WorkOrderStatus.pending ||
                o.status == WorkOrderStatus.inProg ||
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
          .where((o) => o.status == WorkOrderStatus.complete)
          .toList();
      completedOrders.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

      recentCompleted = completedOrders.map((o) {
        final dateStr =
            "${o.updatedAt.year}-${o.updatedAt.month.toString().padLeft(2, '0')}-${o.updatedAt.day.toString().padLeft(2, '0')}";
        return CompletedRepairItem(
          title: o.title.isNotEmpty
              ? o.title
              : (o.productName ?? 'Service Request'),
          woNumber: o.workOrderNum ?? o.id.substring(0, 8),
          date: dateStr,
        );
      }).toList();

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
      case WorkOrderStatus.inProg:
      case WorkOrderStatus.rejectInReview:
        return 2;
      case WorkOrderStatus.complete:
        return 3;
      default:
        return 0;
    }
  }
}
