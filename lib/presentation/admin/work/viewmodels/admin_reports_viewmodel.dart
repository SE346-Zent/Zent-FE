import 'package:zent_fe/presentation/common/core/safe_change_notifier.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:zent_fe/domain/usecases/inventory/zent_inventory_usecases.dart';

class AdminReportsViewModel extends ChangeNotifier with SafeChangeNotifier {
  final GetAnalyticsUseCase _getAnalyticsUseCase;

  AdminReportsViewModel({required GetAnalyticsUseCase getAnalyticsUseCase})
    : _getAnalyticsUseCase = getAnalyticsUseCase;

  int _activeTabIndex = 0; // 0 for 'Last 7 days', 1 for 'Last 30 days'
  int get activeTabIndex => _activeTabIndex;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  // ── API-driven state ──
  String _totalJobs = '...';
  String get totalJobs => _totalJobs;

  String _totalJobsTrend = '';
  String get totalJobsTrend => _totalJobsTrend;

  String _totalImported = '...';
  String get totalImported => _totalImported;

  String _totalImportedTrend = '';
  String get totalImportedTrend => _totalImportedTrend;

  String _totalReturned = '...';
  String get totalReturned => _totalReturned;

  String _totalReturnedTrend = '';
  String get totalReturnedTrend => _totalReturnedTrend;

  List<Map<String, double>> _chartData = [];
  List<Map<String, double>> get chartData => _chartData;

  List<String> _chartLabels = [];
  List<String> get chartLabels => _chartLabels;

  List<Map<String, dynamic>> _partCategories = [];
  List<Map<String, dynamic>> get partCategories => _partCategories;

  void changeTab(int index) {
    if (_activeTabIndex != index) {
      _activeTabIndex = index;
      notifyListeners();
      _fetchAnalytics();
    }
  }

  void init() {
    if (_chartData.isEmpty) {
      _fetchAnalytics();
    }
  }

