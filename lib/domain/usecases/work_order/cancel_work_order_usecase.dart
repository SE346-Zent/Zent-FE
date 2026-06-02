import '../../repositories/work_order_repository.dart';

class CancelWorkOrderUseCase {
  final WorkOrderRepository repository;
  CancelWorkOrderUseCase({required this.repository});

  Future<void> execute(String id, String? reason) async {
    return await repository.cancelWorkOrder(id, reason);
  }
}
