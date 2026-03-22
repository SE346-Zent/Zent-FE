import '../../entities/work_order.dart';
import '../../repositories/work_order_repository.dart';

class GetManyWorkOrdersUseCase {
  final WorkOrderRepository repository;

  GetManyWorkOrdersUseCase(this.repository);

  Future<List<WorkOrder>> execute(String userId) async {
    return await repository.getManyWorkOrders(userId: userId);
  }
}
