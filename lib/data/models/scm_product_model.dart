import 'package:zent_fe/domain/entities/scm_product.dart';

class ScmProductModel extends ScmProduct {
  ScmProductModel({
    required super.id,
    required super.customerId,
    required super.productModelCode,
    required super.productName,
    required super.serialNumber,
    required super.createdAt,
    required super.updatedAt,
  });

  /// SCM returns PascalCase JSON keys: ID, CustomerID, ProductModelCode, etc.
  factory ScmProductModel.fromJson(Map<String, dynamic> json) {
    return ScmProductModel(
      id: json['ID'] as String? ?? json['id'] as String,
      customerId:
          json['CustomerID'] as String? ?? json['customer_id'] as String,
      productModelCode:
          json['ProductModelCode'] as String? ??
          json['product_model_code'] as String,
      productName:
          json['ProductName'] as String? ?? json['product_name'] as String,
      serialNumber:
          json['SerialNumber'] as String? ?? json['serial_number'] as String,
      createdAt: DateTime.parse(
        (json['CreatedAt'] as String?) ?? (json['created_at'] as String),
      ),
      updatedAt: DateTime.parse(
        (json['UpdatedAt'] as String?) ?? (json['updated_at'] as String),
      ),
    );
  }
}
