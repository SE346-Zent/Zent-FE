import 'package:zent_fe/domain/entities/warranty_info.dart';
import 'package:zent_fe/domain/entities/work_order_history_item.dart';

class ProductDetail {
  final String productId;
  final String title;
  final String modelCode;
  final String modelName;
  final String serialNumber;
  final String? productImageUrl;
  final WarrantyInfo? warranty;
  final List<WorkOrderHistoryItem> workOrderHistory;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProductDetail({
    required this.productId,
    required this.title,
    required this.modelCode,
    required this.modelName,
    required this.serialNumber,
    this.productImageUrl,
    this.warranty,
    required this.workOrderHistory,
    required this.createdAt,
    required this.updatedAt,
  });
}
