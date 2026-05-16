import '../../data/models/create_work_order_request.dart';
import '../entities/work_order.dart';
import '../entities/work_order_completion_draft.dart';

abstract class WorkOrderRepository {
  Future<void> createWorkOrder(CreateWorkOrderRequest request);
  Future<List<WorkOrder>> getWorkOrders({
    int page = 1,
    int limit = 20,
    String? role,
    String? province,
    String? technicianId,
  });

  Future<WorkOrder> getWorkOrderDetail({required String id});
  Future<List<WorkOrder>> getActiveRepairs({required String customerId});

  // Drafts (Local)
  Future<void> saveWorkOrderDraft(WorkOrderCompletionDraft draft);
  Future<WorkOrderCompletionDraft?> getWorkOrderDraft(String workOrderId);
}
