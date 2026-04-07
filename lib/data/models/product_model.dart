import '../../domain/entities/product.dart';

class ProductModel extends Product {
  ProductModel({
    required super.id,
    required super.name,
    required super.model,
    required super.serialNumber,
    super.warrantyUntil,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as String,
      name: json['name'] as String,
      model: json['model'] as String,
      serialNumber: json['serialNumber'] as String,
      warrantyUntil: json['warrantyUntil'] != null
          ? DateTime.parse(json['warrantyUntil'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'model': model,
      'serialNumber': serialNumber,
      'warrantyUntil': warrantyUntil?.toIso8601String(),
    };
  }
}
