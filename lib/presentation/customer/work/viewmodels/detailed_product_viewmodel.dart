import 'package:flutter/material.dart';
import 'package:zent_fe/presentation/common/core/app_assets.dart';
import 'products_viewmodel.dart';

class WarrantyHistoryItem {
  final String orderNumber;
  final String date;
  WarrantyHistoryItem(this.orderNumber, this.date);
}

class DetailedProductViewModel extends ChangeNotifier {
  String? currentSerialNumber;
  ProductItemData? product;
  List<WarrantyHistoryItem> history = [];

  void init(String serialNumber) {
    currentSerialNumber = serialNumber;

    final productsVM = ProductsViewModel();
    try {
      product = productsVM.products.firstWhere(
        (p) => p.serialNumber == serialNumber,
      );
    } catch (e) {
      product = ProductItemData(
        id: serialNumber,
        name: 'Unknown Product',
        serialNumber: serialNumber,
        warrantyDate: 'Unknown',
        status: 'N/A',
        imagePath: AppAssets.laptopA,
      );
    }

    // Mock Data
    history = [
      WarrantyHistoryItem('#WO-12345', 'Oct 15'),
      WarrantyHistoryItem('#WO-12344', 'Oct 14'),
    ];
    notifyListeners();
  }
}
