import '../../repositories/work_order_repository.dart';
import '../../../data/models/add_part_request.dart';

class AddPartToWorkOrderUseCase {
  final WorkOrderRepository repository;

  AddPartToWorkOrderUseCase(this.repository);

  Future<void> execute(String workOrderId, AddPartRequest request) async {
    return await repository.addPartToWorkOrder(workOrderId, request);
  }
}