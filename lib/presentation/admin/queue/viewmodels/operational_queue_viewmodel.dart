import 'package:flutter/material.dart';
import '../../../../domain/entities/work_order.dart';
import '../../../../domain/usecases/work_order/get_many_work_orders_usecase.dart';
import '../../../../domain/usecases/auth/get_current_user_usecase.dart';

class OperationalQueueViewModel extends ChangeNotifier {
  final GetManyWorkOrdersUseCase getManyWorkOrdersUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;

  OperationalQueueViewModel({
    required this.getManyWorkOrdersUseCase,
    required this.getCurrentUserUseCase,
  });

  int _activeTabIndex = 0;
  List<WorkOrder> _allWorkOrders = [];
  bool isLoading = false;

  int get activeTabIndex => _activeTabIndex;

  void changeTab(int index) {
    if (_activeTabIndex != index) {
      _activeTabIndex = index;
      notifyListeners();
      loadWorkOrders(); // Refresh data for the new tab
    }
  }

  Future<void> loadWorkOrders() async {
    isLoading = true;
    notifyListeners();

    try {
      final user = await getCurrentUserUseCase.execute();
      if (user != null) {
        // Map tab index to status for API filtering if possible
        String? statusFilter;
        if (_activeTabIndex == 3) {
          statusFilter = 'complete';
        } else if (_activeTabIndex == 4) {
          statusFilter = 'rejectInReview';
        }

        _allWorkOrders = await getManyWorkOrdersUseCase.execute(
          user.id,
          status: statusFilter,
        );
      }
    } catch (e) {
      debugPrint("Error loading operational queue: $e");
      _allWorkOrders = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  List<Map<String, dynamic>> get currentJobs {
    final List<Map<String, dynamic>> jobs = _allWorkOrders.map((wo) {
      // Map enum name to more user-friendly display name
      String statusDisplay = wo.status.name;
      if (statusDisplay == 'inProg') statusDisplay = 'In Progress';
      if (statusDisplay == 'complete') statusDisplay = 'Completed';
      if (statusDisplay == 'rejectInReview')
        statusDisplay = 'Pending Rejection';
      if (statusDisplay == 'pending') statusDisplay = 'Pending';
      if (statusDisplay == 'rejected') statusDisplay = 'Rejected';

      return {
        'id': '#${wo.id}',
        'title': wo.title,
        'assignee':
            wo.technicianName ??
            (wo.technicianId.isNotEmpty ? 'Assigned' : 'Unassigned'),
        'isAssigned': wo.technicianId.isNotEmpty,
        'location': wo.addressString,
        'time': wo.createdAt.toIso8601String(),
        'status': statusDisplay,
        'statusEnum': wo.status.name, // The raw enum name for filtering
      };
    }).toList();

    switch (_activeTabIndex) {
      case 1: // Assigned
        return jobs
            .where(
              (j) => j['isAssigned'] == true && j['statusEnum'] != 'complete',
            )
            .toList();
      case 2: // Unassigned
        return jobs.where((j) => j['isAssigned'] == false).toList();
      case 3: // Completed
        return jobs
            .where(
              (j) =>
                  j['statusEnum'] == 'complete' ||
                  j['statusEnum'] == 'rejected',
            )
            .toList();
      case 4: // Rejections
        return jobs.where((j) => j['statusEnum'] == 'rejectInReview').toList();
      case 0: // All Jobs
      default:
        return jobs;
    }
  }
}
