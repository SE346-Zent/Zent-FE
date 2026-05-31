import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zent_fe/data/models/create_work_order_request.dart';
import 'package:zent_fe/di/injection_container.dart';
import 'package:zent_fe/domain/usecases/work_order/create_work_order_usecase.dart';
import 'package:zent_fe/presentation/common/auth/auth_view_model.dart';
import 'package:zent_fe/data/datasources/local/auth_local_datasource.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class ServiceTypeData {
  final String id;
  final String name;
  final String description;
  final IconData icon;

  ServiceTypeData({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
  });
}

class RequestServiceViewModel extends ChangeNotifier {
  final CreateWorkOrderUseCase createWorkOrderUseCase;

  static const List<String> symptomsList = [
    "Active Noise Cancelling(ANC)",
    "Backpack",
    "Bluetooth",
    "Case",
    "Charger",
    "External Hot Spot Issue",
    "External Keyboard",
    "External Mouse",
    "External Storage(USB/SSD/etc)",
    "Glasses",
    "Headset",
    "Kit(Mouse and Keyboard)",
    "MousePad",
    "Other",
    "PC Port not working properly",
    "Pen",
    "Printer",
    "Web Camera",
    "Audio",
    "Battery",
    "Boot issue",
    "Branding",
    "Camera",
    "Charging",
    "Covers",
    "Display",
    "Dock",
    "Drive (SSD / HDD)",
    "External Display",
    "Fan",
    "Fingerprint",
    "Keyboards",
    "Network",
    "No Post",
    "No Power",
    "Noise",
    "Non Technical",
    "Operating System (OS)",
    "Performance",
    "Physical Damage (CID)",
    "Physical Damage (Not CID)",
    "Pointing Devices",
    "Power Button",
    "Safety issue",
    "Smart card reader",
    "Smart Collab",
    "Software",
    "USB Port",
    "Other",
  ];

  RequestServiceViewModel(this.createWorkOrderUseCase);

  int _currentStep = 1;
  bool _isLoading = false;

  int get currentStep => _currentStep;
  bool get isLoading => _isLoading;

  // Selected device
  String? selectedProductId;
  String? selectedSerialNumber;

  // Selected information for Step 2
  String? symptom;
  String? ticketRef;
  String? description;
  String? appointmentDate;

  // Step 3 Data: Contact Info
  String? firstName;
  String? lastName;
  String? email;
  String? phone;

  // Step 3 Data: Address Info
  String? country = 'Vietnam';
  String? ward;
  String? city;
  String? address;
  String? building;

  // Step 4 Data: Edit States
  bool isEditingAdditionalInfo = false;
  bool isEditingContact = false;
  bool isEditingAddress = false;

  void toggleEditSection(String sectionName) {
    if (sectionName == 'Additional Info') {
      isEditingAdditionalInfo = !isEditingAdditionalInfo;
    } else if (sectionName == 'Contact Info') {
      isEditingContact = !isEditingContact;
    } else if (sectionName == 'Address') {
      isEditingAddress = !isEditingAddress;
    }
    notifyListeners();
  }

  final List<String> countries = ['Vietnam'];
  final List<String> wards = [];
  final Map<String, List<String>> _citiesByWard = {};

  Future<void> loadLocationData() async {
    if (wards.isNotEmpty) return;

    try {
      final String response = await rootBundle.loadString(
        'assets/data/vietnam_location.json',
      );
      final List<dynamic> data = json.decode(response);

      wards.clear();
      _citiesByWard.clear();

      for (var item in data) {
        final wardName = item['name'] as String;
        final citiesList = (item['cities'] as List)
            .map((e) => e.toString())
            .toList();

        wards.add(wardName);
        _citiesByWard[wardName] = citiesList;
      }

      notifyListeners();
    } catch (e) {
      debugPrint("Error loading location data: $e");
    }
  }

  List<String> get availableCities =>
      ward != null ? (_citiesByWard[ward!] ?? []) : [];

  void updateWard(String newWard) {
    if (ward != newWard) {
      ward = newWard;
      city = null;
      _saveDraft();
      notifyListeners();
    }
  }

