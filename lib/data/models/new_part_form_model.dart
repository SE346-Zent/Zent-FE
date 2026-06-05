import 'package:zent_fe/domain/entities/new_part_form.dart';

class NewPartFormModel extends NewPartForm {
  NewPartFormModel({
    required super.id,
    required super.partNumber,
    required super.partTypeName,
    required super.serialNumber,
    super.workOrderId,
    required super.workOrderNumber,
    required super.status,
    required super.createdAt,
    super.updatedAt,
    super.description,
    super.modelCode,
    super.denialReason,
    required super.photoUrls,
    super.reviewedBy,
    super.reviewedAt,
  });

  factory NewPartFormModel.fromJson(Map<String, dynamic> json) {
    final photoUrlsJson = json['photoUrls'] as List<dynamic>?;
    final photoUrlsList =
        photoUrlsJson?.map((e) => e.toString()).toList() ?? <String>[];

    return NewPartFormModel(
      id: json['id'] as String? ?? '',
      partNumber: json['partNumber'] as String? ?? '',
      partTypeName: json['partTypeName'] as String? ?? '',
      serialNumber: json['serialNumber'] as String? ?? '',
      workOrderId: json['workOrderId'] as String?,
      workOrderNumber:
          (json['workOrderNumber'] ??
                  json['work_order_number'] ??
                  json['workOrderNo'] ??
                  json['workOrder'] ??
                  '')
              .toString(),
      status: json['status'] as String? ?? 'Pending',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'] as String)
          : null,
      description: json['description'] as String?,
      modelCode: json['modelCode'] as String?,
      denialReason: json['denialReason'] as String?,
      photoUrls: photoUrlsList,
      reviewedBy: (json['approverName'] ?? json['reviewedBy']) as String?,
      reviewedAt: json['approvedAt'] != null
          ? DateTime.tryParse(json['approvedAt'] as String)
          : json['rejectedAt'] != null
          ? DateTime.tryParse(json['rejectedAt'] as String)
          : json['reviewedAt'] != null
          ? DateTime.tryParse(json['reviewedAt'] as String)
          : null,
    );
  }
}

class NewPartFormStatusSummaryModel extends NewPartFormStatusSummary {
  NewPartFormStatusSummaryModel({
    required super.pending,
    required super.approved,
    required super.rejected,
  });

  factory NewPartFormStatusSummaryModel.fromJson(Map<String, dynamic> json) {
    return NewPartFormStatusSummaryModel(
      pending: json['pending'] as int? ?? 0,
      approved: json['approved'] as int? ?? 0,
      rejected: json['rejected'] as int? ?? 0,
    );
  }
}
