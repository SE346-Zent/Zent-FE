import 'package:zent_fe/presentation/common/core/safe_change_notifier.dart';
import 'package:flutter/material.dart';
import 'package:zent_fe/domain/entities/inventory_part.dart';
import 'package:zent_fe/domain/usecases/inventory/get_inventory_usecases.dart';

enum PartStatus { available, unavailable }

class PartSearchItemModel {
  final String imageUrl;
  final String name;
  final String partNo;
  final String commodity;
  final PartStatus status;

  PartSearchItemModel({
    required this.imageUrl,
    required this.name,
    required this.partNo,
    required this.commodity,
    required this.status,
  });
}

class PartSearchViewModel extends ChangeNotifier with SafeChangeNotifier {
  final GetPartsUseCase getPartsUseCase;

  PartSearchViewModel({required this.getPartsUseCase}) {
    _loadInitialData();
  }

  // States
  bool _isLoading = false;
  bool _isLoadingMore = false;
  String? _errorMessage;
  List<PartSearchItemModel> _parts = [];
  String _searchQuery = '';

  // Getters
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  String? get errorMessage => _errorMessage;
  List<PartSearchItemModel> get parts => _filteredParts;
  String get searchQuery => _searchQuery;

  List<PartSearchItemModel> get _filteredParts {
    if (_searchQuery.isEmpty) return _parts;
    return _parts
        .where(
          (part) =>
              part.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              part.partNo.toLowerCase().contains(_searchQuery.toLowerCase()),
        )
        .toList();
  }

  Future<void> _loadInitialData() async {
    _isLoading = true;
    notifyListeners();

    try {
      final (parts, _) = await getPartsUseCase.execute(page: 1, limit: 50);
      _parts = parts.map(_mapPartToModel).toList();
    } catch (e) {
      _errorMessage = 'Failed to load parts: $e';
      debugPrint('Error loading parts: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  PartSearchItemModel _mapPartToModel(InventoryPart part) {
    return PartSearchItemModel(
      imageUrl: 'https://picsum.photos/48/48?random=${part.id.hashCode}',
      name: part.serialNumber.isNotEmpty ? part.serialNumber : 'Part',
      partNo: part.id,
      commodity: part.partCatalogId ?? 'General',
      status: part.partConditionId != null
          ? PartStatus.available
          : PartStatus.unavailable,
    );
  }

  /// Search remotely via API
  Future<void> searchRemotely(String query) async {
    if (query.isEmpty) {
      await _loadInitialData();
      return;
    }

    _isLoading = true;
    _searchQuery = query;
    notifyListeners();

    try {
      final (parts, _) = await getPartsUseCase.execute(
        page: 1,
        limit: 50,
        query: query,
      );
      _parts = parts.map(_mapPartToModel).toList();
    } catch (e) {
      _errorMessage = 'Search failed: $e';
      debugPrint('Error searching parts: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load more parts for infinite scrolling
  Future<void> loadMore() async {
    if (_isLoadingMore || _isLoading) return;
    _isLoadingMore = true;
    notifyListeners();

    try {
      final (moreParts, _) = await getPartsUseCase.execute(
        page: (_parts.length / 50).ceil() + 1,
        limit: 50,
        query: _searchQuery.isNotEmpty ? _searchQuery : null,
      );
      _parts.addAll(moreParts.map(_mapPartToModel));
    } catch (e) {
      _errorMessage = 'Failed to load more parts: $e';
      debugPrint('Error loading more parts: $e');
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  // Inputs (Events)
  void searchTextChanged(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  /// Callback when user presses the Add Part FAB.
  PartSearchItemModel? _selectedPart;
  PartSearchItemModel? get selectedPart => _selectedPart;

  void addPartPressed() {
    if (_selectedPart != null) {
      debugPrint("Add Part pressed with selection: ${_selectedPart!.name}");
    } else {
      debugPrint(
        "Add Part pressed — no part selected, navigate to manual entry",
      );
    }
    notifyListeners();
  }

  void filterPressed() {
    debugPrint("Filter pressed — implement filter dialog if needed");
  }

  void partTapped(PartSearchItemModel part) {
    _selectedPart = part;
    debugPrint("Part tapped: ${part.name}");
    notifyListeners();
  }

  void clearSelection() {
    _selectedPart = null;
    notifyListeners();
  }
}
