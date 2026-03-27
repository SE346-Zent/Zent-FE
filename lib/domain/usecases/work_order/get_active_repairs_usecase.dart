import '../../entities/work_order.dart';
import '../../entities/enums/work_order_status.dart';
import '../../repositories/work_order_repository.dart';

class GetActiveRepairsUseCase {
  final WorkOrderRepository repository;

  GetActiveRepairsUseCase(this.repository);

  Future<List<WorkOrder>> execute(String userId) async {
    final allOrders = await repository.getManyWorkOrders(userId: userId);

    // Filter for active statuses: pending, inProg, rejectInReview
    return allOrders.where((order) {
      return order.status == WorkOrderStatus.pending ||
          order.status == WorkOrderStatus.inProg ||
          order.status == WorkOrderStatus.rejectInReview;
    }).toList();
  }
}
