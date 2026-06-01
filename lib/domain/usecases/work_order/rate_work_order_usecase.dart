import '../../repositories/work_order_repository.dart';

class RateWorkOrderUseCase {
  final WorkOrderRepository repository;

  RateWorkOrderUseCase(this.repository);

  Future<void> execute({
    required String workOrderId,
    required int rating,
    String? comment,
  }) async {
    await repository.rateWorkOrder(workOrderId, rating, comment);
  }
}
