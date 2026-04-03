import 'package:flutter/material.dart';

class CustomerSecurityViewModel extends ChangeNotifier {
  void saveChanges(BuildContext context) {
    debugPrint('Viewmodel: Saving Security changes...');
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Security changes saved!')));
  }
}
