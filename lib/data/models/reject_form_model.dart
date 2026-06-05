import '../../domain/entities/reject_form.dart';

class RejectFormModel {
  final String id;
  final String workOrderId;
  final String workOrderNumber;
  final String technicianName;
  final String customerName;
  final String reason;
  final String explanation;
  final bool approved;
  final DateTime? createdAt;
  final List<String> photoUrls;

  const RejectFormModel({
    required this.id,
    required this.workOrderId,
    required this.workOrderNumber,
    required this.technicianName,
    required this.customerName,
    required this.reason,
    this.explanation = '',
    required this.approved,
    this.createdAt,
    this.photoUrls = const [],
  });

  /// Parses a row from GET /work_orders/reject_forms (list endpoint)
  factory RejectFormModel.fromJson(Map<String, dynamic> json) {
    return RejectFormModel(
      id: json['rejectFormId'] as String? ?? json['id'] as String? ?? '',
      workOrderId: json['workOrderId'] as String? ?? '',
      workOrderNumber: json['workOrderNumber'] as String? ?? '',
      technicianName: json['technicianName'] as String? ?? '',
      customerName: json['customerName'] as String? ?? '',
      reason: json['reason'] as String? ?? '',
      explanation: json['explanation'] as String? ?? '',
      approved: json['approved'] as bool? ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      photoUrls:
          (json['photoUrls'] as List?)?.map((e) => e.toString()).toList() ??
          const [],
    );
  }

  /// Parses a response from GET /work_orders/reject_forms/{id} (detail endpoint).
  /// The detail response does not include workOrderId/workOrderNumber/technicianName/customerName.
  /// Pass [workOrderId] from the caller context so they can be set.
  factory RejectFormModel.fromDetailJson(
    Map<String, dynamic> json, {
    String workOrderId = '',
  }) {
    final parsedWorkOrderId =
        json['workOrderId'] as String? ??
        json['work_order_id'] as String? ??
        json['workOrder']?['id'] as String? ??
        workOrderId;
    return RejectFormModel(
      id: json['id'] as String? ?? '',
      workOrderId: parsedWorkOrderId,
      workOrderNumber:
          json['workOrderNumber'] as String? ??
          json['workOrder']?['workOrderNum'] as String? ??
          json['workOrder']?['workOrderNumber'] as String? ??
          '',
      technicianName:
          json['technicianName'] as String? ??
          json['technician']?['fullName'] as String? ??
          '',
      customerName:
          json['customerName'] as String? ??
          json['customer']?['fullName'] as String? ??
          '',
      reason: json['reason'] as String? ?? '',
      explanation: json['explanation'] as String? ?? '',
      approved: json['approved'] as bool? ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      photoUrls:
          (json['photoUrls'] as List?)?.map((e) => e.toString()).toList() ??
          const [],
    );
  }

  RejectForm toEntity() {
    return RejectForm(
      id: id,
      workOrderId: workOrderId,
      workOrderNumber: workOrderNumber,
      technicianName: technicianName,
      customerName: customerName,
      reason: reason,
      explanation: explanation,
      approved: approved,
      createdAt: createdAt,
      photoUrls: photoUrls,
    );
  }
}
