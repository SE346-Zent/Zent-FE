import '../../domain/entities/work_order.dart';
import '../../domain/entities/enums/work_order_status.dart';

class WorkOrderModel extends WorkOrder {
  WorkOrderModel({
    required super.id,
    required super.title,
    required super.addressString,
    required super.status,
    super.statusId,
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
    super.technicianRating,
    required super.workOrderNum,
    super.rejectionPhotos = const [],
    super.productName,
    super.appointment,
    super.building,
    super.city,
    super.country,
    super.email,
    super.firstName,
    super.symptomName,
    super.phoneNumber,
    super.addressLine1,
    super.customerAvatarUrl,
    super.technicianAvatarUrl,
    super.startAt,
  });

  factory WorkOrderModel.fromEntity(WorkOrder entity) {
    return WorkOrderModel(
      id: entity.id,
      title: entity.title,
      addressString: entity.addressString,
      status: entity.status,
      statusId: entity.statusId,
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
      technicianRating: entity.technicianRating,
      workOrderNum: entity.workOrderNum,
      rejectionPhotos: entity.rejectionPhotos,
      productName: entity.productName,
      appointment: entity.appointment,
      building: entity.building,
      city: entity.city,
      country: entity.country,
      email: entity.email,
      firstName: entity.firstName,
      symptomName: entity.symptomName,
      phoneNumber: entity.phoneNumber,
      addressLine1: entity.addressLine1,
      customerAvatarUrl: entity.customerAvatarUrl,
      technicianAvatarUrl: entity.technicianAvatarUrl,
      startAt: entity.startAt,
    );
  }

