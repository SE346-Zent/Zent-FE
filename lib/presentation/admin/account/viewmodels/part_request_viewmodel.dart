import 'package:flutter/material.dart';
import 'package:zent_fe/domain/entities/new_part_form.dart';
import 'package:zent_fe/domain/usecases/inventory/get_inventory_usecases.dart';
import '../../../common/core/safe_change_notifier.dart';

class PartRequestItem {
  final String id;
  final String partName;
  final String woId;
  final String date;
  final String status;
  final NewPartForm? rawPart;

  PartRequestItem({
    required this.id,
    required this.partName,
    required this.woId,
    required this.date,
    required this.status,
    this.rawPart,
  });
}

class PartRequestsViewModel extends ChangeNotifier with SafeChangeNotifier {
  final GetPartRequestsUseCase getPartRequestsUseCase;

  PartRequestsViewModel({required this.getPartRequestsUseCase});

  int pendingCount = 0;
  int approvedCount = 0;
  int rejectedCount = 0;
  bool isLoading = false;
  bool isLoadingMore = false;

  static const int _pageSize = 50;

  String searchQuery = '';

  List<PartRequestItem> requests = [];

  List<PartRequestItem> get filteredRequests {
    if (searchQuery.isEmpty) return requests;
    return requests
        .where(
          (request) =>
              request.partName.toLowerCase().contains(
                searchQuery.toLowerCase(),
              ) ||
              request.woId.toLowerCase().contains(searchQuery.toLowerCase()),
        )
        .toList();
  }

  Future<void> loadRequests() async {
    isLoading = true;
    notifyListeners();

    try {
      final (items, summary) = await getPartRequestsUseCase.execute(
        page: 1,
        limit: _pageSize,
        query: searchQuery.isNotEmpty ? searchQuery : null,
      );

      requests = _mapParts(items);
      pendingCount = summary.pending;
      approvedCount = summary.approved;
      rejectedCount = summary.rejected;
    } catch (e) {
      debugPrint('Error loading part requests: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMore() async {
    // True infinite scroll placeholder
  }

  List<PartRequestItem> _mapParts(List<NewPartForm> parts) {
    return parts.map((part) {
      String displayStatus = part.status;
      if (displayStatus.isNotEmpty) {
        displayStatus =
            displayStatus[0].toUpperCase() +
            displayStatus.substring(1).toLowerCase();
      }
      return PartRequestItem(
        id: part.id,
        partName: part.partNumber.isNotEmpty ? part.partNumber : 'Part',
        woId: part.workOrderNumber.isNotEmpty ? part.workOrderNumber : 'WO',
        date:
            '${part.createdAt.day}/${part.createdAt.month}/${part.createdAt.year}',
        status: displayStatus,
        rawPart: part,
      );
    }).toList();
  }

  void onSearchChanged(String query) {
    searchQuery = query;
    loadRequests(); // Reload with query filter
  }
}
