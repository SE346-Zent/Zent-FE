import 'package:flutter/material.dart';
import 'package:zent_fe/domain/entities/product.dart';
import 'package:zent_fe/domain/usecases/product/get_my_products_usecase.dart';
import 'package:zent_fe/domain/usecases/auth/get_current_user_usecase.dart';
import 'package:zent_fe/presentation/common/core/app_assets.dart';

class ProductsViewModel extends ChangeNotifier {
  final GetMyProductsUseCase getMyProductsUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;

  ProductsViewModel({
    required this.getMyProductsUseCase,
    required this.getCurrentUserUseCase,
  });

  List<Product> _products = [];
  List<Product> get products => _products;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      final user = await getCurrentUserUseCase.execute();
      if (user != null) {
        _products = await getMyProductsUseCase.execute(user.id);
      }
    } catch (e) {
      debugPrint("Error fetching products: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Helper to get image for a product
  String getProductImage(Product product) {
    if (product.name.toLowerCase().contains('laptop a'))
      return AppAssets.laptopA;
    if (product.name.toLowerCase().contains('laptop b'))
      return AppAssets.laptopB;
    return AppAssets.laptopA; // Default
  }

  String getProductStatus(Product product) {
    if (product.warrantyUntil == null) return 'No Warranty';
    if (product.warrantyUntil!.isBefore(DateTime.now())) return 'Expired';
    if (product.warrantyUntil!.isBefore(
      DateTime.now().add(const Duration(days: 30)),
    )) {
      return 'Expiring';
    }
    return 'Active';
  }
}
