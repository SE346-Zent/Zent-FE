import 'package:flutter/material.dart';
import '../../../../domain/entities/work_order_completion_draft.dart';
import '../../../../domain/usecases/work_order/get_work_order_draft_usecase.dart';
import '../../../../domain/usecases/work_order/save_work_order_draft_usecase.dart';

class CompleteWorkOrderViewModel extends ChangeNotifier {
  final String workOrderId;
  final GetWorkOrderDraftUseCase getWorkOrderDraftUseCase;
  final SaveWorkOrderDraftUseCase saveWorkOrderDraftUseCase;

  // Controllers for text fields to ensure reliable persistence & UI sync
  final TextEditingController mtmController = TextEditingController();
  final TextEditingController serialNumberController = TextEditingController();
  final TextEditingController diagnosticNotesController =
      TextEditingController();

  bool _isLoading = true;

  CompleteWorkOrderViewModel({
    required this.workOrderId,
    required this.getWorkOrderDraftUseCase,
    required this.saveWorkOrderDraftUseCase,
  }) {
    // Initialize listeners to save on every stroke
    mtmController.addListener(_saveDraft);
    serialNumberController.addListener(_saveDraft);
    diagnosticNotesController.addListener(_saveDraft);

    _loadDraft();
  }

  @override
  void dispose() {
    mtmController.removeListener(_saveDraft);
    serialNumberController.removeListener(_saveDraft);
    diagnosticNotesController.removeListener(_saveDraft);
    mtmController.dispose();
    serialNumberController.dispose();
    diagnosticNotesController.dispose();
    super.dispose();
  }

  Future<void> _loadDraft() async {
    _isLoading = true;
    try {
      final draft = await getWorkOrderDraftUseCase.execute(workOrderId);
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
    );
    await saveWorkOrderDraftUseCase.execute(draft);
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

  void submitReport() {
    debugPrint(
      "action triggered: Submit Completion Report for WO: $workOrderId",
    );
    // Clear draft on success?
  }
}
