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
  final String modelCode;

  PartModel({
    required this.title,
    required this.partNo,
    required this.commodity,
    required this.status,
    this.imageUrl,
    required this.modelCode,
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

  // --- Loading states ---
  bool isLoading = false;
  bool isLoadingMore = false;
  bool hasMorePages = false;

  // --- Pagination state ---
  static const int _pageSize = 20;
  int _currentPage = 1;
  String? _productId;
  String _modelCode = '';

  // --- Catalog cache (fetched once) ---
  Map<String, dynamic> _catalogMap = {};

  final TextEditingController searchController = TextEditingController();

  String sortAlphabet = 'None';
  String filterStatus = 'None';

  Future<void> init(String serialNumber, {String modelCode = ''}) async {
    _modelCode = modelCode;
    searchController.addListener(_onSearchChanged);
    await fetchParts(serialNumber, modelCode: modelCode);
  }

  Future<void> fetchParts(String serialNumber, {String modelCode = ''}) async {
    _modelCode = modelCode;
    _currentPage = 1;
    allParts = [];
    filteredParts = [];
    hasMorePages = false;
    isLoading = true;
    notifyListeners();

    try {
      final user = await getCurrentUserUseCase.execute();
      if (user == null) return;

      // Resolve local product info
      final products = await getMyProductsUseCase.execute(user.id);
      String? productId;
      try {
        product = products.firstWhere((p) => p.serialNumber == serialNumber);
        productId = product?.id;
      } catch (_) {
        product = null;
      }

      // Try resolving SCM product ID
      try {
        final (scmProducts, _) = await getScmProductsUseCase.execute(
          query: serialNumber,
        );
        final scmMatch = scmProducts.firstWhere(
          (p) => p.serialNumber == serialNumber,
        );
        productId = scmMatch.id;
      } catch (_) {
        // Fall back to resolved local product ID
      }

      _productId = productId;

      if (_productId == null) {
        allParts = [];
        _filterParts();
        return;
      }

      // Fetch part catalog once and cache it
      final (catalogList, _) = await getPartCatalogUseCase.execute(
        page: 1,
        limit: 1000,
      );
      _catalogMap = {for (var entry in catalogList) entry.id: entry};

      // Fetch first page of parts
      await _fetchPage(1, append: false);
    } catch (e) {
      debugPrint('Error fetching parts for $serialNumber: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Fetches [page] of parts. If [append] is true, appends to existing list.
  Future<void> _fetchPage(int page, {required bool append}) async {
    final (parts, meta) = await getPartsUseCase.execute(
      productId: _productId,
      page: page,
      limit: _pageSize,
    );

    final newModels = parts.map((part) {
      final catalog = _catalogMap[part.partCatalogId];
      return PartModel(
        title: catalog?.description ?? part.partTypeName ?? 'Part',
        partNo: catalog?.partNumber ?? part.serialNumber,
        commodity: part.partTypeName ?? 'General',
        status:
            part.partConditionName ??
            (part.partConditionId == 1 ? 'Available' : 'Unavailable'),
        imageUrl: part.imageUrl,
        modelCode: _modelCode.isNotEmpty
            ? _modelCode
            : (product?.model ?? 'NA'),
      );
    }).toList();

    if (append) {
      allParts.addAll(newModels);
    } else {
      allParts = newModels;
    }

    _currentPage = page;
    hasMorePages = meta.page < meta.totalPages;

    debugPrint(
      '[PartsVM] page=$page totalPages=${meta.totalPages} loaded=${allParts.length} hasMore=$hasMorePages',
    );

    _filterParts();
  }

  /// Call this when the user scrolls near the bottom.
  Future<void> loadMore() async {
    if (isLoadingMore || !hasMorePages || _productId == null) return;
    isLoadingMore = true;
    notifyListeners();
    try {
      await _fetchPage(_currentPage + 1, append: true);
    } catch (e) {
      debugPrint('Error loading more parts: $e');
    } finally {
      isLoadingMore = false;
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
