import 'package:flutter/material.dart';
import '../../../../domain/usecases/work_order/add_part_usecase.dart';
import '../../../../data/models/add_part_request.dart';

class AddNewPartViewModel extends ChangeNotifier {
  final AddPartUseCase addPartToWorkOrderUseCase;

  AddNewPartViewModel({required this.addPartToWorkOrderUseCase});

  final TextEditingController partNameController = TextEditingController();
  final TextEditingController mtmController = TextEditingController();
  final TextEditingController serialController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  bool _isDisposed = false;
  bool isLoading = false;
  String? errorMessage;

  final List<String> _photos = [];
  List<String> get photos => _photos;

  String? _category;
  String? get category => _category;

  @override
  void dispose() {
    _isDisposed = true;
    partNameController.dispose();
    mtmController.dispose();
    serialController.dispose();
    descController.dispose();
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_isDisposed) super.notifyListeners();
  }

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

  int _getCategoryId() {
    switch (_category) {
      case 'Control Board': return 1;
      case 'Display Panel': return 2;
      case 'Battery': return 3;
      case 'Motor': return 4;
      default: return 5;
    }
  }

  Future<bool> submitPartRequest(String workOrderId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final request = AddPartRequest(
        partNumber: partNameController.text.trim(), 
        partTypesId: _getCategoryId(),
        serialNumber: serialController.text.trim(),
        description: descController.text.trim(),
        modelCode: mtmController.text.trim(),
        photos: _photos,
      );

      await addPartToWorkOrderUseCase.execute(workOrderId, request);

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
}