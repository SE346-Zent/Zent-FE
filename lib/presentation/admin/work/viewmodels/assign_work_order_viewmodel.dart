import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../domain/usecases/work_order/get_technicians_usecase.dart';
import '../../../../domain/usecases/work_order/assign_work_order_usecase.dart';
import '../../../../domain/usecases/work_order/get_single_work_order_usecase.dart';

class AssignWorkOrderViewModel extends ChangeNotifier {
  final GetTechniciansUseCase getTechniciansUseCase;
  final AssignWorkOrderUseCase assignWorkOrderUseCase;
  final GetSingleWorkOrderUseCase getSingleWorkOrderUseCase;
  AssignWorkOrderViewModel({
    required this.getTechniciansUseCase,
    required this.assignWorkOrderUseCase,
    required this.getSingleWorkOrderUseCase,
  });

  String _orderId = '';
  String get orderId => _orderId;

  String displayOrderId = '';

  String deviceName = '';
  String customerName = '';
  String location = '';
  String time = '';

  List<Map<String, dynamic>> technicians = [];
  List<Map<String, dynamic>> _originalTechnicians = [];

  String ratingSort = 'None';
  String workloadSort = 'None';

  bool isLoadingTechs = false;
  bool isAssigning = false;
  String? errorMessage;

  Future<void> initData(String id) async {
    _orderId = id.startsWith('#') ? id : '#$id';
    displayOrderId = '';
    deviceName = '';
    customerName = '';
    location = '';
    time = '';
    notifyListeners();
    await fetchWorkOrderDetails();
    await fetchTechnicians();
  }

  Future<void> fetchWorkOrderDetails() async {
    try {
      final cleanId = _orderId.replaceAll('#', '');
      final wo = await getSingleWorkOrderUseCase.execute(cleanId);
      displayOrderId = wo.workOrderNum.isNotEmpty ? wo.workOrderNum : _orderId;
      deviceName = wo.productName ?? 'Unknown Device';
      customerName = wo.customerName.isNotEmpty
          ? wo.customerName
          : 'Unknown Customer';
      location = wo.addressString;
      time = DateFormat(
        "MMM dd, yyyy - hh:mm a",
      ).format(wo.appointment ?? wo.createdAt);
      notifyListeners();
    } catch (e) {
      debugPrint("Error fetching work order details: $e");
    }
  }

  void updateRatingSort(String value) {
    ratingSort = value;
    applySort();
  }

  void updateWorkloadSort(String value) {
    workloadSort = value;
    applySort();
  }

  void resetSort() {
    ratingSort = 'None';
    workloadSort = 'None';
    applySort();
  }

  void applySort() {
    technicians = List.from(_originalTechnicians);

    technicians.sort((a, b) {
      if (ratingSort != 'None') {
        final rA =
            double.tryParse(
              a['averageRating']?.toString() ?? a['rating']?.toString() ?? '0',
            ) ??
            0.0;
        final rB =
            double.tryParse(
              b['averageRating']?.toString() ?? b['rating']?.toString() ?? '0',
            ) ??
            0.0;
        int ratingCompare = rA.compareTo(rB);
        if (ratingSort == 'Highest first') {
          ratingCompare = rB.compareTo(rA); // Descending
        }
        if (ratingCompare != 0) return ratingCompare;
      }

      if (workloadSort != 'None') {
        final wlA = int.tryParse(a['workload']?.toString() ?? '0') ?? 0;
        final wlB = int.tryParse(b['workload']?.toString() ?? '0') ?? 0;
        int workloadCompare = wlA.compareTo(wlB);
        if (workloadSort == 'Highest first') {
          workloadCompare = wlB.compareTo(wlA);
        }
        if (workloadCompare != 0) return workloadCompare;
      }
      return 0;
    });

    notifyListeners();
  }

  Future<void> fetchTechnicians() async {
    isLoadingTechs = true;
    notifyListeners();

    try {
      final realUsers = await getTechniciansUseCase.execute();

      _originalTechnicians = realUsers
          .map(
            (user) => {
              ...user,
              'id': user['id'],
              'name': user['fullName'] ?? user['name'] ?? 'Unknown Technician',
            },
          )
          .toList();
      applySort();

      isLoadingTechs = false;
      notifyListeners();
    } catch (e) {
      isLoadingTechs = false;
      errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<bool> submitAssign(String technicianId) async {
    isAssigning = true;
    errorMessage = null;
    notifyListeners();

    try {
      final cleanId = _orderId.replaceAll('#', '');
      await assignWorkOrderUseCase.execute(cleanId, technicianId);
      await Future.delayed(const Duration(seconds: 1));

      isAssigning = false;
      notifyListeners();
      return true;
    } catch (e) {
      errorMessage = e.toString().replaceAll('Exception: ', '');
      isAssigning = false;
      notifyListeners();
      return false;
    }
  }
}
