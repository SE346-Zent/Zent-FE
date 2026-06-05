import '../../repositories/work_order_repository.dart';
import '../../entities/reject_form.dart';

class GetRejectFormByIdUseCase {
  final WorkOrderRepository repository;

  GetRejectFormByIdUseCase({required this.repository});

  Future<RejectForm> execute(
    String rejectFormId, {
    String workOrderId = '',
  }) async {
    return await repository.getRejectFormById(
      rejectFormId,
      workOrderId: workOrderId,
    );
  }
}
