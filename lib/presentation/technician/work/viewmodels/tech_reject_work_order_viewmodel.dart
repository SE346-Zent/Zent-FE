import 'package:zent_fe/presentation/common/core/safe_change_notifier.dart';
import 'package:flutter/material.dart';
import '../../../../domain/usecases/work_order/refuse_work_order_usecase.dart';
import '../../../../domain/usecases/work_order/get_single_work_order_usecase.dart';
import '../../../../domain/usecases/auth/get_current_user_usecase.dart';
import '../../../../data/models/refuse_work_order_request.dart';
import '../../../../domain/entities/work_order.dart';

class TechRejectWorkOrderViewModel extends ChangeNotifier
    with SafeChangeNotifier {
  final RefuseWorkOrderUseCase refuseWorkOrderUseCase;
  final GetSingleWorkOrderUseCase getSingleWorkOrderUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;

  TechRejectWorkOrderViewModel(
    this.refuseWorkOrderUseCase,
    this.getSingleWorkOrderUseCase,
    this.getCurrentUserUseCase,
  );

  String _workOrderId = '';
  String get workOrderId => _workOrderId;

  WorkOrder? _workOrder;
  WorkOrder? get workOrder => _workOrder;

  String? _selectedReasonId;
  String? get selectedReasonId => _selectedReasonId;

  final TextEditingController notesController = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final List<String> evidenceImageUrls = [];

  void addPhotoFromPath(String path) {
    if (path.isNotEmpty && !evidenceImageUrls.contains(path)) {
      evidenceImageUrls.add(path);
      notifyListeners();
    }
  }

  void removePhoto(int index) {
    if (index >= 0 && index < evidenceImageUrls.length) {
      evidenceImageUrls.removeAt(index);
      notifyListeners();
    }
  }

  final List<Map<String, String>> rejectReasons = [
    {'id': 'waiting_parts', 'title': 'Waiting for Parts'},
    {'id': 'lunch_break', 'title': 'Lunch/Break'},
    {'id': 'equipment_issue', 'title': 'Equipment Issue'},
    {'id': 'other', 'title': 'Other'},
  ];

  Future<void> initData(String id) async {
    _workOrderId = id;
    _isLoading = true;
    notifyListeners();

    try {
      final wo = await getSingleWorkOrderUseCase.execute(id);
      final user = await getCurrentUserUseCase.execute();

      // Robust client-side filtering: Ensure order belongs to this tech
      if (user != null && wo.technicianId == user.id) {
        _workOrder = wo;
      } else {
        _workOrder = null;
        debugPrint("Unauthorized access attempt to work order: $id");
      }
    } catch (e) {
      debugPrint("Error fetching work order for rejection: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectReason(String id) {
    _selectedReasonId = id;
    notifyListeners();
  }

  Future<String?> submitRejection() async {
    if (_selectedReasonId == null) {
      return 'Please select a reason';
    }

    _isLoading = true;
    notifyListeners();

    try {
      final request = RefuseWorkOrderRequest(
        reason:
            rejectReasons.firstWhere(
              (r) => r['id'] == _selectedReasonId,
            )['title'] ??
            'Other',
        explanation: notesController.text,
        evidenceImageUrls: evidenceImageUrls,
      );

      await refuseWorkOrderUseCase.execute(_workOrderId, request);

      _isLoading = false;
      notifyListeners();
      return null; // success
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return 'Failed to submit rejection request: $e';
    }
  }

  @override
  void dispose() {
    notesController.dispose();
    super.dispose();
  }
}
