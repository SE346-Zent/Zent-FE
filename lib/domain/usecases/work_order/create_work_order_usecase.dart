import '../../repositories/work_order_repository.dart';
import '../../../data/models/create_work_order_request.dart';

class CreateWorkOrderUseCase {
  final WorkOrderRepository repository;

  CreateWorkOrderUseCase(this.repository);

  Future<void> execute(CreateWorkOrderRequest request) async {
    return await repository.createWorkOrder(request);
  }
}
