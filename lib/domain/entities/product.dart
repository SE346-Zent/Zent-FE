class Product {
  final String id;
  final String name;
  final String model;
  final String serialNumber;
  final DateTime? warrantyUntil;

  Product({
    required this.id,
    required this.name,
    required this.model,
    required this.serialNumber,
    this.warrantyUntil,
  });
}
