class Product {
  final String id;
  final String name;
  final String model;
  final String serialNumber;
  final DateTime? warrantyUntil;
  final String? productImageUrl;

  Product({
    required this.id,
    required this.name,
    required this.model,
    required this.serialNumber,
    this.warrantyUntil,
    this.productImageUrl,
  });
}
