import 'package:flutter/material.dart';
import '../../../../domain/usecases/work_order/change_appointment_usecase.dart';

class ChangeAppointmentViewModel extends ChangeNotifier {
  final ChangeAppointmentUseCase changeAppointmentUseCase;

  ChangeAppointmentViewModel({required this.changeAppointmentUseCase});

  bool isLoading = false;
  String? errorMessage;

  Future<bool> submitNewAppointment(
    String workOrderId,
    DateTime newDate,
  ) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await changeAppointmentUseCase.execute(workOrderId, newDate);

      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      errorMessage = e.toString().replaceAll('Exception: ', '');
      isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
