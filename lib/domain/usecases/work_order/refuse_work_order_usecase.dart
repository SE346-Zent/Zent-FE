import '../../repositories/work_order_repository.dart';
import '../../../data/models/refuse_work_order_request.dart';

class RefuseWorkOrderUseCase {
  final WorkOrderRepository repository;

  RefuseWorkOrderUseCase(this.repository);

  Future<void> execute(String id, RefuseWorkOrderRequest request) async {
    return await repository.refuseWorkOrder(id, request);
  }
}
