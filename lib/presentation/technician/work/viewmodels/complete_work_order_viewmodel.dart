import 'package:flutter/material.dart';
import 'package:zent_fe/domain/entities/work_order_completion_draft.dart';
import 'package:zent_fe/domain/usecases/work_order/work_order_draft_usecase.dart';
import 'package:zent_fe/domain/usecases/work_order/get_single_work_order_usecase.dart';
import 'package:zent_fe/data/models/complete_work_order_request.dart';
import 'package:zent_fe/data/repositories/work_order_repository_impl.dart';
import 'package:zent_fe/di/injection_container.dart';
import 'package:zent_fe/presentation/common/auth/auth_view_model.dart';

class CompleteWorkOrderViewModel extends ChangeNotifier {
  bool _isDisposed = false;

  final String workOrderId;
  final WorkOrderDraftUseCase workOrderDraftUseCase;
  final GetSingleWorkOrderUseCase getSingleWorkOrderUseCase;

  // Controllers for text fields to ensure reliable persistence & UI sync
  final TextEditingController mtmController = TextEditingController();
  final TextEditingController serialNumberController = TextEditingController();
  final TextEditingController diagnosticNotesController =
      TextEditingController();

  bool _isLoading = true;

  // Step Management (0-indexed, 0-4 for steps 1-5)
  static const int totalSteps = 5;
  int _currentStep = 0;
  int get currentStep => _currentStep;

  // Technician name from logged-in user
  String get technicianName =>
      sl<AuthViewModel>().currentUser?.name ?? 'Technician';

  // Current formatted date
  String get currentDate {
    final now = DateTime.now();
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return "${months[now.month - 1]} ${now.day}, ${now.year}";
  }

  CompleteWorkOrderViewModel({
    required this.workOrderId,
    required this.workOrderDraftUseCase,
    required this.getSingleWorkOrderUseCase,
  }) {
    // Initialize listeners to save on every stroke
    mtmController.addListener(_saveDraft);
    serialNumberController.addListener(_saveDraft);
    diagnosticNotesController.addListener(_saveDraft);

    _loadDraft();
  }

