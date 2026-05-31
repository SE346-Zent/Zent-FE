import '../../repositories/work_order_repository.dart';

class AssignWorkOrderUseCase {
  final WorkOrderRepository repository;

  AssignWorkOrderUseCase({required this.repository});

  Future<void> execute(String id, String technicianId) async {
    return await repository.assignWorkOrder(id, technicianId);
  }
}
