import '../../entities/work_order.dart';
import '../../repositories/work_order_repository.dart';

class GetManyWorkOrdersUseCase {
  final WorkOrderRepository repository;

  GetManyWorkOrdersUseCase(this.repository);

  Future<List<WorkOrder>> execute({
    int page = 1,
    int limit = 20,
    String? role,
    String? province,
    String? technicianId,
  }) async {
    return await repository.getWorkOrders(
      page: page,
      limit: limit,
      role: role,
      province: province,
      technicianId: technicianId,
    );
  }
}
