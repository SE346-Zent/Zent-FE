import 'package:flutter/material.dart';

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

class PartSearchViewModel extends ChangeNotifier {
  // States
  bool _isLoading = false;
  String? _errorMessage;
  List<PartSearchItemModel> _parts = [];
  String _searchQuery = '';

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<PartSearchItemModel> get parts => _filteredParts;
  String get searchQuery => _searchQuery;

  List<PartSearchItemModel> get _filteredParts {
    if (_searchQuery.isEmpty) return _parts;
    return _parts
        .where((part) =>
            part.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            part.partNo.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  PartSearchViewModel() {
    _loadInitialData();
  }

  void _loadInitialData() {
    _isLoading = true;
    notifyListeners();

    // Mock initial data based on the provided image
    _parts = [
      PartSearchItemModel(
        imageUrl: 'https://picsum.photos/48/48?random=1',
        name: 'Black Tape',
        partNo: '5F10S13964',
        commodity: 'Reusable items',
        status: PartStatus.available,
      ),
      PartSearchItemModel(
        imageUrl: 'https://picsum.photos/48/48?random=2',
        name: 'Black Tape',
        partNo: '5F10S13964',
        commodity: 'Reusable items',
        status: PartStatus.unavailable,
      ),
    ];

    _isLoading = false;
    notifyListeners();
  }

  // Inputs (Events)
  void searchTextChanged(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void addPartPressed() {
    debugPrint("action triggered: Add Part");
  }

  void filterPressed() {
    debugPrint("action triggered: Filter");
  }

  void partTapped(PartSearchItemModel part) {
    debugPrint("action triggered: Tapped on ${part.name}");
  }
}
