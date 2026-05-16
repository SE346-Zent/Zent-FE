import '../../entities/work_order.dart';
import '../../repositories/work_order_repository.dart';

class GetSingleWorkOrderUseCase {
  final WorkOrderRepository repository;

  GetSingleWorkOrderUseCase(this.repository);

  Future<WorkOrder> execute(String id) async {
    return await repository.getWorkOrderDetail(id: id);
  }
}
