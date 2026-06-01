import 'package:zent_fe/presentation/common/core/safe_change_notifier.dart';
import 'package:flutter/material.dart';

class CustomerCancelWorkOrderViewModel extends ChangeNotifier
    with SafeChangeNotifier {
  String _workOrderId = '';
  String get workOrderId => _workOrderId;

  String? _selectedReasonId;
  String? get selectedReasonId => _selectedReasonId;

  final TextEditingController notesController = TextEditingController();

  final List<Map<String, String>> cancelReasons = [
    {'id': 'incorrect_info', 'title': 'Incorrect Information'},
    {'id': 'duplicate_request', 'title': 'Duplicate Request'},
    {'id': 'parts_unavailable', 'title': 'Parts Unavailable'},
    {'id': 'customer_request', 'title': 'Customer Request'},
    {'id': 'other', 'title': 'Other'},
  ];

  void initData(String id) {
    _workOrderId = id;
    notifyListeners();
  }

  void selectReason(String id) {
    _selectedReasonId = id;
    notifyListeners();
  }

  @override
  void dispose() {
    notesController.dispose();
    super.dispose();
  }
}
