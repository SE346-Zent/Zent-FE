import 'package:flutter/material.dart';

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
  int currentStep = 1;

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
  String? country = 'VIET NAM';
  String? state;
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

  // Mock Dropdown Data
  final List<String> countries = ['VIET NAM'];
  final List<String> states = ['An Giang', 'Hà Nội', 'Hồ Chí Minh'];
  final Map<String, List<String>> _citiesByState = {
    'An Giang': [
      'Thành phố Châu Đốc',
      'Thành phố Long Xuyên',
      'Thị xã Tân Châu',
    ],
    'Hà Nội': ['Ba Đình', 'Hoàn Kiếm', 'Đống Đa', 'Tây Hồ', 'Cầu Giấy'],
    'Hồ Chí Minh': [
      'Quận 1',
      'Quận 3',
      'Quận 5',
      'Quận 7',
      'Thành phố Thủ Đức',
    ],
  };

  List<String> get availableCities =>
      state != null ? (_citiesByState[state!] ?? []) : [];

  void updateState(String newState) {
    state = newState;
    city = null; // reset city when state changes
    notifyListeners();
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

  // Selected device
  String? selectedSerialNumber;

  void selectDevice(String sn) {
    selectedSerialNumber = sn;
    notifyListeners();
  }

  void selectService(String serviceId) {
    selectedServiceId = serviceId;
    notifyListeners();
  }

  void initContactInfo() {
    // Auto-fill from UserProvider mock if not set
    firstName ??= 'Hung';
    lastName ??= 'dep zai';
    email ??= 'example@gmail.com';
  }

  void saveContactInfo({
    String? firstNameVal,
    String? lastNameVal,
    String? emailVal,
    String? phoneVal,
    String? countryVal,
    String? stateVal,
    String? cityVal,
    String? addressVal,
    String? buildingVal,
  }) {
    firstName = firstNameVal;
    lastName = lastNameVal;
    email = emailVal;
    phone = phoneVal;
    country = countryVal;
    state = stateVal;
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

  Future<void> pickDate(BuildContext context) async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2050),
    );
    if (date == null) return;

    if (!context.mounted) return;

    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
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
      currentStep++;
      notifyListeners();
    }
  }

  void previousStep() {
    if (currentStep > 1) {
      currentStep--;
      notifyListeners();
    }
  }

  void submitTicket(BuildContext context) {
    // Go to step 5 on success
    currentStep = 5;
    notifyListeners();
  }

  void reset() {
    currentStep = 1;
    symptom = null;
    ticketRef = null;
    description = null;
    appointmentDate = null;

    firstName = null;
    lastName = null;
    email = null;
    phone = null;
    country = 'VIET NAM';
    state = null;
    city = null;
    address = null;
    building = null;

    isEditingAdditionalInfo = false;
    isEditingContact = false;
    isEditingAddress = false;

    selectedServiceId = null;
    selectedSerialNumber = null;

    notifyListeners();
  }
}
