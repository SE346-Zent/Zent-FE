import 'package:flutter/material.dart';
import 'package:zent_fe/presentation/common/core/app_assets.dart';

class ProductItemData {
  final String name;
  final String serialNumber;
  final String warrantyDate;
  final String status;
  final String imagePath;

  ProductItemData({
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
      name: 'Laptop A',
      serialNumber: 'NA-1234568',
      warrantyDate: 'Oct 20, 2026',
      status: 'Active',
      imagePath: AppAssets.laptopA,
    ),
    ProductItemData(
      name: 'Laptop B',
      serialNumber: 'NA-8765432',
      warrantyDate: 'Oct 20, 2026',
      status: 'Expiring',
      imagePath: AppAssets.laptopB,
    ),
  ];
}
