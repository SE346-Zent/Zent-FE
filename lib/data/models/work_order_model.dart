import '../../domain/entities/work_order.dart';
import '../../domain/entities/enums/work_order_status.dart';

class WorkOrderModel extends WorkOrder {
  WorkOrderModel({
    required super.id,
    required super.title,
    required super.addressString,
    required super.status,
    required super.description,
    required super.rejectReason,
    super.refusalNote = '',
    required super.priority,
    required super.createdAt,
    required super.updatedAt,
    super.closedAt,
    required super.version,
    required super.adminId,
    required super.customerId,
    super.customerName = '',
    required super.technicianId,
    super.technicianName,
    required super.workOrderNum,
    super.rejectionPhotos = const [],
  });

  factory WorkOrderModel.fromEntity(WorkOrder entity) {
    return WorkOrderModel(
      id: entity.id,
      title: entity.title,
      addressString: entity.addressString,
      status: entity.status,
      description: entity.description,
      rejectReason: entity.rejectReason,
      refusalNote: entity.refusalNote,
      priority: entity.priority,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      closedAt: entity.closedAt,
      version: entity.version,
      adminId: entity.adminId,
      customerId: entity.customerId,
      customerName: entity.customerName,
      technicianId: entity.technicianId,
      technicianName: entity.technicianName,
      workOrderNum: entity.workOrderNum,
      rejectionPhotos: entity.rejectionPhotos,
    );
  }

  factory WorkOrderModel.fromJson(Map<String, dynamic> json) {
    return WorkOrderModel(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      title:
          json['productName'] as String? ??
          json['title'] as String? ??
          json['workOrderNumber'] as String? ??
          json['workOrderNum'] as String? ??
          '',
      addressString:
          json['address'] as String? ??
          json['addressString'] as String? ??
          json['address_string'] as String? ??
          '',
      status: _parseStatus(
        json['work_order_status_id'] ??
            json['status_id'] ??
            json['statusId'] ??
            json['status'],
      ),
      description: json['description'] as String? ?? '',
      rejectReason:
          json['reject_reason'] as String? ??
          json['rejectReason'] as String? ??
          json['symptomName'] as String? ??
          '',
      refusalNote:
          json['refusal_note'] as String? ??
          json['refusalNote'] as String? ??
          '',
      priority: json['priority'] as int? ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : (json['created_at'] != null
                ? DateTime.parse(json['created_at'])
                : DateTime.now()),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : (json['updated_at'] != null
                ? DateTime.parse(json['updated_at'])
                : DateTime.now()),
      closedAt: json['closedAt'] != null
          ? DateTime.parse(json['closedAt'])
          : (json['closed_at'] != null
                ? DateTime.parse(json['closed_at'])
                : null),
      version: json['version'] as int? ?? 0,
      adminId: (json['adminId'] ?? json['admin_id'] ?? '').toString(),
      customerId: (json['customerId'] ?? json['customer_id'] ?? '').toString(),
      customerName:
          json['customerName'] as String? ??
          json['customer_name'] as String? ??
          '',
      technicianId:
          (json['technicianId'] ??
                  json['technician_id'] ??
                  json['tech_id'] ??
                  '')
              .toString(),
      technicianName:
          json['technicianName'] as String? ??
          json['technician_name'] as String?,
      workOrderNum:
          json['workOrderNum'] as String? ??
          json['workOrderNumber'] as String? ??
          json['work_order_num'] as String? ??
          '',
      rejectionPhotos:
          (json['evidenceImageUrls'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          (json['rejection_photos'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
    );
  }

  static WorkOrderStatus _parseStatus(dynamic statusVal) {
    if (statusVal == null) return WorkOrderStatus.pending;

    // Explicit mapping based on DB:
    // 1: Pending, 2: Assigned, 3: InProg, 4: Closed, 5: Reject_InReview, 6: Rejected
    if (statusVal is int) {
      switch (statusVal) {
        case 1:
          return WorkOrderStatus.pending;
        case 2:
          return WorkOrderStatus.inProg; // Map Assigned to inProg for UI
        case 3:
          return WorkOrderStatus.inProg;
        case 4:
          return WorkOrderStatus.complete;
        case 5:
          return WorkOrderStatus.rejectInReview;
        case 6:
          return WorkOrderStatus.rejected;
        default:
          return WorkOrderStatus.pending;
      }
    }

    if (statusVal is String) {
      final s = statusVal.toLowerCase();
      if (s.contains('pending')) {
        return WorkOrderStatus.pending;
      }
      if (s.contains('prog') || s.contains('assigned')) {
        return WorkOrderStatus.inProg;
      }
      if (s.contains('complete') || s.contains('closed')) {
        return WorkOrderStatus.complete;
      }
      if (s.contains('reject_inreview') || s.contains('rejectinreview')) {
        return WorkOrderStatus.rejectInReview;
      }
      if (s.contains('rejected')) {
        return WorkOrderStatus.rejected;
      }
    }

    return WorkOrderStatus.pending;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'address_string': addressString,
      'status_id': status.index,
      'description': description,
      'reject_reason': rejectReason,
      'refusal_note': refusalNote,
      'priority': priority,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'closed_at': closedAt?.toIso8601String(),
      'version': version,
      'admin_id': adminId,
      'customer_id': customerId,
      'customer_name': customerName,
      'technician_id': technicianId,
      'technician_name': technicianName,
      'work_order_num': workOrderNum,
      'rejection_photos': rejectionPhotos,
    };
  }
}
