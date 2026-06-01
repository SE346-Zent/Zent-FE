import 'package:zent_fe/presentation/common/core/safe_change_notifier.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zent_fe/domain/entities/warranty_check_result.dart';
import 'package:zent_fe/domain/usecases/inventory/zent_inventory_usecases.dart';
import 'package:zent_fe/domain/usecases/inventory/get_inventory_usecases.dart';
import 'package:zent_fe/domain/exceptions/business_exception.dart';

class DeviceRegistrationViewModel extends ChangeNotifier
    with SafeChangeNotifier {
  final CheckWarrantyUseCase checkWarrantyUseCase;
  final RegisterProductUseCase registerProductUseCase;
  final GetScmProductsUseCase? getScmProductsUseCase;

  DeviceRegistrationViewModel({
    required this.checkWarrantyUseCase,
    required this.registerProductUseCase,
    this.getScmProductsUseCase,
  }) {
    _loadLocationData();
  }

  // Guard against use-after-dispose
  bool _disposed = false;

  // Step 2 unlocked state
  bool isStep2Enabled = false;
  bool isStep2Expanded = false;

  // Loading states
  bool isCheckingWarranty = false;
  bool isRegistering = false;
  String? warrantyMessage;
  WarrantyCheckResult? warrantyResult;

  String? errorMessage; // To hold BusinessException message for UI

  // Checkbox state
  bool sendConfirmationEmail = false;

  // Controllers Step 1
  final TextEditingController serialController = TextEditingController();

  // Controllers Step 2
  final TextEditingController addressCtrl = TextEditingController();
  final TextEditingController countryCtrl = TextEditingController(
    text: 'VIET NAM',
  );
  final TextEditingController firstNameCtrl = TextEditingController();
  final TextEditingController lastNameCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController phoneCtrl = TextEditingController();

  // Dropdown values
  String country = 'VIET NAM';
  String? stateVal;
  String? cityVal;

  List<String> states = [];
  List<String> cities = [];
  final Map<String, List<String>> _citiesByState = {};

  Future<void> _loadLocationData() async {
    if (states.isNotEmpty) return;

    try {
      final String response = await rootBundle.loadString(
        'assets/data/vietnam_location.json',
      );
      final List<dynamic> data = json.decode(response);

      states.clear();
      _citiesByState.clear();

      for (var item in data) {
        final provinceName = item['name'] as String;
        // Restrict to "Thành phố Hồ Chí Minh" and "Thành phố Hà Nội"
        if (provinceName == 'Thành phố Hồ Chí Minh' ||
            provinceName == 'Thành phố Hà Nội') {
          final citiesList = (item['cities'] as List)
              .map((e) => e.toString())
              .toList();

          states.add(provinceName);
          _citiesByState[provinceName] = citiesList;
        }
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Error loading location data: $e');
      // Fallback to hardcoded values
      states = ['Thành phố Hồ Chí Minh', 'Thành phố Hà Nội'];
      cities = ['Quận 1', 'Quận Cầu Giấy'];
    }
  }

  void onStateChanged(String? val) {
    stateVal = val;
    cityVal = null;
    cities = val != null ? (_citiesByState[val] ?? []) : [];
    notifyListeners();
  }

  void onCityChanged(String? val) {
    cityVal = val;
    notifyListeners();
  }

  // Logic Submit Step 1 — check warranty via Zent BE and verify with SCM
  Future<void> submitDevice() async {
    final serial = serialController.text.trim();
    if (serial.isEmpty) return;

    isCheckingWarranty = true;
    warrantyMessage = null;
    notifyListeners();

    debugPrint(
      '=== [submitDevice] Starting SCM/Warranty Check for: $serial ===',
    );

    try {
      if (getScmProductsUseCase != null) {
        debugPrint(
          '[submitDevice] Searching SCM database via GetScmProductsUseCase...',
        );
        final (scmProducts, _) = await getScmProductsUseCase!.execute(
          query: serial,
        );
        final matches = scmProducts.any((p) => p.serialNumber == serial);
        debugPrint(
          '[submitDevice] SCM Products count: ${scmProducts.length}, exact match found: $matches',
        );
        if (!matches) {
          if (_disposed) return;
          warrantyMessage = 'Serial number not found in SCM database';
          isStep2Enabled = false;
          notifyListeners();
          debugPrint(
            '=== [submitDevice] FAILED: Serial number not found in SCM database ===',
          );
          return;
        }
      }

      debugPrint(
        '[submitDevice] Querying checkWarrantyUseCase for serial: $serial',
      );
      final result = await checkWarrantyUseCase.execute(serial);
      if (_disposed) return;
      warrantyResult = result;

      debugPrint('=== [submitDevice] SUCCESS RESPONSE ===');
      debugPrint('  - Product ID: ${result.productId}');
      debugPrint('  - Serial Number: ${result.serialNumber}');
      debugPrint('  - Product Name: ${result.productName}');
      debugPrint('  - Warranty Status: ${result.warrantyStatus}');
      debugPrint('  - Start Date: ${result.startDate}');
      debugPrint('  - End Date: ${result.endDate}');
      debugPrint('=========================================');

      if (result.isExpired ||
          result.warrantyStatus.toLowerCase() == 'expired') {
        isStep2Enabled = true;
        isStep2Expanded = true;
        warrantyMessage = 'Expired';
      } else if (result.isActive ||
          result.warrantyStatus.toLowerCase() == 'active') {
        isStep2Enabled = true;
        isStep2Expanded = true;
        warrantyMessage = 'Active';
      } else {
        isStep2Enabled = false;
        warrantyMessage = 'Product not found or warranty is inactive';
      }
    } catch (e) {
      if (_disposed) return;
      isStep2Enabled = false;
      warrantyMessage = 'Error checking warranty: $e';
      debugPrint('=== [submitDevice] ERROR EXCEPTION ===');
      debugPrint('Exception details: $e');
      debugPrint('=======================================');
    } finally {
      if (!_disposed) {
        isCheckingWarranty = false;
        notifyListeners();
      }
    }
  }

  // Submit full registration (Step 2)
  Future<bool> submitRegistration() async {
    if (warrantyResult == null) return false;

    isRegistering = true;
    notifyListeners();

    final serial = serialController.text.trim();
    final finalProvince = stateVal ?? '';
    final finalCity = cityVal ?? '';
    final finalAddress = addressCtrl.text.trim();
    final finalFirstName = firstNameCtrl.text.trim();
    final finalLastName = lastNameCtrl.text.trim();
    final finalEmail = emailCtrl.text.trim();
    final finalPhone = phoneCtrl.text.trim();

    debugPrint('=== [submitRegistration] Starting Device Registration ===');
    debugPrint('Request payload fields:');
    debugPrint('  - Serial Number: $serial');
    debugPrint('  - Country: $country');
    debugPrint('  - Province/State: $finalProvince');
    debugPrint('  - City/Ward: $finalCity');
    debugPrint('  - Address: $finalAddress');
    debugPrint('  - Name: $finalFirstName $finalLastName');
    debugPrint('  - Email: $finalEmail');
    debugPrint('  - Phone: $finalPhone');
    debugPrint('  - Send Email Confirmation: $sendConfirmationEmail');
    debugPrint('========================================================');

    try {
      final result = await registerProductUseCase.execute(
        serialNumber: serial,
        country: country,
        province: finalProvince,
        city: finalCity,
        address: finalAddress,
        firstName: finalFirstName,
        lastName: finalLastName,
        email: finalEmail,
        mobilePhone: finalPhone,
        sendEmailConfirmation: sendConfirmationEmail,
      );

      debugPrint('=== [submitRegistration] SUCCESS RESPONSE ===');
      debugPrint('  - Product ID: ${result.productId}');
      debugPrint('  - Serial Number: ${result.serialNumber}');
      debugPrint('  - Message: ${result.message}');
      debugPrint('  - Email Sent: ${result.emailSent}');
      debugPrint('=============================================');
      return true;
    } on BusinessException catch (e) {
      if (_disposed) return false;
      errorMessage = e.message;
      return false;
    } catch (e) {
      debugPrint('=== [submitRegistration] ERROR EXCEPTION ===');
      debugPrint('Exception details: $e');
      debugPrint('=============================================');
      return false;
    } finally {
      if (!_disposed) {
        isRegistering = false;
        notifyListeners();
      }
    }
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
    _disposed = true;
    serialController.dispose();
    addressCtrl.dispose();
    countryCtrl.dispose();
    firstNameCtrl.dispose();
    lastNameCtrl.dispose();
    emailCtrl.dispose();
    phoneCtrl.dispose();
    super.dispose();
  }
}
