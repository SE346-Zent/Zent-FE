import '../../repositories/work_order_repository.dart';
import '../../../data/models/refuse_work_order_request.dart';

class ApproveRefusalUseCase {
  final WorkOrderRepository repository;

  ApproveRefusalUseCase(this.repository);

  Future<void> execute(String id, ApproveRefusalRequest request) async {
    return await repository.approveRefusal(id, request);
  }
}
