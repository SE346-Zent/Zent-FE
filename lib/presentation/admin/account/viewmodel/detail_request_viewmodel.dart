import 'package:flutter/material.dart';
import 'package:zent_fe/presentation/common/core/app_assets.dart';

class DetailRequestViewModel extends ChangeNotifier {
  final partNameController = TextEditingController(text: 'PARTNAME123');
  final mtmController = TextEditingController(text: '123456');
  final serialNumberController = TextEditingController(text: '1234568');
  final descriptionController = TextEditingController(
    text:
        'The product model is too old and maybe this part is not added to the inventory system.',
  );

  final List<String> categories = ['Hybrid', 'Standard', 'Premium'];
  String selectedCategory = 'Hybrid';

  final List<String> photoUrls = [
    AppAssets.partPhoto1,
    AppAssets.partPhoto2,
    AppAssets.partPhoto3,
    AppAssets.partPhoto4,
  ];

  void setCategory(String? newCategory) {
    if (newCategory != null) {
      selectedCategory = newCategory;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    partNameController.dispose();
    mtmController.dispose();
    serialNumberController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}
