import 'package:flutter/material.dart';
import '../../../../domain/usecases/work_order/get_technicians_usecase.dart';
import '../../../../domain/usecases/work_order/assign_work_order_usecase.dart';

class AssignWorkOrderViewModel extends ChangeNotifier {
  final GetTechniciansUseCase getTechniciansUseCase;
  final AssignWorkOrderUseCase assignWorkOrderUseCase;
  AssignWorkOrderViewModel({
    required this.getTechniciansUseCase,
    required this.assignWorkOrderUseCase,
  });

  String _orderId = '';
  String get orderId => _orderId;

  String deviceName = 'IdeaPad 16ARH7';
  String customerName = 'John Doe';
  String location = '123 Hoa Binh, Quan Tan Phu, HCM';
  String time = 'Oct 30, 2026 - 10h00 AM';

  List<Map<String, dynamic>> technicians = [];

  bool isLoadingTechs = false;
  bool isAssigning = false;
  String? errorMessage;

  Future<void> initData(String id) async {
    _orderId = id.startsWith('#') ? id : '#$id';
    notifyListeners();
    await fetchTechnicians();
  }

  Future<void> fetchTechnicians() async {
    isLoadingTechs = true;
    notifyListeners();

    try {
      final realUsers = await getTechniciansUseCase.execute();

      technicians = realUsers
          .map(
            (user) => {
              ...user,
              'id': user['id'],
              'name': user['fullName'] ?? user['name'] ?? 'Unknown Technician',
            },
          )
          .toList();

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
