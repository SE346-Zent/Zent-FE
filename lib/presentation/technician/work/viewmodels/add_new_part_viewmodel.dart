import 'package:zent_fe/presentation/common/core/safe_change_notifier.dart';
import 'package:flutter/material.dart';
import 'package:zent_fe/domain/usecases/inventory/zent_inventory_usecases.dart';
import 'package:zent_fe/domain/usecases/inventory/get_inventory_usecases.dart';
import 'package:zent_fe/data/services/chat_service.dart';
import 'package:zent_fe/presentation/common/core/utils/image_utils.dart';

class AddNewPartViewModel extends ChangeNotifier with SafeChangeNotifier {
  final AddPartsToWorkOrderUseCase addPartsToWorkOrderUseCase;
  final GetScmLutsUseCase? getScmLutsUseCase;
  final ChatService? chatService;

  AddNewPartViewModel({
    required this.addPartsToWorkOrderUseCase,
    this.getScmLutsUseCase,
    this.chatService,
  });

  bool _isDisposed = false;

  @override
  void dispose() {
    _isDisposed = true;
    partNameController.dispose();
    mtmController.dispose();
    serialNumberController.dispose();
    descriptionController.dispose();
    woNumberController.dispose();
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_isDisposed) {
      super.notifyListeners();
    }
  }

  // Form controllers
  final TextEditingController partNameController = TextEditingController();
  final TextEditingController mtmController = TextEditingController();
  final TextEditingController serialNumberController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController woNumberController = TextEditingController();

  // Photos
  final List<String> _photos = [];
  List<String> get photos => _photos;

  // Category
  String? _category;
  String? get category => _category;

  final List<String> categories = [
    'Control Board',
    'Display Panel',
    'Battery',
    'Motor',
    'Other',
  ];

  Future<void> loadCategories() async {
    // Mimic loading
    notifyListeners();
  }

  // State
  bool isSubmitting = false;
  String? errorMessage;

  void setCategory(String? val) {
    _category = val;
    notifyListeners();
  }

  void addPhotoFromPath(String path) {
    if (_photos.length < 5) {
      _photos.add(path);
      notifyListeners();
    }
  }

  void removePhoto(int index) {
    if (index >= 0 && index < _photos.length) {
      _photos.removeAt(index);
      notifyListeners();
    }
  }

  /// Submit the new part to the work order via Zent BE
  Future<bool> submitPart({
    required String workOrderId,
    required String workOrderNumber,
  }) async {
    final partName = partNameController.text.trim();
    final serialNumber = serialNumberController.text.trim();
    if (partName.isEmpty || serialNumber.isEmpty) {
      errorMessage = 'Part name and serial number are required';
      notifyListeners();
      return false;
    }

    isSubmitting = true;
    errorMessage = null;
    notifyListeners();

    try {
      if (_photos.isNotEmpty) {
        for (final path in _photos) {
          await ImageUtils.compressImage(path);
        }
      }

      await addPartsToWorkOrderUseCase.execute(
        workOrderId: workOrderId,
        partNumber: partName,
        partTypesId: 1, // Default part type
        serialNumber: serialNumber,
        workOrderNumber: workOrderNumber,
        description: descriptionController.text.trim().isNotEmpty
            ? descriptionController.text.trim()
            : null,
        modelCode: mtmController.text.trim().isNotEmpty
            ? mtmController.text.trim()
            : null,
        photos: _photos.isNotEmpty ? _photos : null,
      );
      return true;
    } catch (e) {
      errorMessage = 'Failed to add part: $e';
      debugPrint('Error submitting part: $e');
      return false;
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }
}