  factory WorkOrderModel.fromJson(Map<String, dynamic> json) {
    final rawStatusVal =
        json['work_order_status_id'] ??
        json['status_id'] ??
        json['statusId'] ??
        json['status'];
    int? parsedStatusId;
    if (rawStatusVal is int) {
      parsedStatusId = rawStatusVal;
    } else if (rawStatusVal is String) {
      parsedStatusId = int.tryParse(rawStatusVal);
      if (parsedStatusId == null) {
        final s = rawStatusVal
            .toLowerCase()
            .replaceAll('_', '')
            .replaceAll(' ', '');
        if (s == 'pending' || s.contains('pending')) {
          parsedStatusId = 1;
        } else if (s == 'assigned' || s.contains('assigned')) {
          parsedStatusId = 2;
        } else if (s == 'inprogress' || s == 'inprog' || s.contains('prog')) {
          parsedStatusId = 3;
        } else if (s == 'complete' ||
            s == 'completed' ||
            s == 'closed' ||
            s.contains('complete') ||
            s.contains('closed')) {
          parsedStatusId = 4;
        } else if (s == 'rejectinreview' || s.contains('rejectinreview')) {
          parsedStatusId = 5;
        } else if (s == 'rejected' || s.contains('rejected')) {
          parsedStatusId = 6;
        }
      }
    }

    return WorkOrderModel(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      title:
          json['productName'] as String? ??
          json['title'] as String? ??
          json['workOrderNumber'] as String? ??
          json['workOrderNum'] as String? ??
          '',
      addressString: _buildAddress(json),
      symptomName:
          json['symptomName'] as String? ?? json['symptom_name'] as String?,
      status: _parseStatus(rawStatusVal),
      statusId: parsedStatusId,
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
          ? DateTime.tryParse(json['createdAt']) ?? DateTime.now()
          : (json['created_at'] != null
                ? DateTime.parse(json['created_at'])
                : DateTime.now()),
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt']) ?? DateTime.now()
          : (json['updated_at'] != null
                ? DateTime.parse(json['updated_at'])
                : DateTime.now()),
      closedAt: json['closedAt'] != null
          ? DateTime.tryParse(json['closedAt'])
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
      technicianRating:
          (json['technicianAverageRating'] as num?)?.toDouble() ??
          (json['averageRating'] as num?)?.toDouble() ??
          (json['technician_rating'] as num?)?.toDouble() ??
          (json['technician'] is Map
                  ? (json['technician'] as Map)['averageRating'] as num?
                  : null)
              ?.toDouble() ??
          (json['technician'] is Map
                  ? (json['technician'] as Map)['rating'] as num?
                  : null)
              ?.toDouble(),
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
      productName:
          json['productName'] as String? ?? json['product_name'] as String?,
      appointment: json['appointment'] != null
          ? DateTime.tryParse(json['appointment'] as String)
          : null,
      building: json['building'] as String?,
      city: json['ward'] as String? ?? json['city'] as String?,
      country: json['country'] as String?,
      email: json['email'] as String?,
      firstName: json['first_name'] as String? ?? json['firstName'] as String?,
      phoneNumber:
          json['phoneNumber'] as String? ??
          json['phone_number'] as String? ??
          json['phone'] as String?,
      addressLine1: json['address'] as String?,
      customerAvatarUrl:
          json['customerAvatarUrl'] as String? ??
          json['customer_avatar_url'] as String? ??
          json['customerAvatarName'] as String? ??
          json['customer_avatar_name'] as String? ??
          json['customerImageUrl'] as String? ??
          json['customer_image_url'] as String? ??
          json['customerImage'] as String? ??
          json['customer_image'] as String? ??
          json['customerAvatar'] as String? ??
          json['customer_avatar'] as String? ??
          json['oppositeImage'] as String? ??
          json['opposite_image'] as String? ??
          json['oppositeImageUrl'] as String? ??
          json['opposite_image_url'] as String? ??
          (json['customer'] is Map
              ? (json['customer'] as Map)['avatarUrl']?.toString()
              : null) ??
          (json['customer'] is Map
              ? (json['customer'] as Map)['avatar_url']?.toString()
              : null) ??
          (json['customer'] is Map
              ? (json['customer'] as Map)['avatarImageName']?.toString()
              : null) ??
          (json['customer'] is Map
              ? (json['customer'] as Map)['avatarName']?.toString()
              : null) ??
          (json['customer'] is Map
              ? (json['customer'] as Map)['avatar']?.toString()
              : null),
      technicianAvatarUrl:
          json['technicianAvatarUrl'] as String? ??
          json['technician_avatar_url'] as String? ??
          json['technicianAvatarName'] as String? ??
          json['technician_avatar_name'] as String? ??
          json['technicianImageUrl'] as String? ??
          json['technician_image_url'] as String? ??
          json['technicianImage'] as String? ??
          json['technician_image'] as String? ??
          json['technicianAvatar'] as String? ??
          json['technician_avatar'] as String? ??
          (json['technician'] is Map
              ? (json['technician'] as Map)['avatarUrl']?.toString()
              : null) ??
          (json['technician'] is Map
              ? (json['technician'] as Map)['avatar_url']?.toString()
              : null) ??
          (json['technician'] is Map
              ? (json['technician'] as Map)['avatarImageName']?.toString()
              : null) ??
          (json['technician'] is Map
              ? (json['technician'] as Map)['avatarName']?.toString()
              : null) ??
          (json['technician'] is Map
              ? (json['technician'] as Map)['avatar']?.toString()
              : null),
      startAt: json['startedAt'] != null
          ? DateTime.tryParse(json['startedAt'] as String)
          : (json['started_at'] != null
                ? DateTime.tryParse(json['started_at'] as String)
                : (json['startAt'] != null
                      ? DateTime.tryParse(json['startAt'] as String)
                      : (json['start_at'] != null
                            ? DateTime.tryParse(json['start_at'] as String)
                            : null))),
    );
  }

