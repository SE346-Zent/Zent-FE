import 'package:zent_fe/presentation/common/core/safe_change_notifier.dart';
import 'package:flutter/material.dart';
import '../../../../domain/entities/work_order.dart';
import '../../../../domain/repositories/work_order_repository.dart';

class DetailedHistoryViewModel extends ChangeNotifier with SafeChangeNotifier {
  final WorkOrderRepository repository;
  final String workOrderId;

  DetailedHistoryViewModel({
    required this.repository,
    required this.workOrderId,
  });

  bool isLoading = true;
  String? errorMessage;
  WorkOrder? workOrder;
  Map<String, dynamic>? historyData;

  Future<void> loadDetails() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      // Fetch details and history in parallel for maximum speed
      final results = await Future.wait([
        repository.getWorkOrderDetail(id: workOrderId),
        repository.getWorkOrderHistory(workOrderId),
      ]);

      workOrder = results[0] as WorkOrder;
      historyData = results[1] as Map<String, dynamic>;
    } catch (e) {
      debugPrint("Error loading work order detailed history: $e");
      errorMessage = e.toString().replaceAll("Exception: ", "");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
