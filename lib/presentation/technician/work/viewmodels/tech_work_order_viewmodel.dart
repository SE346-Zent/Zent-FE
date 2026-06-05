import 'package:zent_fe/presentation/common/core/safe_change_notifier.dart';
import 'package:flutter/material.dart';
import '../../../../domain/entities/work_order.dart';
import '../../../../domain/entities/enums/work_order_status.dart';
import '../../../../domain/usecases/work_order/get_many_work_orders_usecase.dart';
import '../../../../domain/usecases/auth/get_current_user_usecase.dart';

class TechWorkOrderViewModel extends ChangeNotifier with SafeChangeNotifier {
  final GetManyWorkOrdersUseCase getManyWorkOrdersUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;

  TechWorkOrderViewModel({
    required this.getManyWorkOrdersUseCase,
    required this.getCurrentUserUseCase,
  });

  int selectedFilterIndex = 0;
  final List<String> filters = [
    'All Jobs',
    'In Progress',
    'Assigned',
    'Completed',
    'Reject In Review',
  ];

  List<WorkOrder> _allOrders = [];
  bool isLoading = false;

  List<WorkOrder> get filteredOrders {
    if (selectedFilterIndex == 0) return _allOrders;
    final statusFilter = filters[selectedFilterIndex].toLowerCase();

    return _allOrders.where((order) {
      final status = order.status;
      if (statusFilter == 'in progress') {
        return status == WorkOrderStatus.assigned && order.statusId == 3;
      }
      if (statusFilter == 'assigned') {
        return status == WorkOrderStatus.assigned && order.statusId == 2;
      }
      if (statusFilter == 'completed') {
        return status == WorkOrderStatus.complete;
      }
      if (statusFilter == 'reject in review') {
        return status == WorkOrderStatus.rejectInReview;
      }
      return status.name.toLowerCase() == statusFilter;
    }).toList();
  }

  Future<void> refreshData({bool silent = false}) async {
    if (!silent) {
      isLoading = true;
      notifyListeners();
    }

    try {
      final user = await getCurrentUserUseCase.execute();
      if (user != null) {
        final results = await getManyWorkOrdersUseCase.execute(
          limit: 100,
          technicianId: user.id,
        );
        _allOrders = results;
      }
    } catch (e) {
      debugPrint("Error fetching tech work orders: $e");
    } finally {
      if (!silent) {
        isLoading = false;
      }
      notifyListeners();
    }
  }

  Future<void> initData() async {
    await refreshData(silent: false);
  }

  void setFilter(int index) {
    if (selectedFilterIndex != index) {
      selectedFilterIndex = index;
      notifyListeners();
      refreshData(silent: false); // Trigger API refresh with loading indicator
    }
  }
}