  @override
  void dispose() {
    _isDisposed = true;
    mtmController.removeListener(_saveDraft);
    serialNumberController.removeListener(_saveDraft);
    diagnosticNotesController.removeListener(_saveDraft);
    mtmController.dispose();
    serialNumberController.dispose();
    diagnosticNotesController.dispose();
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_isDisposed) {
      super.notifyListeners();
    }
  }

  // --- Step Navigation Events ---

  void nextStepPressed() {
    if (_currentStep < totalSteps - 1) {
      _currentStep++;
      _saveDraft();
      notifyListeners();
    }
  }

  void backStepPressed() {
    if (_currentStep > 0) {
      _currentStep--;
      _saveDraft();
      notifyListeners();
    }
  }

  Future<void> submitPressed(BuildContext context) async {
    debugPrint(
      "action triggered: Submit Completion Report for WO: $workOrderId",
    );
    _isLoading = true;
    notifyListeners();
    try {
      final request = CompleteWorkOrderRequest(
        mtm: mtm,
        serialNumber: serialNumber,
        partChanges: [
          ..._installedParts.map(
            (p) => PartChangeInput(partId: p.id, changeType: 'INSTALL'),
          ),
          ..._uninstalledParts.map(
            (p) => PartChangeInput(partId: p.id, changeType: 'UNINSTALL'),
          ),
        ],
        diagnosis: diagnosticNotes,
        latitude: 0.0, // Assuming location logic is handled elsewhere or mock
        longitude: 0.0,
        signatureFileName: 'signature.png',
        checklist: _checklist
            .map(
              (c) => ChecklistResultInput(
                id: c.id,
                result: c.result,
                notes: c.notes,
              ),
            )
            .toList(),
      );

      // Call API (using repository or usecase if available)
      final repo = sl<WorkOrderRepositoryImpl>();
      await repo.remoteDataSource.completeWorkOrder(workOrderId, request);

      // Clear draft on success
      await workOrderDraftUseCase.clear(workOrderId);
      if (context.mounted) {
        Navigator.pop(context);
        debugPrint('Work Order Completed successfully');
      }
    } catch (e) {
      if (context.mounted) {
        debugPrint('Failed to complete work order: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // --- Draft Persistence ---

  Future<void> _loadDraft() async {
    _isLoading = true;
    try {
      final draft = await workOrderDraftUseCase.get(workOrderId);
      if (draft != null) {
        // Update parts and photos first (they don't trigger listeners)
        _uninstalledParts.clear();
        _uninstalledParts.addAll(draft.uninstalledParts);

        _installedParts.clear();
        _installedParts.addAll(draft.installedParts);

        _prePhotos.clear();
        _prePhotos.addAll(draft.prePhotos);
        _duringPhotos.clear();
        _duringPhotos.addAll(draft.duringPhotos);
        _postPhotos.clear();
        _postPhotos.addAll(draft.postPhotos);

        _checklist.clear();
        if (draft.checklist.isEmpty) {
          _checklist.addAll([
            TechWorkOrderChecklistItem(
              id: 1,
              result: false,
              notes: "Device powers on",
            ),
            TechWorkOrderChecklistItem(
              id: 2,
              result: false,
              notes: "Screen is intact",
            ),
            TechWorkOrderChecklistItem(
              id: 3,
              result: false,
              notes: "All screws tightened",
            ),
            TechWorkOrderChecklistItem(
              id: 4,
              result: false,
              notes: "Customer verified repair",
            ),
          ]);
        } else {
          _checklist.addAll(draft.checklist);
        }

        // Restore step
        _currentStep = draft.currentStep.clamp(0, totalSteps - 1);

        // Restore signature points
        _signaturePoints.clear();
        _signaturePoints.addAll(draft.signaturePoints);

        // Update controllers (this triggers listeners, but is guarded by _isLoading)
        mtmController.text = draft.mtm;
        serialNumberController.text = draft.serialNumber;
        diagnosticNotesController.text = draft.diagnosticNotes;

        notifyListeners();
      } else {
        // Fallback to mock data if no draft exists
        _setInitialMockData();
      }
    } finally {
      _isLoading = false;
    }
  }

  void _setInitialMockData() {
    _uninstalledParts.clear();
    _uninstalledParts.addAll([
      TechWorkOrderPart(
        id: 'P-101',
        name: 'Laptop Lenovo',
        serialNumber: '1234567',
        quantity: 1,
      ),
      TechWorkOrderPart(
        id: 'P-102',
        name: 'Laptop Lenovo',
        serialNumber: '1234567',
        quantity: 1,
      ),
    ]);
    _installedParts.clear();
    _installedParts.addAll([
      TechWorkOrderPart(
        id: 'P-201',
        name: 'Laptop Lenovo',
        serialNumber: '1234567',
        quantity: 1,
      ),
    ]);
    _checklist.clear();
    _checklist.addAll([
      TechWorkOrderChecklistItem(
        id: 1,
        result: false,
        notes: "Device powers on",
      ),
      TechWorkOrderChecklistItem(
        id: 2,
        result: false,
        notes: "Screen is intact",
      ),
      TechWorkOrderChecklistItem(
        id: 3,
        result: false,
        notes: "All screws tightened",
      ),
      TechWorkOrderChecklistItem(
        id: 4,
        result: false,
        notes: "Customer verified repair",
      ),
    ]);
    notifyListeners();
  }

  Future<void> _saveDraft() async {
    if (_isLoading) return;

    final draft = WorkOrderCompletionDraft(
      workOrderId: workOrderId,
      mtm: mtmController.text,
      serialNumber: serialNumberController.text,
      diagnosticNotes: diagnosticNotesController.text,
      uninstalledParts: _uninstalledParts,
      installedParts: _installedParts,
      prePhotos: _prePhotos,
      duringPhotos: _duringPhotos,
      postPhotos: _postPhotos,
      currentStep: _currentStep,
      signaturePoints: _signaturePoints,
      checklist: _checklist,
    );
    await workOrderDraftUseCase.save(draft);
  }

  // Machine Information (now controlled by listeners, but keeping setters for backwards compatibility/API)
  String get mtm => mtmController.text;
  String get serialNumber => serialNumberController.text;

  // Diagnostic Section
  String get diagnosticNotes => diagnosticNotesController.text;

  // Parts Sections
  final List<TechWorkOrderPart> _uninstalledParts = [];
  List<TechWorkOrderPart> get uninstalledParts => _uninstalledParts;

  final List<TechWorkOrderPart> _installedParts = [];
  List<TechWorkOrderPart> get installedParts => _installedParts;

  // Evidence Photos
  final List<String> _prePhotos = [];
  List<String> get prePhotos => _prePhotos;

  final List<String> _duringPhotos = [];
  List<String> get duringPhotos => _duringPhotos;

  final List<String> _postPhotos = [];
  List<String> get postPhotos => _postPhotos;

  // Signature Points
  final List<Map<String, dynamic>> _signaturePoints = [];
  List<Map<String, dynamic>> get signaturePoints => _signaturePoints;

  void signaturePointsUpdated(List<Map<String, dynamic>> points) {
    _signaturePoints.clear();
    _signaturePoints.addAll(points);
    _saveDraft();
  }

  // Checklist
  final List<TechWorkOrderChecklistItem> _checklist = [];
  List<TechWorkOrderChecklistItem> get checklist => _checklist;

  void toggleChecklistItem(int id, bool value) {
    final index = _checklist.indexWhere((item) => item.id == id);
    if (index != -1) {
      final old = _checklist[index];
      _checklist[index] = TechWorkOrderChecklistItem(
        id: old.id,
        result: value,
        notes: old.notes,
      );
      _saveDraft();
      notifyListeners();
    }
  }

  // Photo Management
  void addPhoto(String path, String phase) {
    List<String> target;
    switch (phase) {
      case 'pre':
        target = _prePhotos;
        break;
      case 'during':
        target = _duringPhotos;
        break;
      case 'post':
        target = _postPhotos;
        break;
      default:
        return;
    }
    if (target.length < 5) {
      target.add(path);
      _saveDraft();
      notifyListeners();
    }
  }

  void removePhoto(int index, String phase) {
    List<String> target;
    switch (phase) {
      case 'pre':
        target = _prePhotos;
        break;
      case 'during':
        target = _duringPhotos;
        break;
      case 'post':
        target = _postPhotos;
        break;
      default:
        return;
    }
    if (index >= 0 && index < target.length) {
      target.removeAt(index);
      _saveDraft();
      notifyListeners();
    }
  }

  // Part Management
  void removeUninstalledPart(String id) {
    _uninstalledParts.removeWhere((p) => p.id == id);
    _saveDraft();
    notifyListeners();
  }

  void removeInstalledPart(String id) {
    _installedParts.removeWhere((p) => p.id == id);
    _saveDraft();
    notifyListeners();
  }
}
