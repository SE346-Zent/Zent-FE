import 'package:zent_fe/domain/entities/warranty_check_result.dart';

class WarrantyCheckResultModel extends WarrantyCheckResult {
  WarrantyCheckResultModel({
    required super.productId,
    required super.serialNumber,
    required super.productName,
    required super.warrantyStatus,
    super.startDate,
    super.endDate,
  });

  factory WarrantyCheckResultModel.fromJson(Map<String, dynamic> json) {
    return WarrantyCheckResultModel(
      productId: json['productId'] as String,
      serialNumber: json['serialNumber'] as String,
      productName: json['productName'] as String,
      warrantyStatus: json['warrantyStatus'] as String,
      startDate: json['startDate'] != null
          ? DateTime.tryParse(json['startDate'] as String)
          : null,
      endDate: json['endDate'] != null
          ? DateTime.tryParse(json['endDate'] as String)
          : null,
    );
  }
}
