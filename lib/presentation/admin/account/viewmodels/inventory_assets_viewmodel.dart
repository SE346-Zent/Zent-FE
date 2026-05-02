import 'package:flutter/material.dart';
import 'package:zent_fe/presentation/common/core/app_assets.dart';

class InventoryAsset {
  final String type;
  final String imagePath;
  final String mtm;
  final String title;
  final String description;
  final int stockCount;

  InventoryAsset({
    required this.type,
    required this.imagePath,
    required this.mtm,
    required this.title,
    required this.description,
    required this.stockCount,
  });
}

class InventoryAssetsViewModel extends ChangeNotifier {
  List<InventoryAsset> assets = [
    InventoryAsset(
      type: 'PRODUCT',
      imagePath: AppAssets.assetLaptopA,
      mtm: '123456',
      title: 'LAPTOP A',
      description: 'Some description here',
      stockCount: 12,
    ),
    InventoryAsset(
      type: 'PART',
      imagePath: AppAssets.assetPartA,
      mtm: '123456',
      title: 'PART A',
      description: 'Some description here',
      stockCount: 0,
    ),
  ];
}
