class NewPartForm {
  final String id;
  final String partNumber;
  final String partTypeName;
  final String serialNumber;
  final String? workOrderId;
  final String workOrderNumber;
  final String status;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? description;
  final String? modelCode;
  final String? denialReason;
  final List<String> photoUrls;

  NewPartForm({
    required this.id,
    required this.partNumber,
    required this.partTypeName,
    required this.serialNumber,
    this.workOrderId,
    required this.workOrderNumber,
    required this.status,
    required this.createdAt,
    this.updatedAt,
    this.description,
    this.modelCode,
    this.denialReason,
    required this.photoUrls,
  });
}

class NewPartFormStatusSummary {
  final int pending;
  final int approved;
  final int rejected;

  NewPartFormStatusSummary({
    required this.pending,
    required this.approved,
    required this.rejected,
  });
}
