import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zent_fe/data/models/create_work_order_request.dart';
import 'package:zent_fe/di/injection_container.dart';
import 'package:zent_fe/domain/usecases/work_order/create_work_order_usecase.dart';
import 'package:zent_fe/presentation/common/auth/auth_view_model.dart';
import 'package:intl/intl.dart';

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
  String? province;
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
  final List<String> provinces = [];
  final Map<String, List<String>> _citiesByProvince = {};

  Future<void> loadLocationData() async {
    if (provinces.isNotEmpty) return;

    try {
      final String response = await rootBundle.loadString(
        'assets/data/vietnam_location.json',
      );
      final List<dynamic> data = json.decode(response);

      provinces.clear();
      _citiesByProvince.clear();

      for (var item in data) {
        final provinceName = item['name'] as String;
        final citiesList = (item['cities'] as List)
            .map((e) => e.toString())
            .toList();

        provinces.add(provinceName);
        _citiesByProvince[provinceName] = citiesList;
      }

      notifyListeners();
    } catch (e) {
      debugPrint("Lỗi tải file địa giới hành chính: $e");
    }
  }

  List<String> get availableCities =>
      province != null ? (_citiesByProvince[province!] ?? []) : [];

  void updateProvince(String newProvince) {
    if (province != newProvince) {
      province = newProvince;
      city = null;
      notifyListeners();
    }
  }

  void updateCity(String newCity) {
    city = newCity;
    notifyListeners();
  }

  // Selected service type (old - keeping for compatibility)
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
    notifyListeners();
  }

  void initContactInfo() {
    loadLocationData();
    // Auto-fill from logged-in user if not set
    final user = sl<AuthViewModel>().currentUser;
    if (user != null) {
      if (firstName == null || firstName!.isEmpty) {
        final parts = user.name.split(' ');
        firstName = parts.first;
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
    String? provinceVal,
    String? cityVal,
    String? addressVal,
    String? buildingVal,
  }) {
    firstName = firstNameVal;
    lastName = lastNameVal;
    email = emailVal;
    phone = phoneVal;
    country = countryVal;
    province = provinceVal;
    city = cityVal;
    address = addressVal;
    building = buildingVal;
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

  void nextStep() {
    if (currentStep < 5) {
      _currentStep++;
      notifyListeners();
    }
  }

  void previousStep() {
    if (currentStep > 1) {
      _currentStep--;
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
          // Format to ISO 8601: "yyyy-MM-ddTHH:mm:ssZ"
          formattedAppointment =
              "${DateFormat("yyyy-MM-ddTHH:mm:ss").format(dateTime)}Z";
        } catch (e) {
          debugPrint("Error parsing date: $e");
          formattedAppointment = appointmentDate!; // fallback
        }
      }

      // Map symptom string to ID
      int symptomId = 1; // Default
      switch (symptom) {
        case 'Screen Broken':
          symptomId = 1;
          break;
        case 'Battery Issue':
          symptomId = 2;
          break;
        case 'Software Glitch':
          symptomId = 3;
          break;
        case 'Hardware Damage':
          symptomId = 4;
          break;
        case 'Other':
          symptomId = 5;
          break;
      }

      // Validation: description is required by server
      final desc = (description != null && description!.trim().isNotEmpty)
          ? description!.trim()
          : null;

      if (desc == null) {
        throw Exception('Please provide a description of the problem.');
      }

      String finalCity = city ?? '';
      String finalProvince = province ?? '';

      // Map full names to short codes for Backend
      if (finalProvince.contains('Hồ Chí Minh')) {
        finalProvince = 'HCM';
        finalCity = 'HCM';
      } else if (finalProvince.contains('Hà Nội')) {
        finalProvince = 'HN';
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
        province: finalProvince,
        workOrderSymptomId: symptomId,
      );

      await createWorkOrderUseCase.execute(request);

      // Go to step 5 on success
      _currentStep = 5;
    } catch (e) {
      debugPrint("Error submitting ticket: $e");
      if (context.mounted) {
        debugPrint('Failed to submit ticket: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void reset() {
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
    province = null;
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
}
