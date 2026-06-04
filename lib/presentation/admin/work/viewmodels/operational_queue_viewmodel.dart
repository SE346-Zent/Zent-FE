import 'package:zent_fe/presentation/common/core/safe_change_notifier.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../domain/entities/work_order.dart';
import '../../../../domain/usecases/work_order/get_many_work_orders_usecase.dart';
import '../../../../domain/usecases/auth/get_current_user_usecase.dart';

class OperationalQueueViewModel extends ChangeNotifier with SafeChangeNotifier {
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
  String _appointmentSort = 'None';

  int get activeTabIndex => _activeTabIndex;
  String get appointmentSort => _appointmentSort;

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

  void updateAppointmentSort(String sort) {
    if (_appointmentSort != sort) {
      _appointmentSort = sort;
      notifyListeners();
    }
  }

  void resetSort() {
    if (_appointmentSort != 'None') {
      _appointmentSort = 'None';
      notifyListeners();
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
          statusDisplay = 'Pending';
          isAssigned = false;
        } else {
          uiStatusEnum = 'pending_acceptance';
          statusDisplay = 'Pending';
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
        'displayId': '#${wo.workOrderNum.isNotEmpty ? wo.workOrderNum : wo.id}',
        'title': wo.title,
        'assignee': assigneeText,
        'isAssigned': isAssigned,
        'location': wo.addressString,
        'time': DateFormat(
          "MMM dd, yyyy - hh:mm a",
        ).format(wo.appointment ?? wo.createdAt),
        'status': statusDisplay,
        'statusEnum': uiStatusEnum,
        'createdAt': wo.createdAt,
      };
    }).toList();

    List<Map<String, dynamic>> filteredJobs = jobs;

    switch (_activeTabIndex) {
      case 1: // Assigned
        filteredJobs = jobs
            .where(
              (j) =>
                  j['isAssigned'] == true &&
                  j['statusEnum'] != 'completed' &&
                  j['statusEnum'] != 'rejected',
            )
            .toList();
        break;
      case 2: // Unassigned
        filteredJobs = jobs
            .where((j) => j['statusEnum'] == 'unassigned')
            .toList();
        break;
      case 3: // Completed
        filteredJobs = jobs
            .where(
              (j) =>
                  j['statusEnum'] == 'completed' ||
                  j['statusEnum'] == 'rejected',
            )
            .toList();
        break;
      case 4: // Rejections
        filteredJobs = jobs
            .where((j) => j['statusEnum'] == 'reject_in_review')
            .toList();
        break;
      case 0: // All Jobs
      default:
        filteredJobs = jobs;
        break;
    }

    if (_appointmentSort == 'Latest first') {
      filteredJobs.sort((a, b) => b['createdAt'].compareTo(a['createdAt']));
    } else if (_appointmentSort == 'Earliest first') {
      filteredJobs.sort((a, b) => a['createdAt'].compareTo(b['createdAt']));
    }

    return filteredJobs;
  }
}
