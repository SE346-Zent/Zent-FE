class ProductWarranty {
  final String id;
  final String startDate;
  final String endDate;
  final String warrantyStatus;
  final int daysRemaining;

  ProductWarranty({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.warrantyStatus,
    required this.daysRemaining,
  });

  bool get isActive =>
      warrantyStatus.toLowerCase() != 'expired' &&
      warrantyStatus.toLowerCase() != 'voided' &&
      daysRemaining > 0;
}

class Product {
  final String id;
  final String name;
  final String model;
  final String serialNumber;
  final DateTime? warrantyUntil;
  final String? productImageUrl;
  // Zent BE warranty object
  final ProductWarranty? warranty;

  Product({
    required this.id,
    required this.name,
    required this.model,
    required this.serialNumber,
    this.warrantyUntil,
    this.productImageUrl,
    this.warranty,
  });
}