  static WorkOrderStatus _parseStatus(dynamic statusVal) {
    if (statusVal == null) return WorkOrderStatus.pending;

    var val = statusVal;
    if (statusVal is String) {
      final parsedInt = int.tryParse(statusVal);
      if (parsedInt != null) {
        val = parsedInt;
      }
    }

    // Explicit mapping based on DB:
    // 1: Pending, 2: Assigned, 3: InProg, 4: Closed, 5: Reject_InReview, 6: Rejected
    if (val is int) {
      switch (val) {
        case 1:
          return WorkOrderStatus.pending;
        case 2:
          return WorkOrderStatus.assigned;
        case 3:
          return WorkOrderStatus
              .assigned; // In progress -> assigned frontend state
        case 4:
          return WorkOrderStatus.complete; // Closed -> complete frontend state
        case 5:
          return WorkOrderStatus.rejectInReview;
        case 6:
          return WorkOrderStatus.rejected;
        default:
          return WorkOrderStatus.pending;
      }
    }

    if (statusVal is String) {
      final s = statusVal.toLowerCase().replaceAll('_', '').replaceAll(' ', '');
      if (s == 'pending') {
        return WorkOrderStatus.pending;
      }
      if (s == 'inprogress' || s == 'assigned' || s == 'inprog') {
        return WorkOrderStatus.assigned;
      }
      if (s == 'complete' || s == 'completed' || s == 'closed') {
        return WorkOrderStatus.complete;
      }
      if (s == 'rejectinreview' || s == 'reject_inreview') {
        return WorkOrderStatus.rejectInReview;
      }
      if (s == 'rejected') {
        return WorkOrderStatus.rejected;
      }
      // fallback partial match
      if (s.contains('pending')) {
        return WorkOrderStatus.pending;
      }
      if (s.contains('prog') || s.contains('assigned')) {
        return WorkOrderStatus.assigned;
      }
      if (s.contains('complete') || s.contains('closed')) {
        return WorkOrderStatus.complete;
      }
      if (s.contains('rejectinreview')) {
        return WorkOrderStatus.rejectInReview;
      }
      if (s.contains('rejected')) {
        return WorkOrderStatus.rejected;
      }
    }

    return WorkOrderStatus.pending;
  }

  static String _buildAddress(Map<String, dynamic> json) {
    // Try pre-built string first
    final prebuilt =
        json['addressString'] as String? ?? json['address_string'] as String?;
    String addressString = prebuilt ?? '';

    if (addressString.isEmpty) {
      // Build from WorkOrderDetails fields: address, building, ward, city, province, country
      final parts = <String>[];
      final address = json['address'] as String?;
      final building = json['building'] as String?;
      final ward = json['ward'] as String? ?? json['Ward'] as String?;
      final city = json['city'] as String?;
      final province = json['province'] as String?;
      final country = json['country'] as String?;

      if (building != null && building.isNotEmpty) parts.add(building);
      if (address != null && address.isNotEmpty) parts.add(address);
      if (ward != null && ward.isNotEmpty) parts.add(ward);
      if (city != null && city.isNotEmpty) parts.add(city);
      if (province != null && province.isNotEmpty) parts.add(province);
      if (country != null && country.isNotEmpty) parts.add(country);

      addressString = parts.join(', ');
    }

    // Clean address strings by replacing standalone HN and HCM
    addressString = addressString
        .replaceAll(RegExp(r'\bHCM\b'), 'Thành phố Hồ Chí Minh')
        .replaceAll(RegExp(r'\bHN\b'), 'Thành phố Hà Nội');

    return addressString;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'address': addressString,
      'status': status.name,
      'statusId': statusId,
      'description': description,
      'reject_reason': rejectReason,
      'refusal_note': refusalNote,
      'priority': priority,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'closedAt': closedAt?.toIso8601String(),
      'version': version,
      'adminId': adminId,
      'customerId': customerId,
      'customer_name': customerName,
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
      'phoneNumber': phoneNumber,
      'addressLine1': addressLine1,
      'symptomName': symptomName,
      'technician_name': technicianName,
      'work_order_num': workOrderNum,
      'rejection_photos': rejectionPhotos,
      'customerAvatarUrl': customerAvatarUrl,
      'technicianAvatarUrl': technicianAvatarUrl,
      'start_at': startAt?.toIso8601String(),
      'startedAt': startAt?.toIso8601String(),
    };
  }
}
