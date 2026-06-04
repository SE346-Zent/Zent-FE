import 'package:zent_fe/presentation/common/core/safe_change_notifier.dart';
import 'package:flutter/material.dart';
import 'package:zent_fe/domain/usecases/inventory/get_inventory_usecases.dart';
import 'package:zent_fe/domain/usecases/product/get_my_products_usecase.dart';
import 'package:zent_fe/domain/usecases/auth/get_current_user_usecase.dart';
import 'package:zent_fe/domain/entities/product.dart';

class PartModel {
  final String title;
  final String partNo;
  final String commodity;
  final String status;
  final String? imageUrl;

  PartModel({
    required this.title,
    required this.partNo,
    required this.commodity,
    required this.status,
    this.imageUrl,
  });
}

class PartsViewModel extends ChangeNotifier with SafeChangeNotifier {
  final GetPartsUseCase getPartsUseCase;
  final GetMyProductsUseCase getMyProductsUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final GetPartCatalogUseCase getPartCatalogUseCase;
  final GetScmProductsUseCase getScmProductsUseCase;

  PartsViewModel({
    required this.getPartsUseCase,
    required this.getMyProductsUseCase,
    required this.getCurrentUserUseCase,
    required this.getPartCatalogUseCase,
    required this.getScmProductsUseCase,
  });

  Product? product;
  List<PartModel> allParts = [];
  List<PartModel> filteredParts = [];
  bool isLoading = false;

  final TextEditingController searchController = TextEditingController();

  String sortAlphabet = 'None';
  String filterStatus = 'None';

  Future<void> init(String serialNumber) async {
    searchController.addListener(_onSearchChanged);
    await fetchParts(serialNumber);
  }

  Future<void> fetchParts(String serialNumber) async {
    isLoading = true;
    notifyListeners();

    try {
      final user = await getCurrentUserUseCase.execute();
      if (user != null) {
        final products = await getMyProductsUseCase.execute(user.id);
        String? productId;
        try {
          product = products.firstWhere((p) => p.serialNumber == serialNumber);
          productId = product?.id;
        } catch (_) {
          product = null;
        }

        // Resolve SCM product ID by querying SCM database using the serial number first
        try {
          final (scmProducts, _) = await getScmProductsUseCase.execute(query: serialNumber);
          final scmMatch = scmProducts.firstWhere(
            (p) => p.serialNumber == serialNumber,
          );
          productId = scmMatch.id;
        } catch (_) {
          // Fall back to resolved local product ID
        }

        if (productId != null) {
          // Fetch all part catalog entries to map descriptions/names in-memory
          final (catalogList, _) = await getPartCatalogUseCase.execute(
            page: 1,
            limit: 1000,
          );
          final catalogMap = {for (var entry in catalogList) entry.id: entry};

          // Fetch parts for this specific product ID
          final (parts, _) = await getPartsUseCase.execute(
            productId: productId,
            page: 1,
            limit: 1000,
          );
          
          allParts = parts.map((part) {
            final catalog = catalogMap[part.partCatalogId];
            return PartModel(
              title: catalog?.partNumber ?? part.serialNumber,
              partNo: catalog?.mfgNumber ?? part.id,
              commodity: catalog?.description ?? 'General',
              status: part.partConditionId == 1 ? 'Available' : 'Unavailable',
              imageUrl: part.imageUrl,
            );
          }).toList();
        } else {
          allParts = [];
        }
      }
      _filterParts();
    } catch (e) {
      debugPrint('Error fetching parts for $serialNumber: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void setSortAlphabet(String val) {
    sortAlphabet = val;
    _filterParts();
  }

  void setFilterStatus(String val) {
    filterStatus = val;
    _filterParts();
  }

  void _onSearchChanged() {
    _filterParts();
  }

  void _filterParts() {
    final query = searchController.text.toLowerCase().trim();
    var temp = allParts.where((part) {
      final matchSearch =
          part.title.toLowerCase().contains(query) ||
          part.partNo.toLowerCase().contains(query);
      final matchStatus = filterStatus == 'None' || part.status == filterStatus;
      return matchSearch && matchStatus;
    }).toList();

    if (sortAlphabet == 'A-Z') {
      temp.sort((a, b) => a.title.compareTo(b.title));
    } else if (sortAlphabet == 'Z-A') {
      temp.sort((a, b) => b.title.compareTo(a.title));
    }

    filteredParts = temp;
    notifyListeners();
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.dispose();
  }
}
