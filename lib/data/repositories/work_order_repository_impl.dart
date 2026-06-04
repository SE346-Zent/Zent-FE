import '../../domain/entities/work_order.dart';
import '../../domain/entities/work_order_completion_draft.dart';
import '../../domain/entities/reject_form.dart';
import '../../domain/repositories/work_order_repository.dart';
import '../datasources/local/work_order_local_datasource.dart';
import '../datasources/remote/work_order_remote_datasource.dart';
import '../models/create_work_order_request.dart';
import '../models/complete_work_order_request.dart';
import '../models/refuse_work_order_request.dart';
import '../models/edit_work_order_request.dart';
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
  Future<void> completeWorkOrder(
    String id,
    CompleteWorkOrderRequest request,
  ) async {
    return await remoteDataSource.completeWorkOrder(id, request);
  }

  @override
  Future<void> refuseWorkOrder(
    String id,
    RefuseWorkOrderRequest request,
  ) async {
    return await remoteDataSource.refuseWorkOrder(id, request);
  }

  @override
  Future<void> approveRefusal(String id, ApproveRefusalRequest request) async {
    return await remoteDataSource.approveRefusal(id, request);
  }

  @override
  Future<void> denyRefusal(String id) async {
    return await remoteDataSource.denyRefusal(id);
  }

  @override
  Future<void> changeAppointment(String id, DateTime newDate) {
    return remoteDataSource.changeAppointment(id, newDate);
  }

  @override
  Future<void> reassignWorkOrder(String id, String newTechnicianId) {
    return remoteDataSource.reassignWorkOrder(id, newTechnicianId);
  }

  @override
  Future<void> cancelWorkOrder(String id, String? reason) {
    return remoteDataSource.cancelWorkOrder(id, reason);
  }

  @override
  Future<List<Map<String, dynamic>>> getTechnicians() async {
    return await remoteDataSource.getTechnicians();
  }

  @override
  Future<void> assignWorkOrder(String id, String technicianId) async {
    return await remoteDataSource.assignWorkOrder(id, technicianId);
  }

  @override
  Future<WorkOrder> getWorkOrderDetail({required String id}) async {
    return await remoteDataSource.getWorkOrderDetail(id);
  }

  @override
  Future<List<WorkOrder>> getWorkOrders({
    int page = 1,
    int limit = 20,
    String? role,
    String? province,
    String? technicianId,
    String? date,
  }) async {
    return await remoteDataSource.getWorkOrders(
      page: page,
      limit: limit,
      role: role,
      province: province,
      technicianId: technicianId,
      date: date,
    );
  }

  @override
  Future<List<WorkOrder>> getActiveRepairs({required String customerId}) async {
    return await remoteDataSource.getActiveRepairs(customerId);
  }

  @override
  Future<void> startWorkOrder(
    String id,
    double latitude,
    double longitude,
  ) async {
    return await remoteDataSource.startWorkOrder(id, latitude, longitude);
  }

  @override
  Future<void> uploadClosingFormPhoto(
    String id,
    String filePath,
    double latitude,
    double longitude,
    String phase,
  ) async {
    return await remoteDataSource.uploadClosingFormPhoto(
      id,
      filePath,
      latitude,
      longitude,
      phase,
    );
  }

  @override
  Future<Map<String, dynamic>> getWorkOrderHistory(String id) async {
    return await remoteDataSource.getWorkOrderHistory(id);
  }

  @override
  Future<void> rateWorkOrder(String id, int rating, String? comment) async {
    return await remoteDataSource.rateWorkOrder(id, rating, comment);
  }

  @override
  Future<void> editWorkOrder(
    String workOrderNumber,
    EditWorkOrderRequest request,
  ) async {
    return await remoteDataSource.editWorkOrder(workOrderNumber, request);
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

  @override
  Future<void> clearWorkOrderDraft(String workOrderId) async {
    await localDataSource.clearWorkOrderDraft(workOrderId);
  }

  @override
  Future<List<RejectForm>> getRejectForms({String? province}) async {
    final models = await remoteDataSource.getRejectForms(province: province);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<RejectForm> getRejectFormById(
    String rejectFormId, {
    String workOrderId = '',
  }) async {
    final model = await remoteDataSource.getRejectFormById(
      rejectFormId,
      workOrderId: workOrderId,
    );
    return model.toEntity();
  }
}
