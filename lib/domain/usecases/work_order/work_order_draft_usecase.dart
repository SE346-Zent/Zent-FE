import '../../entities/work_order_completion_draft.dart';
import '../../repositories/work_order_repository.dart';

class WorkOrderDraftUseCase {
  final WorkOrderRepository repository;

  WorkOrderDraftUseCase(this.repository);

  Future<WorkOrderCompletionDraft?> get(String workOrderId) async {
    return await repository.getWorkOrderDraft(workOrderId);
  }

  Future<void> save(WorkOrderCompletionDraft draft) async {
    await repository.saveWorkOrderDraft(draft);
  }

  Future<void> clear(String workOrderId) async {
    await repository.clearWorkOrderDraft(workOrderId);
  }
}
