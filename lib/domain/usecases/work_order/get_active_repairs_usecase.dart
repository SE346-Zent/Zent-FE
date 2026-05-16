import '../../entities/work_order.dart';
import '../../entities/enums/work_order_status.dart';
import '../../repositories/work_order_repository.dart';

class GetActiveRepairsUseCase {
  final WorkOrderRepository repository;

  GetActiveRepairsUseCase(this.repository);

  Future<List<WorkOrder>> execute(String customerId) async {
    final activeOrders = await repository.getActiveRepairs(
      customerId: customerId,
    );

    // Filter for active statuses: pending, inProg, rejectInReview
    return activeOrders.where((order) {
      return order.status == WorkOrderStatus.pending ||
          order.status == WorkOrderStatus.inProg ||
          order.status == WorkOrderStatus.rejectInReview;
    }).toList();
  }
}