  Future<void> _fetchAnalytics() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final period = _activeTabIndex == 0 ? '7d' : '30d';
      debugPrint('AdminReportsViewModel: Fetching analytics for $period...');
      final data = await _getAnalyticsUseCase.execute(period: period);
      debugPrint('AdminReportsViewModel: Analytics response: $data');
      _parseResponse(data);
      _error = null;
    } catch (e) {
      debugPrint('AdminReportsViewModel: Error fetching analytics: $e');
      _error = e.toString();
      // Fallback to mock data on error
      _applyMockData();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _parseResponse(Map<String, dynamic> json) {
    final analyticsData = json['data'] as Map<String, dynamic>?;
    if (analyticsData == null) {
      _applyMockData();
      return;
    }

    // ── Total orders ──
    final totalOrders = analyticsData['totalOrders'];
    if (totalOrders is Map<String, dynamic>) {
      _totalJobs = _formatNumber(totalOrders['value']);
      _totalJobsTrend = _formatTrend(totalOrders['percentChange']);
    }

    // ── Total imported parts ──
    final totalImportedParts = analyticsData['totalImportedParts'];
    if (totalImportedParts is Map<String, dynamic>) {
      _totalImported = _formatNumber(totalImportedParts['value']);
      _totalImportedTrend = _formatTrend(totalImportedParts['percentChange']);
    }

    // ── Total returned parts ──
    final totalReturnedParts = analyticsData['totalReturnedParts'];
    if (totalReturnedParts is Map<String, dynamic>) {
      _totalReturned = _formatNumber(totalReturnedParts['value']);
      _totalReturnedTrend = _formatTrend(totalReturnedParts['percentChange']);
    }

    // ── Chart: jobCompletionTrend ──
    // API shape: { labels: [...], current: [...], previous: [...] }
    final trend = analyticsData['jobCompletionTrend'];
    if (trend is Map<String, dynamic>) {
      final currentVals = (trend['current'] as List?)?.cast<num>() ?? [];
      final prevVals = (trend['previous'] as List?)?.cast<num>() ?? [];
      final labels =
          (trend['labels'] as List?)?.map((e) => e.toString()).toList() ?? [];

      _chartLabels = labels;
      final count = currentVals.length > prevVals.length
          ? currentVals.length
          : prevVals.length;
      _chartData = List.generate(count, (i) {
        return {
          'current': i < currentVals.length ? currentVals[i].toDouble() : 0.0,
          'previous': i < prevVals.length ? prevVals[i].toDouble() : 0.0,
          'complaint': 0.0, // API doesn't provide complaint separately
        };
      });
    }

    // ── Part categories ──
    // API shape: [{ categoryName, percent (0-100) }]
    final rawCategories = analyticsData['partCategories'];
    if (rawCategories is List) {
      _partCategories = rawCategories.map((e) {
        final m = e as Map<String, dynamic>;
        final percent = (m['percent'] as num?)?.toDouble() ?? 0;
        final fraction = percent / 100.0;
        return {
          'name': m['categoryName']?.toString() ?? '',
          'percentage': fraction,
          'label': '${percent.round()}%',
        };
      }).toList();
    }

    if (_chartData.isEmpty && _partCategories.isEmpty) {
      _applyMockData();
    }
  }

  void _applyMockData() {
    if (_activeTabIndex == 0) {
      _totalJobs = '1,200';
      _totalJobsTrend = '10%';
      _totalImported = '4,600';
      _totalImportedTrend = '10%';
      _totalReturned = '2,100';
      _totalReturnedTrend = '10%';
      _chartData = [
        {'current': 60, 'previous': 80, 'complaint': 0},
        {'current': 40, 'previous': 70, 'complaint': 0},
        {'current': 80, 'previous': 90, 'complaint': 0},
        {'current': 80, 'previous': 75, 'complaint': 0},
        {'current': 50, 'previous': 65, 'complaint': 0},
        {'current': 70, 'previous': 85, 'complaint': 0},
        {'current': 65, 'previous': 60, 'complaint': 0},
      ];
      _chartLabels = [
        'DAY\n1',
        'DAY\n2',
        'DAY\n3',
        'DAY\n4',
        'DAY\n5',
        'DAY\n6',
        'DAY\n7',
      ];
    } else {
      _totalJobs = '5,400';
      _totalJobsTrend = '15%';
      _totalImported = '18,500';
      _totalImportedTrend = '12%';
      _totalReturned = '8,200';
      _totalReturnedTrend = '8%';
      _chartData = [
        {'current': 60, 'previous': 80, 'complaint': 0},
        {'current': 40, 'previous': 70, 'complaint': 0},
        {'current': 80, 'previous': 90, 'complaint': 0},
        {'current': 80, 'previous': 75, 'complaint': 0},
      ];
      _chartLabels = ['WEEK\n1', 'WEEK\n2', 'WEEK\n3', 'WEEK\n4'];
    }
    _partCategories = [
      {'name': 'ELECTRICAL COMPONENTS', 'percentage': 0.47, 'label': '47%'},
      {'name': 'HVAC SPARATES', 'percentage': 0.30, 'label': '30%'},
      {'name': 'ABC', 'percentage': 0.20, 'label': '20%'},
      {'name': 'Other', 'percentage': 0.03, 'label': '3%'},
    ];
  }

  String _formatNumber(dynamic val) {
    if (val is int) {
      if (val >= 1000) {
        return '${(val / 1000).toStringAsFixed(val % 1000 == 0 ? 0 : 1)}k';
      }
      return val.toString();
    }
    if (val is double) {
      if (val >= 1000) {
        return '${(val / 1000).toStringAsFixed(1)}k';
      }
      return val.toStringAsFixed(0);
    }
    return val.toString();
  }

  String _formatTrend(dynamic val) {
    if (val is num) {
      final prefix = val >= 0 ? '' : '';
      return '$prefix${val.abs()}%';
    }
    final s = val.toString();
    if (s.endsWith('%')) return s;
    return '$s%';
  }
}
