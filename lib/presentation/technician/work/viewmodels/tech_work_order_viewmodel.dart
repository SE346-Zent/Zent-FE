import 'package:flutter/material.dart';
import '../../../../domain/entities/work_order.dart';
import '../../../../domain/usecases/work_order/get_many_work_orders_usecase.dart';
import '../../../../domain/usecases/auth/get_current_user_usecase.dart';

class TechWorkOrderViewModel extends ChangeNotifier {
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
    'Pending',
    'Completed',
  ];

  List<WorkOrder> _allOrders = [];
  bool isLoading = false;

  List<WorkOrder> get filteredOrders {
    if (selectedFilterIndex == 0) return _allOrders;
    final statusFilter = filters[selectedFilterIndex].toLowerCase();

    // Simple mapping for demo/logic
    return _allOrders.where((order) {
      final status = order.status.name; // Use exact enum name
      if (statusFilter == 'in progress') return status == 'inProg';
      if (statusFilter == 'pending') return status == 'pending';
      if (statusFilter == 'completed') return status == 'complete';
      return status.toLowerCase() == statusFilter;
    }).toList();
  }

  Future<void> initData() async {
    isLoading = true;
    notifyListeners();

    try {
      final user = await getCurrentUserUseCase.execute();
      if (user != null) {
        final results = await getManyWorkOrdersUseCase.execute(
          limit: 100,
        );
        // The server already filters work orders by the technician's token identity.
        _allOrders = results;
      }
    } catch (e) {
      debugPrint("Error fetching tech work orders: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void setFilter(int index) {
    if (selectedFilterIndex != index) {
      selectedFilterIndex = index;
      notifyListeners();
      initData(); // Trigger API refresh
    }
  }
}
