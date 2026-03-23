import '../../entities/work_order_completion_draft.dart';
import '../../repositories/work_order_repository.dart';

class SaveWorkOrderDraftUseCase {
  final WorkOrderRepository repository;

  SaveWorkOrderDraftUseCase(this.repository);

  Future<void> execute(WorkOrderCompletionDraft draft) async {
    await repository.saveWorkOrderDraft(draft);
  }
}
