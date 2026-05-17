import '../../repositories/work_order_repository.dart';

class DenyRefusalUseCase {
  final WorkOrderRepository repository;

  DenyRefusalUseCase(this.repository);

  Future<void> execute(String id) async {
    return await repository.denyRefusal(id);
  }
}
