import '../../data/models/create_work_order_request.dart';
import '../../data/models/complete_work_order_request.dart';
import '../../data/models/refuse_work_order_request.dart';
import '../entities/work_order.dart';
import '../entities/work_order_completion_draft.dart';

abstract class WorkOrderRepository {
  Future<void> createWorkOrder(CreateWorkOrderRequest request);
  Future<void> completeWorkOrder(String id, CompleteWorkOrderRequest request);
  Future<void> refuseWorkOrder(String id, RefuseWorkOrderRequest request);
  Future<void> approveRefusal(String id, ApproveRefusalRequest request);
  Future<void> denyRefusal(String id);
  Future<void> changeAppointment(String id, DateTime newDate);
  Future<void> reassignWorkOrder(String id, String newTechnicianId);
  Future<void> cancelWorkOrder(String id, String? reason);
  Future<List<Map<String, dynamic>>> getTechnicians();
  Future<void> assignWorkOrder(String id, String technicianId);
  Future<List<WorkOrder>> getWorkOrders({
    int page = 1,
    int limit = 20,
    String? role,
    String? province,
    String? technicianId,
    String? date,
  });

  Future<WorkOrder> getWorkOrderDetail({required String id});
  Future<List<WorkOrder>> getActiveRepairs({required String customerId});
  Future<void> startWorkOrder(String id, double latitude, double longitude);
  Future<void> uploadClosingFormPhoto(
    String id,
    String filePath,
    double latitude,
    double longitude,
    String phase,
  );
  Future<Map<String, dynamic>> getWorkOrderHistory(String id);
  Future<void> rateWorkOrder(String id, int rating, String? comment);

  // Drafts (Local)
  Future<void> saveWorkOrderDraft(WorkOrderCompletionDraft draft);
  Future<WorkOrderCompletionDraft?> getWorkOrderDraft(String workOrderId);
  Future<void> clearWorkOrderDraft(String workOrderId);
}
