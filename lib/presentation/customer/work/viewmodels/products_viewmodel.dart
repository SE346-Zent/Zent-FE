import 'package:flutter/material.dart';
import 'package:zent_fe/presentation/common/core/app_assets.dart';

class ProductItemData {
  final String id;
  final String name;
  final String serialNumber;
  final String warrantyDate;
  final String status;
  final String imagePath;

  ProductItemData({
    required this.id,
    required this.name,
    required this.serialNumber,
    required this.warrantyDate,
    required this.status,
    required this.imagePath,
  });
}

class ProductsViewModel extends ChangeNotifier {
  final List<ProductItemData> products = [
    ProductItemData(
      id: '155630d2-54c0-46ef-abff-dd797fcadea7',
      name: 'Laptop A',
      serialNumber: 'NA-1234568',
      warrantyDate: 'Oct 20, 2026',
      status: 'Active',
      imagePath: AppAssets.laptopA,
    ),
    ProductItemData(
      id: '5d530009-ff8d-4e48-abbe-57850174fb76',
      name: 'Laptop B',
      serialNumber: 'NA-8765432',
      warrantyDate: 'Oct 20, 2026',
      status: 'Expiring',
      imagePath: AppAssets.laptopB,
    ),
  ];
}
