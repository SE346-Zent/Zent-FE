class WarrantyInfo {
  final String warrantyStatus;
  final String supportStatus;
  final int supportDaysRemaining;
  final DateTime? startDate;
  final DateTime? endDate;

  WarrantyInfo({
    required this.warrantyStatus,
    required this.supportStatus,
    required this.supportDaysRemaining,
    this.startDate,
    this.endDate,
  });
}
