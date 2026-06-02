class WarrantyCheckResult {
  final String productId;
  final String serialNumber;
  final String productName;
  final String warrantyStatus;
  final DateTime? startDate;
  final DateTime? endDate;

  WarrantyCheckResult({
    required this.productId,
    required this.serialNumber,
    required this.productName,
    required this.warrantyStatus,
    this.startDate,
    this.endDate,
  });

  bool get isActive => warrantyStatus == 'active';
  bool get isExpired => warrantyStatus == 'expired';
  bool get isNone => warrantyStatus == 'none';
}
