import 'package:zent_fe/domain/entities/product_detail.dart';
import 'package:zent_fe/domain/entities/warranty_info.dart';
import 'package:zent_fe/domain/entities/work_order_history_item.dart';

class ProductDetailModel extends ProductDetail {
  ProductDetailModel({
    required super.productId,
    required super.title,
    required super.modelCode,
    required super.modelName,
    required super.serialNumber,
    super.productImageUrl,
    super.warranty,
    required super.workOrderHistory,
    required super.createdAt,
    required super.updatedAt,
  });

  factory ProductDetailModel.fromJson(Map<String, dynamic> json) {
    return ProductDetailModel(
      productId: json['productId'] as String,
      title: json['title'] as String,
      modelCode: json['modelCode'] as String,
      modelName: json['modelName'] as String,
      serialNumber: json['serialNumber'] as String,
      productImageUrl: json['productImageUrl'] as String?,
      warranty: json['warranty'] != null
          ? _parseWarrantyInfo(json['warranty'] as Map<String, dynamic>)
          : null,
      workOrderHistory: (json['workOrderHistory'] as List<dynamic>)
          .map((e) => _parseWorkOrderHistoryItem(e as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  static WarrantyInfo _parseWarrantyInfo(Map<String, dynamic> json) {
    return WarrantyInfo(
      warrantyStatus: json['warrantyStatus'] as String,
      supportStatus: json['supportStatus'] as String,
      supportDaysRemaining: json['supportDaysRemaining'] as int,
      startDate: json['startDate'] != null
          ? DateTime.tryParse(json['startDate'] as String)
          : null,
      endDate: json['endDate'] != null
          ? DateTime.tryParse(json['endDate'] as String)
          : null,
    );
  }

  static WorkOrderHistoryItem _parseWorkOrderHistoryItem(
    Map<String, dynamic> json,
  ) {
    return WorkOrderHistoryItem(
      workOrderId: json['workOrderId'] as String,
      workOrderNumber: json['workOrderNumber'] as String,
      status: json['status'] as String,
      date: json['date'] as String,
    );
  }
}
