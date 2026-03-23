import '../entities/work_order_completion_draft.dart';

abstract class WorkOrderRepository {
  Future<void> saveWorkOrderDraft(WorkOrderCompletionDraft draft);
  Future<WorkOrderCompletionDraft?> getWorkOrderDraft(String workOrderId);
}
