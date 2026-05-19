import '../../repositories/work_order_repository.dart';
import '../../../data/models/add_part_request.dart';

class AddPartUseCase {
  final WorkOrderRepository repository;

  AddPartUseCase(this.repository);

  Future<void> execute(String workOrderId, AddPartRequest request) async {
    return await repository.addPartToWorkOrder(workOrderId, request);
  }
}