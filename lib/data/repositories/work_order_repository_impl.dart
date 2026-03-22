import '../../domain/entities/work_order.dart';
import '../../domain/repositories/work_order_repository.dart';
import '../datasources/remote/order_remote_datasource.dart';

class WorkOrderRepositoryImpl implements WorkOrderRepository {
  final OrderRemoteDataSource remoteDataSource;

  WorkOrderRepositoryImpl({required this.remoteDataSource});

  @override
  Future<WorkOrder> getSingleWorkOrder({required String id}) async {
    return await remoteDataSource.getSingleWorkOrder(id);
  }

  @override
  Future<List<WorkOrder>> getManyWorkOrders({required String userId}) async {
    return await remoteDataSource.getManyWorkOrders(userId);
  }
}
