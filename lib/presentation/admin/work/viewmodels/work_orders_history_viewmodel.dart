import 'package:flutter/material.dart';
import '../../../../domain/entities/work_order.dart';
import '../../../../domain/entities/user.dart';
import '../../../../domain/entities/enums/user_roles.dart';
import '../../../../domain/entities/enums/work_order_status.dart';
import '../../../../domain/usecases/work_order/get_many_work_orders_usecase.dart';
import '../../../../domain/usecases/auth/get_current_user_usecase.dart';

class WorkOrdersHistoryViewModel extends ChangeNotifier {
  final GetManyWorkOrdersUseCase getManyWorkOrdersUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;

  WorkOrdersHistoryViewModel({
    required this.getManyWorkOrdersUseCase,
    required this.getCurrentUserUseCase,
  });

  User? currentUser;
  List<WorkOrder> _allOrders = [];
  List<WorkOrder> displayOrders = [];
  bool isLoading = false;
  String searchQuery = "";
  int selectedFilterIndex = 0;

  List<String> get filters {
    if (currentUser == null) return [];
    if (currentUser!.role == UserRoles.admin) {
      return [
        "All Jobs",
        "Assigned",
        "Unassigned",
        "Completed",
        "Rejected",
        "Reject_Rev",
        "InProg",
      ];
    } else if (currentUser!.role == UserRoles.technician) {
      return ["All Jobs", "Assigned", "InProg", "Completed"];
    } else {
      // Customer has no filter tabs
      return [];
    }
  }

  Future<void> loadWorkOrders() async {
    isLoading = true;
    notifyListeners();

    try {
      currentUser = await getCurrentUserUseCase.execute();
      if (currentUser != null) {
        // Fetch all work orders for the system
        final results = await getManyWorkOrdersUseCase.execute(
          limit: 1000,
          technicianId: currentUser!.role == UserRoles.technician
              ? currentUser!.id
              : null,
        );
        debugPrint(
          "----- HISTORY DIAGNOSTIC: Loaded ${results.length} WOs total -----",
        );
        for (var wo in results) {
          debugPrint(
            "WO DIAGNOSTIC: num=${wo.workOrderNum}, customerId=${wo.customerId}, status=${wo.status}, status_name=${wo.status.name}",
          );
        }
        _allOrders = results;
        _applyFilters();
      }
    } catch (e) {
      debugPrint("Error loading work order history: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void setSearchQuery(String query) {
    searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  void setFilterIndex(int index) {
    selectedFilterIndex = index;
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    if (currentUser == null) {
      displayOrders = [];
      return;
    }

    Iterable<WorkOrder> filtered = _allOrders;

    // 1. Role-locked API restriction filtering (as per Task 3)
    final role = currentUser!.role;
    if (role == UserRoles.technician) {
      final cleanCurrentId = currentUser!.id.replaceAll('-', '').toLowerCase();
      filtered = filtered.where(
        (wo) =>
            wo.technicianId.isEmpty ||
            wo.technicianId.replaceAll('-', '').toLowerCase() == cleanCurrentId,
      );
    } else if (role == UserRoles.customer) {
      // History should get all statuses for customer as well, so status filtering is removed
    } else if (role == UserRoles.admin) {
      var province = currentUser!.province.toUpperCase();
      if (province.isEmpty) {
        final email = currentUser!.email.toLowerCase();
        final name = currentUser!.name.toLowerCase();
        if (email.contains("hn") ||
            email.contains("hanoi") ||
            name.contains("hn") ||
            name.contains("hanoi")) {
          province = 'HN';
        } else {
          province = 'HCM';
        }
      }

      if (province == 'HN') {
        filtered = filtered.where((wo) {
          final addr = wo.addressString.toLowerCase();
          return addr.contains("hn") ||
              addr.contains("hà nội") ||
              addr.contains("ha noi");
        });
      } else if (province == 'HCM') {
        filtered = filtered.where((wo) {
          final addr = wo.addressString.toLowerCase();
          return addr.contains("hcm") ||
              addr.contains("hồ chí minh") ||
              addr.contains("ho chi minh") ||
              addr.contains("sài gòn") ||
              addr.contains("sai gon");
        });
      }
    }

    // 2. Search query filtering (matches workOrderNum case-insensitive)
    if (searchQuery.isNotEmpty) {
      final query = searchQuery.trim().toLowerCase();
      filtered = filtered.where(
        (wo) =>
            wo.workOrderNum.toLowerCase().contains(query) ||
            wo.title.toLowerCase().contains(query),
      );
    }

    // 3. Tab filter selection
    if (filters.isNotEmpty && selectedFilterIndex < filters.length) {
      final selectedTab = filters[selectedFilterIndex];
      if (selectedTab == "Assigned") {
        filtered = filtered.where(
          (wo) =>
              wo.technicianId.isNotEmpty &&
              wo.status != WorkOrderStatus.complete &&
              wo.status != WorkOrderStatus.rejected,
        );
      } else if (selectedTab == "Unassigned") {
        filtered = filtered.where((wo) => wo.technicianId.isEmpty);
      } else if (selectedTab == "Completed") {
        filtered = filtered.where(
          (wo) => wo.status == WorkOrderStatus.complete,
        );
      } else if (selectedTab == "Rejected") {
        filtered = filtered.where(
          (wo) => wo.status == WorkOrderStatus.rejected,
        );
      } else if (selectedTab == "Reject_Rev") {
        filtered = filtered.where(
          (wo) => wo.status == WorkOrderStatus.rejectInReview,
        );
      } else if (selectedTab == "InProg") {
        filtered = filtered.where((wo) => wo.status == WorkOrderStatus.inProg);
      }
    }

    displayOrders = filtered.toList();
  }
}
