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
      id: '0563ce89-9a1f-4ef0-8e00-090377248b5e',
      name: 'Laptop A',
      serialNumber: 'NA-1234568',
      warrantyDate: 'Oct 20, 2026',
      status: 'Active',
      imagePath: AppAssets.laptopA,
    ),
    ProductItemData(
      id: '0925e498-3fb0-4734-addb-97bcf8c4acb2',
      name: 'Laptop B',
      serialNumber: 'NA-8765432',
      warrantyDate: 'Oct 20, 2026',
      status: 'Expiring',
      imagePath: AppAssets.laptopB,
    ),
  ];
}
