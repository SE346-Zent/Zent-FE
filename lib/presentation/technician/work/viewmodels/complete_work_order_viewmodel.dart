import 'package:zent_fe/presentation/common/core/safe_change_notifier.dart';
import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:native_exif/native_exif.dart';
import 'package:zent_fe/domain/entities/work_order_completion_draft.dart';
import 'package:zent_fe/domain/usecases/work_order/work_order_draft_usecase.dart';
import 'package:zent_fe/domain/usecases/work_order/get_single_work_order_usecase.dart';
import 'package:zent_fe/data/models/complete_work_order_request.dart';
import 'package:zent_fe/domain/repositories/work_order_repository.dart';
import 'package:zent_fe/di/injection_container.dart';
import 'package:zent_fe/presentation/common/auth/auth_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zent_fe/domain/entities/enums/work_order_status.dart';

class CompleteWorkOrderViewModel extends ChangeNotifier
    with SafeChangeNotifier {
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
  bool get isLoading => _isLoading;

  bool _isReadOnly = false;
  bool get isReadOnly => _isReadOnly;

  String _workOrderNum = '';
  String get workOrderNum => _workOrderNum;

  DateTime? _appointment;
  DateTime? get appointment => _appointment;

  String get appointmentFormatted {
    final dt = _appointment;
    if (dt == null) return 'N/A';
    final now = DateTime.now();
    final isToday =
        dt.year == now.year && dt.month == now.month && dt.day == now.day;
    final timeStr = DateFormat("hh:mm a").format(dt);
    if (isToday) {
      return '$timeStr - Today';
    } else {
      return '$timeStr - ${DateFormat("dd/MM/yyyy").format(dt)}';
    }
  }

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
    if (_isReadOnly) {
      Navigator.pop(context);
      return;
    }
    debugPrint(
      "action triggered: Submit Completion Report for WO: $workOrderId",
    );
    _isLoading = true;
    notifyListeners();
    try {
      final pos = await _getCurrentLocation();
      final lat = pos?.latitude ?? 0.0;
      final lng = pos?.longitude ?? 0.0;

      final cleanId = workOrderId.replaceAll('#', '');
      final sp = sl<SharedPreferences>();
      final savedList = sp.getStringList("details_checklist_$cleanId");

      final List<ChecklistResultInput> submitChecklist = [];
      if (savedList != null) {
        final labels = [
          "Post-Repair Cosmetic Check",
          "AC adapter/battery charging",
          "Lan Port/Wifi/WWAN/Bluetooth",
          "LCD touch/rotate/flip test",
          "LCD Lid open/close degree check no flickering",
          "No part Replacement",
          "Speaker/Audio jack/Webcam/Microphone",
          "Update latest BIOS/FW/Driver",
          "Update MTM/SN/UUID/Product Name",
          "USB & I/O Ports/SD Slot/Sim Slot",
        ];
        for (int i = 0; i < labels.length; i++) {
          final isChecked = i < savedList.length
              ? (savedList[i] == 'true')
              : false;
          submitChecklist.add(
            ChecklistResultInput(
              id: i + 1,
              result: isChecked,
              notes: i == 0 ? (isChecked ? "Normal" : "Broken") : labels[i],
            ),
          );
        }
      } else {
        submitChecklist.addAll(
          _checklist.map(
            (c) => ChecklistResultInput(
              id: c.id,
              result: c.result,
              notes: c.notes,
            ),
          ),
        );
      }

      final List<PartChangeInput> partChanges = [];

      for (int i = 0; i < _installedParts.length; i++) {
        partChanges.add(
          PartChangeInput(
            partId: _toValidUuid(_installedParts[i].id),
            changeType: 'installed',
          ),
        );
      }

      for (int i = 0; i < _uninstalledParts.length; i++) {
        partChanges.add(
          PartChangeInput(
            partId: _toValidUuid(_uninstalledParts[i].id),
            changeType: 'uninstalled',
          ),
        );
      }

      final request = CompleteWorkOrderRequest(
        mtm: mtm,
        serialNumber: serialNumber,
        partChanges: partChanges,
        diagnosis: diagnosticNotes,
        latitude: lat,
        longitude: lng,
        signatureFileName: 'signature.png',
        checklist: submitChecklist,
      );

      // Call API (using repository or usecase if available)
      final repo = sl<WorkOrderRepository>();
      await repo.completeWorkOrder(workOrderId, request);

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

  String _toValidUuid(String id) {
    final uuidRegex = RegExp(
      r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
    );
    if (uuidRegex.hasMatch(id)) return id;
    return '11111111-2222-3333-4444-555555555551';
  }

  // --- Draft Persistence ---

  Future<void> _loadDraft() async {
    _isLoading = true;
    try {
      try {
        final cleanId = workOrderId.replaceAll('#', '');
        final wo = await getSingleWorkOrderUseCase.execute(cleanId);
        _workOrderNum = wo.workOrderNum;
        _appointment = wo.appointment;
        _isReadOnly =
            wo.status == WorkOrderStatus.complete ||
            wo.status == WorkOrderStatus.rejected ||
            wo.status == WorkOrderStatus.rejectInReview;
      } catch (e) {
        debugPrint("Failed to fetch work order: $e");
      }

      final draft = await workOrderDraftUseCase.get(workOrderId);
      if (draft != null) {
        // Update parts and photos first (they don't trigger listeners)
        _uninstalledParts.clear();
        final hasOldOrMockParts =
            draft.uninstalledParts.any(
              (p) =>
                  p.id.startsWith('P-') ||
                  p.id.startsWith('11111111') ||
                  p.serialNumber == '1234567',
            ) ||
            draft.installedParts.any(
              (p) =>
                  p.id.startsWith('P-') ||
                  p.id.startsWith('22222222') ||
                  p.serialNumber == '1234567',
            );

        if (hasOldOrMockParts) {
          _setInitialMockData();
        } else {
          _uninstalledParts.addAll(draft.uninstalledParts);
          _installedParts.clear();
          _installedParts.addAll(draft.installedParts);
        }

        _prePhotos.clear();
        _prePhotos.addAll(draft.prePhotos);
        _duringPhotos.clear();
        _duringPhotos.addAll(draft.duringPhotos);
        _postPhotos.clear();
        _postPhotos.addAll(draft.postPhotos);

        _checklist.clear();
        if (draft.checklist.isEmpty) {
          _checklist.addAll([
            TechWorkOrderChecklistItem(id: 1, result: true, notes: "Normal"),
            TechWorkOrderChecklistItem(
              id: 2,
              result: false,
              notes: "AC adapter/battery charging",
            ),
            TechWorkOrderChecklistItem(
              id: 3,
              result: false,
              notes: "Lan Port/Wifi/WWAN/Bluetooth",
            ),
            TechWorkOrderChecklistItem(
              id: 4,
              result: false,
              notes: "LCD touch/rotate/flip test",
            ),
            TechWorkOrderChecklistItem(
              id: 5,
              result: false,
              notes: "LCD Lid open/close degree check no flickering",
            ),
            TechWorkOrderChecklistItem(
              id: 6,
              result: false,
              notes: "No part Replacement",
            ),
            TechWorkOrderChecklistItem(
              id: 7,
              result: false,
              notes: "Speaker/Audio jack/Webcam/Microphone",
            ),
            TechWorkOrderChecklistItem(
              id: 8,
              result: false,
              notes: "Update latest BIOS/FW/Driver",
            ),
            TechWorkOrderChecklistItem(
              id: 9,
              result: false,
              notes: "Update MTM/SN/UUID/Product Name",
            ),
            TechWorkOrderChecklistItem(
              id: 10,
              result: false,
              notes: "USB & I/O Ports/SD Slot/Sim Slot",
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
    mtmController.text = '';
    serialNumberController.text = '';
    diagnosticNotesController.text = '';

    _uninstalledParts.clear();
    _installedParts.clear();
    _checklist.clear();
    _checklist.addAll([
      TechWorkOrderChecklistItem(id: 1, result: true, notes: "Normal"),
      TechWorkOrderChecklistItem(
        id: 2,
        result: false,
        notes: "AC adapter/battery charging",
      ),
      TechWorkOrderChecklistItem(
        id: 3,
        result: false,
        notes: "Lan Port/Wifi/WWAN/Bluetooth",
      ),
      TechWorkOrderChecklistItem(
        id: 4,
        result: false,
        notes: "LCD touch/rotate/flip test",
      ),
      TechWorkOrderChecklistItem(
        id: 5,
        result: false,
        notes: "LCD Lid open/close degree check no flickering",
      ),
      TechWorkOrderChecklistItem(
        id: 6,
        result: false,
        notes: "No part Replacement",
      ),
      TechWorkOrderChecklistItem(
        id: 7,
        result: false,
        notes: "Speaker/Audio jack/Webcam/Microphone",
      ),
      TechWorkOrderChecklistItem(
        id: 8,
        result: false,
        notes: "Update latest BIOS/FW/Driver",
      ),
      TechWorkOrderChecklistItem(
        id: 9,
        result: false,
        notes: "Update MTM/SN/UUID/Product Name",
      ),
      TechWorkOrderChecklistItem(
        id: 10,
        result: false,
        notes: "USB & I/O Ports/SD Slot/Sim Slot",
      ),
    ]);
    notifyListeners();
  }

  Future<void> _saveDraft() async {
    if (_isLoading || _isReadOnly) return;

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

  void updateCosmeticCheck(String value) {
    final index = _checklist.indexWhere((item) => item.id == 1);
    if (index != -1) {
      _checklist[index] = TechWorkOrderChecklistItem(
        id: 1,
        result: value == 'Normal',
        notes: value,
      );
      _saveDraft();
      notifyListeners();
    }
  }

  // Photo Management
  bool _isPhotoUploading = false;
  bool get isPhotoUploading => _isPhotoUploading;

  String? _photoUploadError;
  String? get photoUploadError => _photoUploadError;

  void clearPhotoUploadError() {
    _photoUploadError = null;
  }

  Future<void> _compressImage(String path) async {
    try {
      final file = File(path);
      final bytes = await file.readAsBytes();
      final image = img.decodeImage(bytes);
      if (image == null) {
        debugPrint("Failed to decode image at $path");
        return;
      }

      // Resize the image to a maximum width of 1080px (maintain aspect ratio)
      img.Image resized;
      if (image.width > 1080) {
        resized = img.copyResize(image, width: 1080);
      } else {
        resized = image;
      }

      // Compress to JPEG with 80% quality
      final compressedBytes = img.encodeJpg(resized, quality: 80);

      // Write back to the same file path
      await file.writeAsBytes(compressedBytes);
      debugPrint(
        "Image compressed successfully: ${bytes.length} -> ${compressedBytes.length} bytes",
      );
    } catch (e) {
      debugPrint("Error compressing image: $e");
    }
  }

  Future<void> addPhoto(String path, String phase) async {
    if (_isReadOnly) return;
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
    if (target.length >= 5) return;

    _isPhotoUploading = true;
    _photoUploadError = null;
    notifyListeners();

    try {
      // 1. Get current location for EXIF and geofencing
      final pos = await _getCurrentLocation();
      final lat = pos?.latitude ?? 10.7769; // Fallback to HCM
      final lng = pos?.longitude ?? 106.7009;

      // Compress the image first
      debugPrint("Compressing image before upload...");
      await _compressImage(path);

      // 2. Write GPS EXIF attributes
      await _writeGpsToExif(path, lat, lng);

      // 3. Upload & verify via media API
      final repo = sl<WorkOrderRepository>();
      await repo.uploadClosingFormPhoto(workOrderId, path, lat, lng, phase);

      // 4. Add to target list if successful
      target.add(path);
      await _saveDraft();
    } catch (e) {
      _photoUploadError = e.toString().replaceAll('Exception: ', '');
      debugPrint("Photo verification failed: $_photoUploadError");
    } finally {
      _isPhotoUploading = false;
      notifyListeners();
    }
  }

  // GPS & EXIF Helper Methods
  Future<Position?> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return null;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return null;
      }

      if (permission == LocationPermission.deniedForever) return null;

      try {
        return await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            timeLimit: Duration(seconds: 5),
          ),
        );
      } catch (_) {
        return null;
      }
    } catch (_) {
      return null;
    }
  }

  Future<void> _writeGpsToExif(
    String imagePath,
    double latitude,
    double longitude,
  ) async {
    try {
      final exif = await Exif.fromPath(imagePath);
      final latRef = latitude >= 0 ? 'N' : 'S';
      final lngRef = longitude >= 0 ? 'E' : 'W';

      final now = DateTime.now();
      final formattedDate =
          "${now.year.toString().padLeft(4, '0')}:"
          "${now.month.toString().padLeft(2, '0')}:"
          "${now.day.toString().padLeft(2, '0')} "
          "${now.hour.toString().padLeft(2, '0')}:"
          "${now.minute.toString().padLeft(2, '0')}:"
          "${now.second.toString().padLeft(2, '0')}";

      await exif.writeAttributes({
        'GPSLatitude': latitude.abs().toString(),
        'GPSLatitudeRef': latRef,
        'GPSLongitude': longitude.abs().toString(),
        'GPSLongitudeRef': lngRef,
        'DateTime': formattedDate,
        'DateTimeOriginal': formattedDate,
        'DateTimeDigitized': formattedDate,
      });
      await exif.close();
      debugPrint("Exif attributes written successfully for $imagePath");
    } catch (e) {
      debugPrint("Error writing Exif attributes: $e");
    }
  }

  void removePhoto(int index, String phase) {
    if (_isReadOnly) return;
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
  void addUninstalledPart(
    String partId,
    String partName,
    String? serialNumber,
  ) {
    if (_isReadOnly) return;
    final newPart = TechWorkOrderPart(
      id: partId,
      name: partName,
      serialNumber: serialNumber,
      quantity: 1,
    );
    _uninstalledParts.add(newPart);
    _saveDraft();
    notifyListeners();
  }

  void addInstalledPart(String partId, String partName, String? serialNumber) {
    if (_isReadOnly) return;
    final newPart = TechWorkOrderPart(
      id: partId,
      name: partName,
      serialNumber: serialNumber,
      quantity: 1,
    );
    _installedParts.add(newPart);
    _saveDraft();
    notifyListeners();
  }

  void removeUninstalledPart(String id) {
    if (_isReadOnly) return;
    _uninstalledParts.removeWhere((p) => p.id == id);
    _saveDraft();
    notifyListeners();
  }

  void removeInstalledPart(String id) {
    if (_isReadOnly) return;
    _installedParts.removeWhere((p) => p.id == id);
    _saveDraft();
    notifyListeners();
  }
}
