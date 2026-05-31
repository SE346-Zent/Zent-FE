import 'package:flutter/material.dart';
import 'package:zent_fe/domain/entities/product.dart';
import 'package:zent_fe/domain/usecases/product/get_my_products_usecase.dart';
import 'package:zent_fe/domain/usecases/auth/get_current_user_usecase.dart';
import 'package:zent_fe/domain/usecases/inventory/zent_inventory_usecases.dart';
import 'package:zent_fe/presentation/common/core/app_assets.dart';
import 'package:zent_fe/presentation/common/core/safe_change_notifier.dart';
import 'package:intl/intl.dart';

class WarrantyHistoryItem {
  final String orderNumber;
  final String date;
  WarrantyHistoryItem(this.orderNumber, this.date);
}

class DetailedProductViewModel extends ChangeNotifier with SafeChangeNotifier {
  final GetMyProductsUseCase getMyProductsUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final GetProductDetailUseCase? getProductDetailUseCase;

  DetailedProductViewModel({
    required this.getMyProductsUseCase,
    required this.getCurrentUserUseCase,
    this.getProductDetailUseCase,
  });

  String? currentSerialNumber;
  Product? product;
  List<WarrantyHistoryItem> history = [];
  bool isLoading = false;

  Future<void> init(String serialNumber) async {
    currentSerialNumber = serialNumber;
    isLoading = true;
    notifyListeners();

    try {
      final user = await getCurrentUserUseCase.execute();
      if (user != null) {
        final products = await getMyProductsUseCase.execute(user.id);
        // Find product by serial number
        try {
          product = products.firstWhere((p) => p.serialNumber == serialNumber);
          debugPrint(
            '=== [DetailedProductViewModel] Found product: ${product?.name}, productImageUrl: ${product?.productImageUrl}, imagePath: $imagePath ===',
          );
        } catch (_) {
          product = null;
        }
      }
    } catch (e) {
      debugPrint("Error fetching detailed product: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }

    // Mock Data for History (Could be fetched in future)
    history = [
      WarrantyHistoryItem('#WO-12345', 'Oct 15'),
      WarrantyHistoryItem('#WO-12344', 'Oct 14'),
    ];
    notifyListeners();
  }

  // UI Helpers
  String get imagePath {
    if (product != null &&
        product!.productImageUrl != null &&
        product!.productImageUrl!.isNotEmpty) {
      return product!.productImageUrl!;
    }
    if (product == null) return AppAssets.laptopA;
    if (product!.name.toLowerCase().contains('laptop b')) {
      return AppAssets.laptopB;
    }
    return AppAssets.laptopA;
  }

  String get warrantyDate {
    if (product?.warrantyUntil == null) return 'No Warranty';
    return DateFormat('MMM dd, yyyy').format(product!.warrantyUntil!);
  }
}
