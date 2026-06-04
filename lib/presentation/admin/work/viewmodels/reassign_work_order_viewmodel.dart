import 'package:flutter/material.dart';
import '../../../../domain/usecases/work_order/reassign_work_order_usecase.dart';
import 'package:zent_fe/di/injection_container.dart';
import 'package:zent_fe/domain/repositories/work_order_repository.dart';

class ReassignWorkOrderViewModel extends ChangeNotifier {
  final ReassignWorkOrderUseCase reassignWorkOrderUseCase;

  String _orderId = '';
  String get orderId => _orderId;

  bool isLoading = false;
  String? errorMessage;

  List<Map<String, dynamic>> technicians = [];
  List<Map<String, dynamic>> _originalTechnicians = [];

  String workloadSort = 'None';
  String nameSort = 'None';

  void updateWorkloadSort(String value) {
    workloadSort = value;
    applySort();
  }

  void updateNameSort(String value) {
    nameSort = value;
    applySort();
  }

  void resetSort() {
    workloadSort = 'None';
    nameSort = 'None';
    applySort();
  }

  void applySort() {
    technicians = List.from(_originalTechnicians);
    
    technicians.sort((a, b) {
      if (workloadSort != 'None') {
        final wlA = int.tryParse(a['workload']?.toString() ?? '0') ?? 0;
        final wlB = int.tryParse(b['workload']?.toString() ?? '0') ?? 0;
        int workloadCompare = wlA.compareTo(wlB);
        if (workloadSort == 'Max first') {
          workloadCompare = wlB.compareTo(wlA);
        }
        if (workloadCompare != 0) return workloadCompare;
      }

      if (nameSort != 'None') {
        final nameA = (a['fullName'] ?? a['name'] ?? '').toString().toLowerCase();
        final nameB = (b['fullName'] ?? b['name'] ?? '').toString().toLowerCase();
        if (nameSort == 'A to Z') return nameA.compareTo(nameB);
        if (nameSort == 'Z to A') return nameB.compareTo(nameA);
      }
      return 0;
    });
    
    notifyListeners();
  }

  ReassignWorkOrderViewModel({required this.reassignWorkOrderUseCase});

  Future<void> initData(String id) async {
    _orderId = id.startsWith('#') ? id : '#$id';
    await fetchRealTechnicians();
  }

  Future<void> fetchRealTechnicians() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final repo = sl<WorkOrderRepository>();
      
      // Fetch both technicians and the current work order details concurrently
      final cleanId = _orderId.replaceAll('#', '');
      final results = await Future.wait([
        repo.getTechnicians(),
        repo.getWorkOrderDetail(id: cleanId),
      ]);
      
      final realTechs = results[0] as List<Map<String, dynamic>>;
      final workOrder = results[1] as dynamic; // It returns WorkOrderEntity
      
      final currentTechId = workOrder.technicianId;

      // Filter out the currently assigned technician
      technicians = realTechs.where((tech) => tech['id'] != currentTechId).toList();
      _originalTechnicians = List.from(technicians);
      applySort();
    } catch (e) {
      errorMessage =
          'Error loading technicians: ${e.toString().replaceAll('Exception: ', '')}';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  String? reassigningTechId;

  Future<bool> submitReassign(String newTechnicianId) async {
    reassigningTechId = newTechnicianId;
    errorMessage = null;
    notifyListeners();

    try {
      final cleanId = _orderId.replaceAll('#', '');
      await reassignWorkOrderUseCase.execute(cleanId, newTechnicianId);

      reassigningTechId = null;
      notifyListeners();
      return true;
    } catch (e) {
      errorMessage =
          'Error submitting reassignment: ${e.toString().replaceAll('Exception: ', '')}';
      reassigningTechId = null;
      notifyListeners();
      return false;
    }
  }
}
