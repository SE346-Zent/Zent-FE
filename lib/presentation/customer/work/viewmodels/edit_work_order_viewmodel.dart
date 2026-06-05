import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:zent_fe/di/injection_container.dart';
import 'package:zent_fe/data/datasources/local/auth_local_datasource.dart';
import 'package:zent_fe/data/models/edit_work_order_request.dart';
import 'package:zent_fe/domain/entities/product.dart';
import 'package:zent_fe/domain/entities/work_order.dart';
import 'package:zent_fe/domain/usecases/product/get_my_products_usecase.dart';
import 'package:zent_fe/domain/usecases/work_order/get_single_work_order_usecase.dart';
import 'package:zent_fe/domain/usecases/work_order/edit_work_order_usecase.dart';
import 'package:zent_fe/presentation/common/core/safe_change_notifier.dart';
import 'package:zent_fe/domain/exceptions/business_exception.dart';

class EditWorkOrderViewModel extends ChangeNotifier with SafeChangeNotifier {
  final EditWorkOrderUseCase editWorkOrderUseCase;
  final GetSingleWorkOrderUseCase getSingleWorkOrderUseCase;
  final GetMyProductsUseCase getMyProductsUseCase;
  final String workOrderId;
  final String workOrderNumber;

  EditWorkOrderViewModel({
    required this.editWorkOrderUseCase,
    required this.getSingleWorkOrderUseCase,
    required this.getMyProductsUseCase,
    required this.workOrderId,
    required this.workOrderNumber,
  });

  bool isLoading = false;
  bool isSaving = false;
  String? errorMessage;

  WorkOrder? workOrder;
  List<Product> products = [];

  // Selected values
  String? selectedProductId;
  String? selectedSerialNumber;

  // Address fields
  String? country = 'Vietnam';
  String? city; // Ward
  String? address;
  String? building;

  // Appointment
  String? appointmentDate;

  final List<String> countries = ['Vietnam'];
  final List<String> wards = [];

  Future<void> loadDetails() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      // 1. Load Location Meta
      await loadLocationData();

      // 2. Fetch User & Products
      final localDs = sl<AuthLocalDataSource>();
      final user = await localDs.getUser();
      if (user == null) {
        throw Exception("User not logged in");
      }

      final userProducts = await getMyProductsUseCase.execute(user.id);
      products = List<Product>.from(userProducts);

      // 3. Fetch Work Order Details
      final cleanId = workOrderId.replaceAll('#', '');
      workOrder = await getSingleWorkOrderUseCase.execute(cleanId);

      if (workOrder != null) {
        // Pre-populate fields
        // Find product ID from product name or fallback to first product
        if (workOrder!.productName != null) {
          final matched = products.firstWhere(
            (p) =>
                p.name.toLowerCase() == workOrder!.productName!.toLowerCase(),
            orElse: () => products.isNotEmpty
                ? products.first
                : Product(id: '', name: '', model: '', serialNumber: ''),
          );
          if (matched.id.isNotEmpty) {
            selectedProductId = matched.id;
            selectedSerialNumber = matched.serialNumber;
          }
        }

        building = workOrder!.building;
        city = workOrder!.city;
        country = workOrder!.country ?? 'Vietnam';

        // Address
        address = workOrder!.addressLine1 ?? workOrder!.addressString;
        if (address == workOrder!.addressString && address != null) {
          final parts = address!.split(',');
          if (parts.isNotEmpty) {
            address = parts[0].trim();
          }
        }

        if (workOrder!.appointment != null) {
          appointmentDate = DateFormat(
            "HH:mm, dd/MM/yyyy",
          ).format(workOrder!.appointment!.toLocal());
        }
      }
    } catch (e) {
      errorMessage = e.toString();
      debugPrint("Error loading Edit Work Order data: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadLocationData() async {
    if (wards.isNotEmpty) return;
    try {
      final String response = await rootBundle.loadString(
        'assets/data/vietnam_location.json',
      );
      final List<dynamic> data = json.decode(response);

      wards.clear();
      for (var item in data) {
        final provinceName = item['name'] as String;
        final citiesList = (item['cities'] as List)
            .map((e) => e.toString())
            .toList();

        if (provinceName.contains('Hồ Chí Minh') ||
            provinceName.contains('Hà Nội')) {
          wards.addAll(citiesList);
        }
      }
    } catch (e) {
      debugPrint("Lỗi tải file địa giới hành chính: $e");
    }
  }

  void updateCity(String newCity) {
    city = newCity;
    notifyListeners();
  }

  void selectDevice(String id, String sn) {
    selectedProductId = id;
    selectedSerialNumber = sn;
    notifyListeners();
  }

  String getProductStatus(Product product) {
    if (product.warrantyUntil == null) return 'No Warranty';
    if (product.warrantyUntil!.isBefore(DateTime.now())) return 'Expired';
    if (product.warrantyUntil!.isBefore(
      DateTime.now().add(const Duration(days: 30)),
    )) {
      return 'Expiring';
    }
    return 'Active';
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

  Future<bool> saveChanges(BuildContext context) async {
    isSaving = true;
    errorMessage = null;
    notifyListeners();

    try {
      // 1. Parse Appointment
      String? formattedAppointment;
      if (appointmentDate != null && appointmentDate!.isNotEmpty) {
        try {
          final inputFormat = DateFormat("HH:mm, dd/MM/yyyy");
          final dateTime = inputFormat.parse(appointmentDate!);
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
          formattedAppointment = appointmentDate;
        }
      }

      final request = EditWorkOrderRequest(
        address: address,
        appointment: formattedAppointment,
        building: building,
        productId: selectedProductId,
        ward: city, // Ward is stored in city
      );

      await editWorkOrderUseCase.execute(workOrderNumber, request);
      isSaving = false;
      notifyListeners();
      return true;
    } on BusinessException catch (e) {
      errorMessage = e.message;
      isSaving = false;
      notifyListeners();
      return false;
    } catch (e) {
      errorMessage = e.toString();
      isSaving = false;
      notifyListeners();
      return false;
    }
  }
}
