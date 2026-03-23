import '../../entities/work_order_completion_draft.dart';
import '../../repositories/work_order_repository.dart';

class GetWorkOrderDraftUseCase {
  final WorkOrderRepository repository;

  GetWorkOrderDraftUseCase(this.repository);

  Future<WorkOrderCompletionDraft?> execute(String workOrderId) async {
    return await repository.getWorkOrderDraft(workOrderId);
  }
}
