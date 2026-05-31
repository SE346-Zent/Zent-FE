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
  bool _isDisposed = false;

  int get activeTabIndex => _activeTabIndex;

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  void changeTab(int index) {
    if (_activeTabIndex != index) {
      _activeTabIndex = index;
      notifyListeners();
      loadWorkOrders();
    }
  }

  Future<void> loadWorkOrders() async {
    isLoading = true;
    notifyListeners();

    try {
      final user = await getCurrentUserUseCase.execute();
      if (user != null) {
        final results = await getManyWorkOrdersUseCase.execute(limit: 100);

        var province = user.province.toUpperCase();
        if (province.isEmpty) {
          final email = user.email.toLowerCase();
          final name = user.name.toLowerCase();
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
          _allWorkOrders = results.where((wo) {
            final addr = wo.addressString.toLowerCase();
            return addr.contains("hn") ||
                addr.contains("hà nội") ||
                addr.contains("ha noi");
          }).toList();
        } else if (province == 'HCM') {
          _allWorkOrders = results.where((wo) {
            final addr = wo.addressString.toLowerCase();
            return addr.contains("hcm") ||
                addr.contains("hồ chí minh") ||
                addr.contains("ho chi minh") ||
                addr.contains("sài gòn") ||
                addr.contains("sai gon");
          }).toList();
        } else {
          _allWorkOrders = results;
        }
      }
    } catch (e) {
      debugPrint("Error loading operational queue: $e");
      _allWorkOrders = [];
    } finally {
      if (!_isDisposed) {
        isLoading = false;
        notifyListeners();
      }
    }
  }

  List<Map<String, dynamic>> get currentJobs {
    final List<Map<String, dynamic>> jobs = _allWorkOrders.map((wo) {
      String backendStatus = wo.status.name;
      String uiStatusEnum = '';
      String statusDisplay = '';
      bool isAssigned = false;

      if (backendStatus == 'pending') {
        if (wo.technicianId.isEmpty) {
          uiStatusEnum = 'unassigned';
          statusDisplay = 'Pending assignment';
          isAssigned = false;
        } else {
          uiStatusEnum = 'pending_acceptance';
          statusDisplay = 'Pending assignment';
          isAssigned = true;
        }
      } else if (backendStatus == 'Assigned' || backendStatus == 'assigned') {
        uiStatusEnum = 'assigned';
        statusDisplay = 'Assigned';
        isAssigned = true;
      } else if (backendStatus == 'inProg') {
        uiStatusEnum = 'in_progress';
        statusDisplay = 'In Progress';
        isAssigned = true;
      } else if (backendStatus == 'complete') {
        uiStatusEnum = 'completed';
        statusDisplay = 'Completed';
        isAssigned = true;
      } else if (backendStatus == 'rejectInReview') {
        uiStatusEnum = 'reject_in_review';
        statusDisplay = 'Pending Rejection';
        isAssigned = true;
      } else if (backendStatus == 'rejected') {
        uiStatusEnum = 'rejected';
        statusDisplay = 'Rejected';
        isAssigned = true;
      } else {
        uiStatusEnum = backendStatus;
        statusDisplay = backendStatus;
        isAssigned = wo.technicianId.isNotEmpty;
      }

      String assigneeText = 'Unassigned';
      if (isAssigned) {
        if (wo.technicianName != null && wo.technicianName!.isNotEmpty) {
          assigneeText = wo.technicianName!;
        } else {
          assigneeText =
              'Tech (ID: ${wo.technicianId.isNotEmpty ? wo.technicianId.substring(0, 4) : 'N/A'})';
        }
      }

      return {
        'id': '#${wo.id}',
        'title': wo.title,
        'assignee': assigneeText,
        'isAssigned': isAssigned,
        'location': wo.addressString,
        'time': wo.createdAt.toIso8601String(),
        'status': statusDisplay,
        'statusEnum': uiStatusEnum,
      };
    }).toList();

    switch (_activeTabIndex) {
      case 1: // Assigned
        return jobs
            .where(
              (j) =>
                  j['isAssigned'] == true &&
                  j['statusEnum'] != 'completed' &&
                  j['statusEnum'] != 'rejected',
            )
            .toList();
      case 2: // Unassigned
        return jobs.where((j) => j['statusEnum'] == 'unassigned').toList();
      case 3: // Completed
        return jobs
            .where(
              (j) =>
                  j['statusEnum'] == 'completed' ||
                  j['statusEnum'] == 'rejected',
            )
            .toList();
      case 4: // Rejections
        return jobs
            .where((j) => j['statusEnum'] == 'reject_in_review')
            .toList();
      case 0: // All Jobs
      default:
        return jobs;
    }
  }
}
