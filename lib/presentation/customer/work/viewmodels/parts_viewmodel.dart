import 'package:zent_fe/presentation/common/core/safe_change_notifier.dart';
import 'package:flutter/material.dart';
import 'package:zent_fe/domain/entities/part_catalog_entry.dart';
import 'package:zent_fe/domain/usecases/inventory/get_inventory_usecases.dart';

class PartModel {
  final String title;
  final String partNo;
  final String commodity;
  final String status;

  PartModel({
    required this.title,
    required this.partNo,
    required this.commodity,
    required this.status,
  });
}

class PartsViewModel extends ChangeNotifier with SafeChangeNotifier {
  final GetPartCatalogUseCase getPartCatalogUseCase;

  PartsViewModel({required this.getPartCatalogUseCase});

  List<PartModel> allParts = [];
  List<PartModel> filteredParts = [];
  bool isLoading = false;

  final TextEditingController searchController = TextEditingController();

  String sortAlphabet = 'None';
  String filterStatus = 'None';

  Future<void> init() async {
    searchController.addListener(_onSearchChanged);
    await fetchParts();
  }

  Future<void> fetchParts() async {
    isLoading = true;
    notifyListeners();

    try {
      final (parts, _) = await getPartCatalogUseCase.execute(
        page: 1,
        limit: 50,
      );
      allParts = parts.map(_mapCatalogToModel).toList();
      _filterParts();
    } catch (e) {
      debugPrint('Error fetching parts: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  PartModel _mapCatalogToModel(PartCatalogEntry entry) {
    return PartModel(
      title: entry.partNumber,
      partNo: entry.mfgNumber ?? entry.id,
      commodity: entry.description ?? 'General',
      status: entry.partMfgStatus ?? 'Unknown',
    );
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
