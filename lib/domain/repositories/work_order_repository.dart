import '../../data/models/create_work_order_request.dart';
import '../../data/models/complete_work_order_request.dart';
import '../../data/models/refuse_work_order_request.dart';
import '../entities/work_order.dart';
import '../entities/work_order_completion_draft.dart';

abstract class WorkOrderRepository {
  Future<void> createWorkOrder(CreateWorkOrderRequest request);
  Future<void> completeWorkOrder(String id, CompleteWorkOrderRequest request);
  Future<void> refuseWorkOrder(String id, RefuseWorkOrderRequest request);
  Future<void> approveRefusal(String id, ApproveRefusalRequest request);
  Future<void> denyRefusal(String id);
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
  Future<void> clearWorkOrderDraft(String workOrderId);
}
