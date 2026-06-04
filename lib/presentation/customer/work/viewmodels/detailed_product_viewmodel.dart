import 'package:flutter/material.dart';
import 'package:zent_fe/domain/entities/product.dart';
import 'package:zent_fe/domain/entities/product_detail.dart';
import 'package:zent_fe/domain/usecases/product/get_my_products_usecase.dart';
import 'package:zent_fe/domain/usecases/auth/get_current_user_usecase.dart';
import 'package:zent_fe/domain/usecases/inventory/zent_inventory_usecases.dart';
import 'package:zent_fe/presentation/common/core/app_assets.dart';
import 'package:zent_fe/presentation/common/core/safe_change_notifier.dart';
import 'package:intl/intl.dart';

import 'package:zent_fe/domain/usecases/work_order/get_many_work_orders_usecase.dart';
import 'package:zent_fe/domain/entities/enums/work_order_status.dart';
import 'package:zent_fe/domain/entities/work_order.dart';

class WarrantyHistoryItem {
  final String orderNumber;
  final String date;
  WarrantyHistoryItem(this.orderNumber, this.date);
}

class DetailedProductViewModel extends ChangeNotifier with SafeChangeNotifier {
  final GetMyProductsUseCase getMyProductsUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final GetProductDetailUseCase? getProductDetailUseCase;
  final GetManyWorkOrdersUseCase? getManyWorkOrdersUseCase;

  DetailedProductViewModel({
    required this.getMyProductsUseCase,
    required this.getCurrentUserUseCase,
    this.getProductDetailUseCase,
    this.getManyWorkOrdersUseCase,
  });

  String? currentSerialNumber;
  Product? product;
  ProductDetail? productDetail;
  List<WarrantyHistoryItem> history = [];
  WorkOrder? activeWorkOrderForProduct;
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

        if (product != null && getProductDetailUseCase != null) {
          try {
            productDetail = await getProductDetailUseCase!.execute(product!.id);
            debugPrint(
              '=== [DetailedProductViewModel] Found product detail: ${productDetail?.title}, warranty info: ${productDetail?.warranty?.warrantyStatus} ===',
            );
          } catch (e) {
            debugPrint('=== [DetailedProductViewModel] Error loading product detail: $e ===');
          }
        }

        if (product != null && getManyWorkOrdersUseCase != null) {
          try {
            final allOrders = await getManyWorkOrdersUseCase!.execute(limit: 1000);
            debugPrint('=== [DetailedProductViewModel] Total orders from API: ${allOrders.length} ===');
            for (var o in allOrders) {
              debugPrint('Order title: "${o.title}", productName: "${o.productName}", workOrderNum: "${o.workOrderNum}"');
            }
            final matchedOrders = allOrders.where((wo) {
              final woProd = (wo.productName ?? wo.title).toLowerCase();
              final currentProd = product!.name.toLowerCase();
              final words = currentProd.split(' ');
              final matchBase = words.length >= 3
                  ? '${words[0]} ${words[1]} ${words[2]}'
                  : currentProd;
              final matched = woProd.contains(matchBase.toLowerCase());
              debugPrint('Comparing woProd: "$woProd" with matchBase: "$matchBase" -> Matched: $matched');
              return matched;
            }).toList();

            // Sort by createdAt descending
            matchedOrders.sort((a, b) => b.createdAt.compareTo(a.createdAt));

            // Find first active one for this product
            try {
              activeWorkOrderForProduct = matchedOrders.firstWhere(
                (o) =>
                    o.status == WorkOrderStatus.pending ||
                    o.status == WorkOrderStatus.assigned ||
                    o.status == WorkOrderStatus.rejectInReview,
              );
            } catch (_) {
              activeWorkOrderForProduct = null;
            }
            debugPrint('=== [DetailedProductViewModel] activeWorkOrderForProduct: ${activeWorkOrderForProduct?.id} ===');

            history = matchedOrders.map((wo) {
              final dateStr = DateFormat('MMM dd').format(wo.createdAt);
              return WarrantyHistoryItem('#${wo.workOrderNum}', dateStr);
            }).toList();
          } catch (e) {
            debugPrint("Error fetching work order history: $e");
          }
        }
      }
    } catch (e) {
      debugPrint("Error fetching detailed product: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // UI Helpers
  String get imagePath {
    if (product != null &&
        product!.productImageUrl != null &&
        product!.productImageUrl!.isNotEmpty) {
      return product!.productImageUrl!;
    }
    if (productDetail != null &&
        productDetail!.productImageUrl != null &&
        productDetail!.productImageUrl!.isNotEmpty) {
      return productDetail!.productImageUrl!;
    }
    if (product == null) return AppAssets.laptopA;
    if (product!.name.toLowerCase().contains('laptop b')) {
      return AppAssets.laptopB;
    }
    return AppAssets.laptopA;
  }

  String get purchaseDate {
    if (productDetail?.warranty?.startDate != null) {
      return DateFormat('MMM dd, yyyy').format(productDetail!.warranty!.startDate!);
    }
    return 'NA';
  }

  String get warrantyDate {
    if (productDetail?.warranty?.endDate != null) {
      return DateFormat('MMM dd, yyyy').format(productDetail!.warranty!.endDate!);
    }
    if (product?.warrantyUntil == null) return 'No Warranty';
    return DateFormat('MMM dd, yyyy').format(product!.warrantyUntil!);
  }
}
