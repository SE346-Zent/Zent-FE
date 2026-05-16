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
    super.workOrderNum,
    super.customerName,
    super.productName,
    super.appointment,
    super.building,
    super.city,
    super.country,
    super.email,
    super.firstName,
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
      workOrderNum: entity.workOrderNum,
      customerName: entity.customerName,
      productName: entity.productName,
      appointment: entity.appointment,
      building: entity.building,
      city: entity.city,
      country: entity.country,
      email: entity.email,
      firstName: entity.firstName,
    );
  }

  factory WorkOrderModel.fromJson(Map<String, dynamic> json) {
    return WorkOrderModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      addressString:
          json['address']?.toString() ??
          json['addressString']?.toString() ??
          '',
      status: _parseStatus(json['status']?.toString()),
      description: json['description']?.toString() ?? '',
      rejectReason: json['rejectReason']?.toString() ?? '',
      priority: json['priority'] as int? ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt']) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt']) ?? DateTime.now()
          : DateTime.now(),
      closedAt: json['closedAt'] != null
          ? DateTime.tryParse(json['closedAt'])
          : null,

      version: json['version'] as int? ?? 0,
      adminId: json['adminId']?.toString() ?? '',
      customerId: json['customerId']?.toString() ?? '',
      technicianId: json['technicianId']?.toString() ?? '',
      workOrderNum: json['workOrderNum']?.toString(),
      customerName: json['customerName']?.toString(),
      productName: json['productName']?.toString(),
      appointment: json['appointment'] != null
          ? DateTime.tryParse(json['appointment'])
          : null,
      building: json['building']?.toString(),
      city: json['city']?.toString(),
      country: json['country']?.toString(),
      email: json['email']?.toString(),
      firstName: json['firstName']?.toString(),
    );
  }

  static WorkOrderStatus _parseStatus(String? statusStr) {
    if (statusStr == null || statusStr.isEmpty) {
      return WorkOrderStatus.pending;
    }
    final normalizedStatus = statusStr.toLowerCase().replaceAll('_', '');
    switch (normalizedStatus) {
      case 'pending':
        return WorkOrderStatus.pending;
      case 'inprog':
      case 'inprogress':
        return WorkOrderStatus.inProg;
      case 'complete':
      case 'completed':
        return WorkOrderStatus.complete;
      case 'rejectinreview':
        return WorkOrderStatus.rejectInReview;
      case 'rejected':
      case 'reject':
        return WorkOrderStatus.rejected;
      default:
        return WorkOrderStatus.pending;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'address': addressString,
      'status': status.name,
      'description': description,
      'rejectReason': rejectReason,
      'priority': priority,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'closedAt': closedAt?.toIso8601String(),
      'version': version,
      'adminId': adminId,
      'customerId': customerId,
      'technicianId': technicianId,
      'workOrderNum': workOrderNum,
      'customerName': customerName,
      'productName': productName,
      'appointment': appointment?.toIso8601String(),
      'building': building,
      'city': city,
      'country': country,
      'email': email,
      'firstName': firstName,
    };
  }
}
