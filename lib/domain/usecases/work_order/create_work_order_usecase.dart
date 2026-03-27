import '../../repositories/work_order_repository.dart';

class CreateWorkOrderUseCase {
  final WorkOrderRepository repository;

  CreateWorkOrderUseCase(this.repository);

  Future<void> execute({
    required String productId,
    required String description,
    required String customerId,
  }) async {
    return await repository.createWorkOrder(
      productId: productId,
      description: description,
      customerId: customerId,
    );
  }
}
