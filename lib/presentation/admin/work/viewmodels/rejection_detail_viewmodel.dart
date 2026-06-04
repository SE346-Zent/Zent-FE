import 'package:zent_fe/presentation/common/core/safe_change_notifier.dart';
import 'package:flutter/foundation.dart';
import '../../../../domain/entities/work_order.dart';
import '../../../../domain/entities/reject_form.dart';
import '../../../../domain/usecases/work_order/get_single_work_order_usecase.dart';
import '../../../../domain/usecases/work_order/get_reject_form_by_id_usecase.dart';
import '../../../../domain/usecases/work_order/get_reject_forms_usecase.dart';
import '../../../../domain/usecases/work_order/approve_refusal_usecase.dart';
import '../../../../domain/usecases/work_order/deny_refusal_usecase.dart';
import '../../../../data/models/refuse_work_order_request.dart';

class RejectionDetailViewModel extends ChangeNotifier with SafeChangeNotifier {
  final GetSingleWorkOrderUseCase getSingleWorkOrderUseCase;
  final GetRejectFormByIdUseCase getRejectFormByIdUseCase;
  final GetRejectFormsUseCase getRejectFormsUseCase;
  final ApproveRefusalUseCase approveRefusalUseCase;
  final DenyRefusalUseCase denyRefusalUseCase;

  RejectionDetailViewModel({
    required this.getSingleWorkOrderUseCase,
    required this.getRejectFormByIdUseCase,
    required this.getRejectFormsUseCase,
    required this.approveRefusalUseCase,
    required this.denyRefusalUseCase,
  });

  WorkOrder? _workOrder;
  WorkOrder? get workOrder => _workOrder;

  /// Reject form detail (photos, reason, explanation) from /reject_forms/{id}
  RejectForm? _rejectFormDetail;
  RejectForm? get rejectFormDetail => _rejectFormDetail;

  /// Photos to display — from reject form detail if available, else empty
  List<String> get photoUrls => _rejectFormDetail?.photoUrls ?? [];

  /// Reason text — prefer reject form detail, fallback to work order
  String get reason => (_rejectFormDetail?.reason.isNotEmpty == true)
      ? _rejectFormDetail!.reason
      : (_workOrder?.refusalReason ?? '');

  /// Explanation text
  String get explanation =>
      _rejectFormDetail?.explanation ?? _workOrder?.refusalNote ?? '';

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isApproving = false;
  bool get isApproving => _isApproving;

  bool _isDenying = false;
  bool get isDenying => _isDenying;

  bool _isDisposed = false;

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  /// Loads details using the rejectFormId or workOrderId.
  Future<void> loadDetails(String id) async {
    _isLoading = true;
    notifyListeners();

    try {
      RejectForm? rejectForm;

      // 1. Try to fetch directly assuming 'id' is a rejectFormId
      try {
        rejectForm = await getRejectFormByIdUseCase.execute(id);
      } catch (directError) {
        debugPrint(
          'Direct fetch by rejectFormId failed: $directError. Trying list search...',
        );
      }

      // 2. Fallback: if direct fetch failed or workOrderId is empty, fetch all reject forms
      // to resolve mapping between rejectFormId and workOrderId.
      if (rejectForm == null || rejectForm.workOrderId.isEmpty) {
        try {
          final forms = await getRejectFormsUseCase.execute();

          // Find by rejectFormId first
          var matched = forms.firstWhere(
            (f) => f.id == id,
            orElse: () => const RejectForm(
              id: '',
              workOrderId: '',
              workOrderNumber: '',
              technicianName: '',
              customerName: '',
              reason: '',
              approved: false,
            ),
          );

          // If not found by rejectFormId, try finding by workOrderId
          if (matched.id.isEmpty) {
            matched = forms.firstWhere(
              (f) => f.workOrderId == id,
              orElse: () => const RejectForm(
                id: '',
                workOrderId: '',
                workOrderNumber: '',
                technicianName: '',
                customerName: '',
                reason: '',
                approved: false,
              ),
            );
          }

          if (matched.id.isNotEmpty) {
            // If we found it, fetch details using the correct rejectFormId
            rejectForm = await getRejectFormByIdUseCase.execute(matched.id);
            // Enrich with list metadata (names)
            _rejectFormDetail = RejectForm(
              id: rejectForm.id,
              workOrderId: matched.workOrderId,
              workOrderNumber: matched.workOrderNumber,
              technicianName: matched.technicianName,
              customerName: matched.customerName,
              reason: rejectForm.reason,
              explanation: rejectForm.explanation,
              approved: rejectForm.approved,
              createdAt: rejectForm.createdAt,
              photoUrls: rejectForm.photoUrls,
            );
          }
        } catch (fallbackError) {
          debugPrint(
            'Fallback resolution by reject forms list search failed: $fallbackError',
          );
        }
      } else {
        _rejectFormDetail = rejectForm;
      }

      // 3. Fetch work order if we resolved a workOrderId
      final resolvedWorkOrderId = _rejectFormDetail?.workOrderId;
      if (resolvedWorkOrderId != null && resolvedWorkOrderId.isNotEmpty) {
        _workOrder = await getSingleWorkOrderUseCase.execute(
          resolvedWorkOrderId,
        );
      }
    } catch (e) {
      debugPrint('Error loading rejection details: $e');
    } finally {
      _isLoading = false;
      if (!_isDisposed) {
        notifyListeners();
      }
    }
  }

  Future<String?> approveRejection() async {
    if (_workOrder == null) return 'No work order data';
    _isApproving = true;
    notifyListeners();

    try {
      await approveRefusalUseCase.execute(
        _workOrder!.id,
        ApproveRefusalRequest(technicianId: _workOrder!.technicianId),
      );
      return null;
    } catch (e) {
      debugPrint('Error approving rejection: $e');
      return e.toString();
    } finally {
      _isApproving = false;
      if (!_isDisposed) {
        notifyListeners();
      }
    }
  }

  Future<String?> denyRejection() async {
    if (_workOrder == null) return 'No work order data';
    _isDenying = true;
    notifyListeners();

    try {
      await denyRefusalUseCase.execute(_workOrder!.id);
      return null;
    } catch (e) {
      debugPrint('Error denying rejection: $e');
      return e.toString();
    } finally {
      _isDenying = false;
      if (!_isDisposed) {
        notifyListeners();
      }
    }
  }
}
