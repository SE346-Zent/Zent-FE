import '../../domain/entities/product.dart';

class ProductWarrantyModel extends ProductWarranty {
  ProductWarrantyModel({
    required super.id,
    required super.startDate,
    required super.endDate,
    required super.warrantyStatus,
    required super.daysRemaining,
  });

  factory ProductWarrantyModel.fromJson(Map<String, dynamic> json) {
    return ProductWarrantyModel(
      id: json['id']?.toString() ?? '',
      startDate: json['startDate']?.toString() ?? '',
      endDate: json['endDate']?.toString() ?? '',
      warrantyStatus: json['warrantyStatus']?.toString() ?? '',
      daysRemaining: (json['daysRemaining'] as num?)?.toInt() ?? 0,
    );
  }
}

class ProductModel extends Product {
  ProductModel({
    required super.id,
    required super.name,
    required super.model,
    required super.serialNumber,
    super.warrantyUntil,
    super.productImageUrl,
    super.warranty,
  });

  /// Parse from Zent BE `/api/v1/inventory/products/mine` response item.
  ///
  /// Shape:
  /// ```json
  /// {
  ///   "productId": "uuid",
  ///   "productName": "...",
  ///   "serialNumber": "...",
  ///   "imageUrl": "...",
  ///   "warranty": { "id": "...", "startDate": "...", "endDate": "...",
  ///                 "warrantyStatus": "Active", "daysRemaining": 120 }
  /// }
  /// ```
  factory ProductModel.fromZentJson(Map<String, dynamic> json) {
    final warrantyJson = json['warranty'] as Map<String, dynamic>?;
    final warranty = warrantyJson != null
        ? ProductWarrantyModel.fromJson(warrantyJson)
        : null;

    return ProductModel(
      id: json['productId']?.toString() ?? '',
      name: json['productName']?.toString() ?? '',
      model: '',        // Zent BE doesn't return model code in this endpoint
      serialNumber: json['serialNumber']?.toString() ?? '',
      productImageUrl: json['imageUrl']?.toString(),
      warranty: warranty,
    );
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as String,
      name: json['name'] as String,
      model: json['model'] as String,
      serialNumber: json['serialNumber'] as String,
      warrantyUntil: json['warrantyUntil'] != null
          ? DateTime.parse(json['warrantyUntil'] as String)
          : null,
      productImageUrl: json['productImageUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'model': model,
      'serialNumber': serialNumber,
      'warrantyUntil': warrantyUntil?.toIso8601String(),
      'productImageUrl': productImageUrl,
    };
  }
}
