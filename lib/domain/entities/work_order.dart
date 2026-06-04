import 'enums/work_order_status.dart';

class WorkOrder {
  final String id;
  final String title;
  final String addressString;
  final WorkOrderStatus status;
  final int? statusId;
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
  final double? technicianRating;
  final String workOrderNum;
  final List<String> rejectionPhotos;
  final String? productName;
  final DateTime? appointment;
  final String? building;
  final String? city;
  final String? country;
  final String? email;
  final String? firstName;
  final String? symptomName;
  final String? phoneNumber;
  final String? addressLine1;

  final String? customerAvatarUrl;
  final DateTime? startAt;

  WorkOrder({
    required this.id,
    required this.title,
    required this.addressString,
    required this.status,
    this.statusId,
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
    this.technicianRating,
    required this.workOrderNum,
    this.rejectionPhotos = const [],
    this.productName,
    this.appointment,
    this.building,
    this.city,
    this.country,
    this.email,
    this.firstName,
    this.symptomName,
    this.phoneNumber,
    this.addressLine1,
    this.customerAvatarUrl,
    this.startAt,
  });

  String get address => addressString;
  String get refusalReason => rejectReason;
}
