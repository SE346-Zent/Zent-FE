import '../../domain/entities/work_order.dart';
import '../../domain/entities/work_order_completion_draft.dart';
import '../../domain/repositories/work_order_repository.dart';
import '../datasources/local/work_order_local_datasource.dart';
import '../datasources/remote/work_order_remote_datasource.dart';
import '../models/create_work_order_request.dart';
import '../models/work_order_completion_draft_model.dart';

class WorkOrderRepositoryImpl implements WorkOrderRepository {
  final WorkOrderRemoteDataSource remoteDataSource;
  final WorkOrderLocalDataSource localDataSource;

  WorkOrderRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<void> createWorkOrder(CreateWorkOrderRequest request) async {
    return await remoteDataSource.createWorkOrder(request);
  }

  @override
  Future<WorkOrder> getSingleWorkOrder({required String id}) async {
    return await remoteDataSource.getSingleWorkOrder(id);
  }

  @override
  Future<List<WorkOrder>> getManyWorkOrders({required String userId}) async {
    return await remoteDataSource.getManyWorkOrders(userId);
  }

  @override
  Future<List<WorkOrder>> getActiveRepairs({required String customerId}) async {
    return await remoteDataSource.getActiveRepairs(customerId);
  }

  @override
  Future<void> saveWorkOrderDraft(WorkOrderCompletionDraft draft) async {
    final model = WorkOrderCompletionDraftModel.fromEntity(draft);
    await localDataSource.cacheWorkOrderDraft(model);
  }

  @override
  Future<WorkOrderCompletionDraft?> getWorkOrderDraft(
    String workOrderId,
  ) async {
    return await localDataSource.getWorkOrderDraft(workOrderId);
  }
}
