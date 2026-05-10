import 'package:flutter/material.dart';

class DeviceRegistrationViewModel extends ChangeNotifier {
  // Step 2 unlocked state
  bool isStep2Enabled = false;
  bool isStep2Expanded = false;

  // Checkbox state
  bool sendConfirmationEmail = false;

  // Controllers Step 1
  final TextEditingController serialController = TextEditingController();

  // Controllers Step 2
  final TextEditingController addressCtrl = TextEditingController();
  final TextEditingController firstNameCtrl = TextEditingController();
  final TextEditingController lastNameCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController phoneCtrl = TextEditingController();

  // Dropdown values
  String country = 'VIET NAM';
  String? stateVal;
  String? cityVal;

  List<String> states = ['An Giang', 'Binh Duong', 'Ho Chi Minh'];
  List<String> cities = ['Thành phố Châu Đốc', 'Dĩ An', 'Quận 1'];

  // Logic Submit Step 1
  Future<void> submitDevice() async {
    final serial = serialController.text.trim();
    if (serial.isEmpty) return;

    /* 
    try {
      // API check serial number
      final isValid = await apiService.verifySerialNumber(serial);
      if (isValid) {
        isStep2Enabled = true;
        isStep2Expanded = true;
      } else {
        // Show errors
      }
    } catch (e) {
      // Network error, show message
    }
    */

    // --- MOCK LOGIC: Auto-pass for test ---
    debugPrint("Checking serial: $serial...");
    await Future.delayed(const Duration(milliseconds: 500));
    isStep2Enabled = true;
    isStep2Expanded = true;
    notifyListeners();
  }

  void toggleStep2() {
    if (isStep2Enabled) {
      isStep2Expanded = !isStep2Expanded;
      notifyListeners();
    }
  }

  void toggleCheckbox(bool? value) {
    sendConfirmationEmail = value ?? false;
    notifyListeners();
  }

  @override
  void dispose() {
    serialController.dispose();
    addressCtrl.dispose();
    firstNameCtrl.dispose();
    lastNameCtrl.dispose();
    emailCtrl.dispose();
    phoneCtrl.dispose();
    super.dispose();
  }
}
