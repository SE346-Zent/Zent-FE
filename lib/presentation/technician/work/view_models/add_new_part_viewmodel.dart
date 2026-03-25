import 'package:flutter/foundation.dart';

class AddNewPartViewModel extends ChangeNotifier {
  bool _isDisposed = false;

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_isDisposed) {
      super.notifyListeners();
    }
  }

  final List<String> _photos = [];
  List<String> get photos => _photos;

  String? _category;
  String? get category => _category;

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
}
