import 'package:flutter/material.dart';

class TechRejectWorkOrderViewModel extends ChangeNotifier {
  String _workOrderId = '';
  String get workOrderId => _workOrderId;
  String? _selectedReasonId;
  String? get selectedReasonId => _selectedReasonId;
  final TextEditingController notesController = TextEditingController();
  final Map<String, String> assignmentDetails = {
    'customer': 'John Doe',
    'assigner': 'Alexandria',
  };

  final List<Map<String, String>> rejectReasons = [
    {'id': 'waiting_parts', 'title': 'Waiting for Parts'},
    {'id': 'lunch_break', 'title': 'Lunch/Break'},
    {'id': 'equipment_issue', 'title': 'Equipment Issue'},
    {'id': 'other', 'title': 'Other'},
  ];

  void initData(String id) {
    _workOrderId = id.startsWith('WO-') ? id : 'WO-$id';
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
