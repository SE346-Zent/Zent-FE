class ScmProduct {
  final String id;
  final String customerId;
  final String productModelCode;
  final String productName;
  final String serialNumber;
  final DateTime createdAt;
  final DateTime updatedAt;

  ScmProduct({
    required this.id,
    required this.customerId,
    required this.productModelCode,
    required this.productName,
    required this.serialNumber,
    required this.createdAt,
    required this.updatedAt,
  });
}
