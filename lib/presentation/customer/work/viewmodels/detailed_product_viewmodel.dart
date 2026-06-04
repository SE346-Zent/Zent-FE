import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import 'package:zent_fe/domain/entities/product_detail.dart';
import 'package:zent_fe/domain/usecases/inventory/zent_inventory_usecases.dart';
import 'package:zent_fe/presentation/common/core/app_assets.dart';
import 'package:zent_fe/presentation/common/core/safe_change_notifier.dart';

class DetailedProductViewModel extends ChangeNotifier with SafeChangeNotifier {
  final GetProductDetailUseCase getProductDetailUseCase;

  DetailedProductViewModel({required this.getProductDetailUseCase});

  ProductDetail? productDetail;
  bool isLoading = false;

  Future<void> init(String productId) async {
    isLoading = true;
    notifyListeners();

    try {
      productDetail = await getProductDetailUseCase.execute(productId);
      debugPrint(
        '=== [DetailedProductViewModel] Loaded product detail: ${productDetail?.title} ===',
      );
    } catch (e) {
      debugPrint(
        '=== [DetailedProductViewModel] Error loading product detail: $e ===',
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ── UI Computed Properties ──────────────────────────────────────

  String get imagePath {
    if (productDetail != null &&
        productDetail!.productImageUrl != null &&
        productDetail!.productImageUrl!.isNotEmpty) {
      return productDetail!.productImageUrl!;
    }
    if (productDetail == null) return AppAssets.laptopA;
    if (productDetail!.modelName.toLowerCase().contains('laptop b')) {
      return AppAssets.laptopB;
    }
    return AppAssets.laptopA;
  }

  String get purchaseDate {
    if (productDetail?.warranty?.startDate != null) {
      return DateFormat(
        'MMM dd, yyyy',
      ).format(productDetail!.warranty!.startDate!);
    }
    return 'NA';
  }

  String get warrantyEndDate {
    if (productDetail?.warranty?.endDate != null) {
      return DateFormat(
        'MMM dd, yyyy',
      ).format(productDetail!.warranty!.endDate!);
    }
    return 'No Warranty';
  }

  /// Returns the first active work order from history, if any.
  String? get activeWorkOrderId {
    final history = productDetail?.workOrderHistory ?? [];
    for (final item in history) {
      final s = item.status.toLowerCase();
      if (s == 'pending' || s == 'assigned' || s == 'rejectinreview') {
        return item.workOrderId;
      }
    }
    return null;
  }
}
