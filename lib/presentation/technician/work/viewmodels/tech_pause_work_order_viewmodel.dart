import 'package:flutter/material.dart';

class TechPauseWorkOrderViewModel extends ChangeNotifier {
  String _workOrderId = '';
  String get workOrderId => _workOrderId;

  String? _selectedReasonId;
  String? get selectedReasonId => _selectedReasonId;

  final TextEditingController notesController = TextEditingController();

  final List<Map<String, String?>> pauseReasons = [
    {
      'id': 'waiting_parts',
      'title': 'Waiting for Parts',
      'subtitle': 'Parts orderd, waiting for delivery.',
    },
    {
      'id': 'lunch_break',
      'title': 'Lunch/Break',
      'subtitle': 'Standard shift break',
    },
    {
      'id': 'equipment_issue',
      'title': 'Equipment Issue',
      'subtitle': 'Tools or machinery function',
    },
    {'id': 'other', 'title': 'Other', 'subtitle': null},
  ];

  void initData(String id) {
    _workOrderId = id.startsWith('#') ? id : '#$id';
    _selectedReasonId = pauseReasons.first['id'];
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
