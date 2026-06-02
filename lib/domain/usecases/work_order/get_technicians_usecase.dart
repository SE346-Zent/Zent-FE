import '../../repositories/work_order_repository.dart';

class GetTechniciansUseCase {
  final WorkOrderRepository repository;
  GetTechniciansUseCase({required this.repository});

  Future<List<Map<String, dynamic>>> execute() async {
    return await repository.getTechnicians();
  }
}