  void updateCity(String newCity) {
    city = newCity;
    _saveDraft();
    notifyListeners();
  }

  // Selected service type
  String? selectedServiceId;

  final List<ServiceTypeData> serviceTypes = [
    ServiceTypeData(
      id: 'repair',
      name: 'Repair Service',
      description: 'Fix broken components and restore functionality',
      icon: Icons.build_rounded,
    ),
    ServiceTypeData(
      id: 'maintenance',
      name: 'Maintenance Service',
      description: 'Preventative care and routine checkups',
      icon: Icons.handyman_rounded,
    ),
    ServiceTypeData(
      id: 'warranty',
      name: 'Warranty Extension',
      description: 'Extend your product warranty period',
      icon: Icons.security_rounded,
    ),
  ];

  void selectDevice(String id, String sn) {
    selectedProductId = id;
    selectedSerialNumber = sn;
    notifyListeners();
  }

  void selectService(String serviceId) {
    selectedServiceId = serviceId;
    _saveDraft();
    notifyListeners();
  }

  Future<void> initContactInfo() async {
    loadLocationData();
    var user = sl<AuthViewModel>().currentUser;

    if (user == null) {
      try {
        final localDs = sl<AuthLocalDataSource>();
        user = await localDs.getUser();
      } catch (_) {}
    }

    if (user != null) {
      if (firstName == null || firstName!.isEmpty) {
        final parts = user.name.split(' ');
        firstName = parts.isNotEmpty ? parts.first : '';
        lastName = parts.length > 1 ? parts.sublist(1).join(' ') : '';
      }
      email ??= user.email;
    }
  }

  void saveContactInfo({
    String? firstNameVal,
    String? lastNameVal,
    String? emailVal,
    String? phoneVal,
    String? countryVal,
    String? wardVal,
    String? cityVal,
    String? addressVal,
    String? buildingVal,
  }) {
    firstName = firstNameVal;
    lastName = lastNameVal;
    email = emailVal;
    phone = phoneVal;
    country = countryVal;
    ward = wardVal;
    city = cityVal;
    address = addressVal;
    building = buildingVal;
    _saveDraft();
    notifyListeners();
  }

  void saveInfo({
    String? symptomVal,
    String? ticketRefVal,
    String? descriptionVal,
    String? appointmentDateVal,
  }) {
    symptom = symptomVal;
    ticketRef = ticketRefVal;
    description = descriptionVal;
    appointmentDate = appointmentDateVal;
    _saveDraft();
    notifyListeners();
  }

