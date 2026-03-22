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
    required super.priority,
    required super.createdAt,
    required super.updatedAt,
    super.closedAt,
    required super.version,
    required super.adminId,
    required super.customerId,
    required super.technicianId,
  });

  factory WorkOrderModel.fromEntity(WorkOrder entity) {
    return WorkOrderModel(
      id: entity.id,
      title: entity.title,
      addressString: entity.addressString,
      status: entity.status,
      description: entity.description,
      rejectReason: entity.rejectReason,
      priority: entity.priority,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      closedAt: entity.closedAt,
      version: entity.version,
      adminId: entity.adminId,
      customerId: entity.customerId,
      technicianId: entity.technicianId,
    );
  }

  factory WorkOrderModel.fromJson(Map<String, dynamic> json) {
    return WorkOrderModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      addressString: json['address_string'] as String? ?? json['addressString'] as String? ?? '',
      status: _parseStatus(json['status_id'] as int? ?? json['statusId'] as int?),
      description: json['description'] as String? ?? '',
      rejectReason: json['reject_reason'] as String? ?? json['rejectReason'] as String? ?? '',
      priority: json['priority'] as int? ?? 0,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : (json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now()),
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : (json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : DateTime.now()),
      closedAt: json['closed_at'] != null 
          ? DateTime.parse(json['closed_at']) 
          : (json['closedAt'] != null ? DateTime.parse(json['closedAt']) : null),
      version: json['version'] as int? ?? 0,
      adminId: json['admin_id'] as String? ?? json['adminId'] as String? ?? '',
      customerId: json['customer_id'] as String? ?? json['customerId'] as String? ?? '',
      technicianId: json['technician_id'] as String? ?? json['technicianId'] as String? ?? '',
    );
  }

  static WorkOrderStatus _parseStatus(int? statusId) {
    if (statusId == null) return WorkOrderStatus.pending;
    if (statusId >= 0 && statusId < WorkOrderStatus.values.length) {
      return WorkOrderStatus.values[statusId];
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
      'priority': priority,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'closed_at': closedAt?.toIso8601String(),
      'version': version,
      'admin_id': adminId,
      'customer_id': customerId,
      'technician_id': technicianId,
    };
  }
}
