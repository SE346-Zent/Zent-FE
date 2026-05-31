import '../../repositories/work_order_repository.dart';

class ChangeAppointmentUseCase {
  final WorkOrderRepository repository;

  ChangeAppointmentUseCase({required this.repository});

  Future<void> execute(String id, DateTime newDate) async {
    return await repository.changeAppointment(id, newDate);
  }
}
