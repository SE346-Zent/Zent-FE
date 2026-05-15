import '../../entities/work_order.dart';
import '../../repositories/work_order_repository.dart';

class GetManyWorkOrdersUseCase {
  final WorkOrderRepository repository;

  GetManyWorkOrdersUseCase(this.repository);

  Future<List<WorkOrder>> execute(
    String userId, {
    String? status,
    int page = 1,
    int limit = 20,
    String? role,
  }) async {
    return await repository.getManyWorkOrders(
      userId: userId,
      status: status,
      page: page,
      limit: limit,
      role: role,
    );
  }
}
