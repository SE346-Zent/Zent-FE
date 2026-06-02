import 'package:zent_fe/presentation/common/core/safe_change_notifier.dart';
import 'package:flutter/material.dart';
import 'package:zent_fe/domain/usecases/inventory/get_inventory_usecases.dart';
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

class InventoryAssetsViewModel extends ChangeNotifier with SafeChangeNotifier {
  final GetScmProductsUseCase getScmProductsUseCase;
  final GetPartCatalogUseCase getPartCatalogUseCase;

  InventoryAssetsViewModel({
    required this.getScmProductsUseCase,
    required this.getPartCatalogUseCase,
  });

  List<InventoryAsset> assets = [];
  bool isLoading = false;

  Future<void> loadAssets() async {
    isLoading = true;
    notifyListeners();

    try {
      final (products, _) = await getScmProductsUseCase.execute(
        page: 1,
        limit: 50,
      );
      final (catalogEntries, _) = await getPartCatalogUseCase.execute(
        page: 1,
        limit: 50,
      );

      final List<InventoryAsset> allAssets = [];

      for (final product in products) {
        allAssets.add(
          InventoryAsset(
            type: 'PRODUCT',
            imagePath: AppAssets.assetLaptopA,
            mtm: product.productModelCode,
            title: product.productName,
            description: 'SN: ${product.serialNumber}',
            stockCount: 1,
          ),
        );
      }

      for (final entry in catalogEntries) {
        allAssets.add(
          InventoryAsset(
            type: 'PART',
            imagePath: AppAssets.assetPartA,
            mtm: entry.partNumber,
            title: entry.mfgNumber ?? entry.partNumber,
            description: entry.description ?? 'General',
            stockCount: entry.partTypesId != null ? 1 : 0,
          ),
        );
      }

      assets = allAssets;
    } catch (e) {
      debugPrint('Error loading inventory assets: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
