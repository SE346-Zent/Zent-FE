import 'package:flutter/material.dart';
import 'package:zent_fe/domain/entities/work_order.dart';
import 'package:zent_fe/domain/usecases/work_order/get_single_work_order_usecase.dart';
import 'package:zent_fe/presentation/common/core/safe_change_notifier.dart';

class CustomerWorkOrderDetailsViewModel extends ChangeNotifier
    with SafeChangeNotifier {
  final GetSingleWorkOrderUseCase getSingleWorkOrderUseCase;
  final String workOrderId;

  CustomerWorkOrderDetailsViewModel({
    required this.getSingleWorkOrderUseCase,
    required this.workOrderId,
  });

  bool isLoading = false;
  String? errorMessage;
  WorkOrder? workOrder;

  Future<void> loadDetails() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final cleanId = workOrderId.replaceAll('#', '');
      workOrder = await getSingleWorkOrderUseCase.execute(cleanId);
    } catch (e) {
      errorMessage = e.toString();
      debugPrint("Error loading Customer Work Order details: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
