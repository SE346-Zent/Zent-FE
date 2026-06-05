class RejectForm {
  final String id; // rejectFormId
  final String workOrderId;
  final String workOrderNumber;
  final String technicianName;
  final String customerName;
  final String reason;
  final String explanation;
  final bool approved;
  final DateTime? createdAt;
  final List<String> photoUrls;

  const RejectForm({
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
}
