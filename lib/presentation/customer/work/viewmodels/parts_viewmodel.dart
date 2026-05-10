import 'package:flutter/material.dart';

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

class PartsViewModel extends ChangeNotifier {
  List<PartModel> allParts = [
    PartModel(
      title: 'Black Tape 1',
      partNo: '5F10S13964',
      commodity: 'Reusable items',
      status: 'Available',
    ),
    PartModel(
      title: 'Black Tape 2',
      partNo: '5F10S13964',
      commodity: 'Reusable items',
      status: 'Unavailable',
    ),
    PartModel(
      title: 'White Tape',
      partNo: '5F10S13965',
      commodity: 'Consumables',
      status: 'Available',
    ),
  ];

  List<PartModel> filteredParts = [];
  final TextEditingController searchController = TextEditingController();

  String sortAlphabet = 'None';
  String filterStatus = 'None';

  void init() {
    filteredParts = List.from(allParts);
    searchController.addListener(_onSearchChanged);
    notifyListeners();
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
