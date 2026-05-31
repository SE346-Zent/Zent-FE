import '../../repositories/work_order_repository.dart';

class ReassignWorkOrderUseCase {
  final WorkOrderRepository repository;

  ReassignWorkOrderUseCase({required this.repository});

  Future<void> execute(String id, String newTechnicianId) async {
    return await repository.reassignWorkOrder(id, newTechnicianId);
  }
}
