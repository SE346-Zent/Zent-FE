import '../entities/work_order.dart';

abstract class WorkOrderRepository {
  Future<WorkOrder> getSingleWorkOrder({required String id});
  Future<List<WorkOrder>> getManyWorkOrders({required String userId});
}
