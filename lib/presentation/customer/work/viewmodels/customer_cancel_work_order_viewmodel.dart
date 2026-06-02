import 'package:flutter/material.dart';
import '../../../../domain/usecases/work_order/cancel_work_order_usecase.dart';

class CustomerCancelWorkOrderViewModel extends ChangeNotifier {
  final CancelWorkOrderUseCase cancelWorkOrderUseCase;

  String _workOrderId = '';
  String get workOrderId => _workOrderId;

  String? _selectedReasonId;
  String? get selectedReasonId => _selectedReasonId;

  final TextEditingController notesController = TextEditingController();

  bool isLoading = false;
  String? errorMessage;

  final List<Map<String, String>> cancelReasons = [
    {'id': 'incorrect_info', 'title': 'Incorrect Information'},
    {'id': 'duplicate_request', 'title': 'Duplicate Request'},
    {'id': 'parts_unavailable', 'title': 'Parts Unavailable'},
    {'id': 'customer_request', 'title': 'Customer Request'},
    {'id': 'other', 'title': 'Other'},
  ];

  CustomerCancelWorkOrderViewModel({required this.cancelWorkOrderUseCase});

  void initData(String id) {
    _workOrderId = id;
    notifyListeners();
  }

  void selectReason(String id) {
    _selectedReasonId = id;
    notifyListeners();
  }

  Future<bool> submitCancel() async {
    if (_selectedReasonId == null && notesController.text.trim().isEmpty) {
      errorMessage =
          'Please select a reason or add comments before cancelling.';
      notifyListeners();
      return false;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      String finalReason = '';
      if (_selectedReasonId != null) {
        final reasonObj = cancelReasons.firstWhere(
          (r) => r['id'] == _selectedReasonId,
        );
        finalReason = reasonObj['title'] ?? '';
      }

      final notes = notesController.text.trim();
      if (notes.isNotEmpty) {
        finalReason += finalReason.isEmpty ? notes : ' - $notes';
      }

      final cleanId = _workOrderId.replaceAll('#', '');

      await cancelWorkOrderUseCase.execute(
        cleanId,
        finalReason.isEmpty ? null : finalReason,
      );

      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      errorMessage = e.toString().replaceAll('Exception: ', '');
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  @override
  void dispose() {
    notesController.dispose();
    super.dispose();
  }
}
