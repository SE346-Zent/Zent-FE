import '../../repositories/work_order_repository.dart';
import '../../../data/models/edit_work_order_request.dart';

class EditWorkOrderUseCase {
  final WorkOrderRepository repository;

  EditWorkOrderUseCase(this.repository);

  Future<void> execute(
    String workOrderNumber,
    EditWorkOrderRequest request,
  ) async {
    return await repository.editWorkOrder(workOrderNumber, request);
  }
}