  Future<TimeOfDay?> _showCustomTimePicker(BuildContext context) async {
    TimeOfDay selectedTime = const TimeOfDay(hour: 7, minute: 0);
    return showDialog<TimeOfDay>(
      context: context,
      builder: (BuildContext ctx) {
        return StatefulBuilder(
          builder: (ctx, setState) {
            return AlertDialog(
              title: const Text('Select Appointment Time'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Available hours: 07:00 - 17:00'),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DropdownButton<int>(
                        value: selectedTime.hour,
                        items: List.generate(11, (index) => index + 7).map((
                          hour,
                        ) {
                          return DropdownMenuItem(
                            value: hour,
                            child: Text(hour.toString().padLeft(2, '0')),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() {
                              selectedTime = TimeOfDay(
                                hour: val,
                                minute: val == 17 ? 0 : selectedTime.minute,
                              );
                            });
                          }
                        },
                      ),
                      const Text(' : '),
                      DropdownButton<int>(
                        value: selectedTime.minute,
                        items: [0, 15, 30, 45]
                            .where((m) => !(selectedTime.hour == 17 && m > 0))
                            .map((minute) {
                              return DropdownMenuItem(
                                value: minute,
                                child: Text(minute.toString().padLeft(2, '0')),
                              );
                            })
                            .toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(
                              () => selectedTime = TimeOfDay(
                                hour: selectedTime.hour,
                                minute: val,
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(ctx, selectedTime),
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> pickDate(BuildContext context) async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2050),
    );
    if (date == null) return;

    if (!context.mounted) return;

    final TimeOfDay? time = await _showCustomTimePicker(context);
    if (time == null) return;

    final String hh = time.hour.toString().padLeft(2, '0');
    final String mm = time.minute.toString().padLeft(2, '0');
    final String dd = date.day.toString().padLeft(2, '0');
    final String month = date.month.toString().padLeft(2, '0');
    final String yyyy = date.year.toString().padLeft(4, '0');

    appointmentDate = '$hh:$mm, $dd/$month/$yyyy';
    notifyListeners();
  }

  Future<void> nextStep() async {
    if (currentStep < 5) {
      if (_currentStep == 1 && selectedProductId != null) {
        await _loadDraftForProduct(selectedProductId!);
        if (_currentStep > 1) {
          await _saveDraft();
          notifyListeners();
          return;
        }
      }
      _currentStep++;
      await _saveDraft();
      notifyListeners();
    }
  }

  void previousStep() {
    if (currentStep > 1) {
      _currentStep--;
      _saveDraft();
      notifyListeners();
    }
  }

  Future<void> submitTicket(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Parse the appointment date (Format from picker/mask: "HH:mm, dd/MM/yyyy")
      String formattedAppointment = '';
      if (appointmentDate != null && appointmentDate!.isNotEmpty) {
        try {
          final inputFormat = DateFormat("HH:mm, dd/MM/yyyy");
          final dateTime = inputFormat.parse(appointmentDate!);
          // Format to ISO 8601 with timezone offset (e.g. "+07:00" for Vietnam)
          final offset = dateTime.timeZoneOffset;
          final hours = offset.inHours.abs().toString().padLeft(2, '0');
          final minutes = (offset.inMinutes.abs() % 60).toString().padLeft(
            2,
            '0',
          );
          final sign = offset.isNegative ? '-' : '+';
          formattedAppointment =
              "${DateFormat("yyyy-MM-ddTHH:mm:ss").format(dateTime)}$sign$hours:$minutes";
        } catch (e) {
          debugPrint("Error parsing date: $e");
          formattedAppointment = appointmentDate!; // fallback
        }
      }

      // Map symptom string to ID (1-indexed based on symptomsList)
      int symptomId = symptomsList.indexOf(symptom ?? '') + 1;
      if (symptomId <= 0) {
        symptomId = 14; // Default to 'Other' at index 13 (14th item)
      }

      // Validation: description is required by server
      final desc = (description != null && description!.trim().isNotEmpty)
          ? description!.trim()
          : null;

      if (desc == null) {
        throw Exception('Please provide a description of the problem.');
      }

      String finalCity = city ?? '';
      String finalWard = ward ?? '';

      // Map full names to short codes for Backend
      if (finalWard.contains('Hồ Chí Minh')) {
        finalWard = 'HCM';
        finalCity = 'HCM';
      } else if (finalWard.contains('Hà Nội')) {
        finalWard = 'HN';
        finalCity = 'HN';
      }

      final request = CreateWorkOrderRequest(
        address: address ?? '',
        appointment: formattedAppointment,
        building: building,
        city: finalCity,
        country: country ?? 'Vietnam',
        description: desc,
        email: (email != null && email!.trim().isNotEmpty) ? email : null,
        firstName: firstName ?? '',
        lastName: lastName ?? '',
        phoneNumber: phone,
        productId: selectedProductId ?? '',
        referenceTicketId: (ticketRef != null && ticketRef!.trim().isNotEmpty)
            ? ticketRef
            : null,
        ward: finalWard,
        workOrderSymptomId: symptomId,
      );

      await createWorkOrderUseCase.execute(request);

      final sp = sl<SharedPreferences>();
      if (selectedProductId != null) {
        final key = await _getDraftKey(selectedProductId);
        await sp.remove(key);
      }
      final activeProductKey = await _getDraftKey('active_product');
      await sp.remove(activeProductKey);

      // Go to step 5 on success
      _currentStep = 5;
    } catch (e) {
      debugPrint("Error submitting ticket: $e");
      // Rethrow to let the UI handle or display error
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> reset() async {
    final sp = sl<SharedPreferences>();
    if (selectedProductId != null) {
      final key = await _getDraftKey(selectedProductId);
      await sp.remove(key);
    }
    final activeProductKey = await _getDraftKey('active_product');
    await sp.remove(activeProductKey);

    _currentStep = 1;
    symptom = null;
    ticketRef = null;
    description = null;
    appointmentDate = null;

    firstName = null;
    lastName = null;
    email = null;
    phone = null;
    country = 'Vietnam';
    ward = null;
    city = null;
    address = null;
    building = null;

    isEditingAdditionalInfo = false;
    isEditingContact = false;
    isEditingAddress = false;

    selectedProductId = null;
    selectedSerialNumber = null;
    selectedServiceId = null;

    notifyListeners();
  }

  Future<String> _getDraftKey(String? productId) async {
    String userPrefix = 'anonymous';
    try {
      final secureStorage = sl<FlutterSecureStorage>();
      final token = await secureStorage.read(key: 'ACCESS_TOKEN');
      if (token != null && token.isNotEmpty) {
        final payload = JwtDecoder.decode(token);
        final id = payload['id'] ?? payload['sub'] ?? payload['userId'];
        if (id != null) {
          userPrefix = id.toString();
        }
      }
    } catch (_) {}
    final productSuffix = productId ?? 'no_product';
    return 'CREATE_WO_DRAFT_${userPrefix}_$productSuffix';
  }

  Future<void> _saveDraft() async {
    if (selectedProductId == null) return;
    try {
      final sp = sl<SharedPreferences>();
      final draftMap = {
        'selectedProductId': selectedProductId,
        'selectedSerialNumber': selectedSerialNumber,
        'symptom': symptom,
        'ticketRef': ticketRef,
        'description': description,
        'appointmentDate': appointmentDate,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'phone': phone,
        'country': country,
        'province': province,
        'city': city,
        'address': address,
        'building': building,
        'currentStep': _currentStep,
        'selectedServiceId': selectedServiceId,
      };
      final key = await _getDraftKey(selectedProductId);
      await sp.setString(key, json.encode(draftMap));

      // Lưu thiết bị đang được soạn thảo gần nhất để khôi phục khi mở lại app
      final activeProductKey = await _getDraftKey('active_product');
      await sp.setString(activeProductKey, selectedProductId!);
    } catch (e) {
      debugPrint("Error saving Create WO Draft: $e");
    }
  }

  Future<void> _loadDraftForProduct(String productId) async {
    try {
      final sp = sl<SharedPreferences>();
      final key = await _getDraftKey(productId);
      final jsonString = sp.getString(key);
      if (jsonString != null) {
        final draftMap = json.decode(jsonString) as Map<String, dynamic>;
        selectedProductId = draftMap['selectedProductId'] as String?;
        selectedSerialNumber = draftMap['selectedSerialNumber'] as String?;
        symptom = draftMap['symptom'] as String?;
        ticketRef = draftMap['ticketRef'] as String?;
        description = draftMap['description'] as String?;
        appointmentDate = draftMap['appointmentDate'] as String?;
        firstName = draftMap['firstName'] as String?;
        lastName = draftMap['lastName'] as String?;
        email = draftMap['email'] as String?;
        phone = draftMap['phone'] as String?;
        country = draftMap['country'] as String? ?? 'Vietnam';
        province = draftMap['province'] as String?;
        city = draftMap['city'] as String?;
        address = draftMap['address'] as String?;
        building = draftMap['building'] as String?;
        _currentStep = draftMap['currentStep'] as int? ?? 1;
        selectedServiceId = draftMap['selectedServiceId'] as String?;

        if (province != null) {
          loadLocationData();
        }
      } else {
        // Reset các trường thông tin lỗi nếu sản phẩm được chọn chưa có bản nháp nào
        symptom = null;
        ticketRef = null;
        description = null;
        appointmentDate = null;
        _currentStep = 1;
      }
      notifyListeners();
    } catch (e) {
      debugPrint("Error loading product-specific draft: $e");
    }
  }
}
