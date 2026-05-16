import 'enums/work_order_status.dart';

class WorkOrder {
  final String id;
  final String title;
  final String addressString;
  final WorkOrderStatus status;
  final String description;
  final String rejectReason;
  final int priority;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? closedAt;
  final int version;
  final String adminId;
  final String customerId;
  final String technicianId;
  final String? workOrderNum;
  final String? customerName;
  final String? productName;
  final DateTime? appointment;
  final String? building;
  final String? city;
  final String? country;
  final String? email;
  final String? firstName;

  WorkOrder({
    required this.id,
    required this.title,
    required this.addressString,
    required this.status,
    required this.description,
    required this.rejectReason,
    required this.priority,
    required this.createdAt,
    required this.updatedAt,
    this.closedAt,
    required this.version,
    required this.adminId,
    required this.customerId,
    required this.technicianId,
    this.workOrderNum,
    this.customerName,
    this.productName,
    this.appointment,
    this.building,
    this.city,
    this.country,
    this.email,
    this.firstName,
  });
}
