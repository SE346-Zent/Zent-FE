import '../../data/models/create_work_order_request.dart';
import '../entities/work_order.dart';
import '../entities/work_order_completion_draft.dart';

abstract class WorkOrderRepository {
  Future<void> createWorkOrder(CreateWorkOrderRequest request);
  Future<WorkOrder> getSingleWorkOrder({required String id});
  Future<List<WorkOrder>> getManyWorkOrders({required String userId});
  Future<List<WorkOrder>> getActiveRepairs({required String customerId});

  // Drafts (Local)
  Future<void> saveWorkOrderDraft(WorkOrderCompletionDraft draft);
  Future<WorkOrderCompletionDraft?> getWorkOrderDraft(String workOrderId);
}
