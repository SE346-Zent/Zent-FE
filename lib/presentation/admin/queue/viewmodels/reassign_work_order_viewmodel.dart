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
      final realTechs = await repo.getTechnicians();
      
      technicians = realTechs;
    } catch (e) {
      errorMessage = 'Error loading technicians: ${e.toString().replaceAll('Exception: ', '')}';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> submitReassign(String newTechnicianId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final cleanId = _orderId.replaceAll('#', '');
      await reassignWorkOrderUseCase.execute(cleanId, newTechnicianId);
      
      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      errorMessage = 'Error submitting reassignment: ${e.toString().replaceAll('Exception: ', '')}';
      isLoading = false;
      notifyListeners();
      return false;
    }
  }
}