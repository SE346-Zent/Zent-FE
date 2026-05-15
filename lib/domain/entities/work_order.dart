import 'enums/work_order_status.dart';

class WorkOrder {
  final String id;
  final String title;
  final String addressString;
  final WorkOrderStatus status;
  final String description;
  final String rejectReason;
  final String refusalNote;
  final int priority;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? closedAt;
  final int version;
  final String adminId;
  final String customerId;
  final String customerName;
  final String technicianId;
  final String? technicianName;

  WorkOrder({
    required this.id,
    required this.title,
    required this.addressString,
    required this.status,
    required this.description,
    required this.rejectReason,
    this.refusalNote = '',
    required this.priority,
    required this.createdAt,
    required this.updatedAt,
    this.closedAt,
    required this.version,
    required this.adminId,
    required this.customerId,
    this.customerName = '',
    required this.technicianId,
    this.technicianName,
  });

  String get address => addressString;
  String get refusalReason => rejectReason;
}
