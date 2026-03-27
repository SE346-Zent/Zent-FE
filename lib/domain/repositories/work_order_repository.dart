import '../entities/work_order_completion_draft.dart';
import '../entities/work_order.dart';

abstract class WorkOrderRepository {
  // Remote methods
  Future<WorkOrder> getSingleWorkOrder({required String id});
  Future<List<WorkOrder>> getManyWorkOrders({required String userId});

  Future<void> saveWorkOrderDraft(WorkOrderCompletionDraft draft);
  Future<WorkOrderCompletionDraft?> getWorkOrderDraft(String workOrderId);
}
