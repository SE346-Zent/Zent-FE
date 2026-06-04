import 'package:zent_fe/presentation/common/core/safe_change_notifier.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zent_fe/di/injection_container.dart';
import 'package:zent_fe/domain/repositories/work_order_repository.dart';

class ViewScheduleViewModel extends ChangeNotifier with SafeChangeNotifier {
  String _techId = '';
  String get techId => _techId;

  DateTime _selectedDate = DateTime.now();
  DateTime get selectedDate => _selectedDate;

  int _selectedDateIndex = 0;
  int get selectedDateIndex => _selectedDateIndex;

  bool isLoading = false;
  String? errorMessage;

  Map<String, dynamic> technician = {
    'name': 'Unknown Technician',
    'email': '',
    'rating': 5.0,
    'avatar': null,
  };

  List<Map<String, dynamic>> scheduleDays = [];
  List<Map<String, dynamic>> workOrders = [];

  final WorkOrderRepository _repo = sl<WorkOrderRepository>();

  Future<void> initData(String id) async {
    _techId = id;
    _generateWeekDays(_selectedDate);
    await _fetchTechnicianInfo();
    await fetchWorkOrdersForSelectedDate();
  }

  void _generateWeekDays(DateTime date) {
    scheduleDays.clear();
    int weekday = date.weekday;
    DateTime monday = date.subtract(Duration(days: weekday - 1));

    for (int i = 0; i < 6; i++) {
      DateTime day = monday.add(Duration(days: i));
      scheduleDays.add({
        'dateObj': day,
        'day': DateFormat('EEE').format(day),
        'date': DateFormat('dd').format(day),
      });

      if (day.year == date.year &&
          day.month == date.month &&
          day.day == date.day) {
        _selectedDateIndex = i;
      }
    }

    if (_selectedDateIndex >= 6) {
      _selectedDateIndex = 0;
      _selectedDate = scheduleDays[0]['dateObj'];
    }
    notifyListeners();
  }

  Future<void> pickDate(DateTime newDate) async {
    _selectedDate = newDate;
    _generateWeekDays(newDate);
    await fetchWorkOrdersForSelectedDate();
  }

  Future<void> selectDate(int index) async {
    if (_selectedDateIndex != index) {
      _selectedDateIndex = index;
      _selectedDate = scheduleDays[index]['dateObj'];
      notifyListeners();
      await fetchWorkOrdersForSelectedDate();
    }
  }

  Future<void> _fetchTechnicianInfo() async {
    try {
      final techs = await _repo.getTechnicians();
      final tech = techs.firstWhere(
        (t) => t['id']?.toString() == _techId,
        orElse: () => <String, dynamic>{},
      );
      if (tech.isNotEmpty) {
        technician = {
          ...tech,
          'name': tech['fullName'] ?? tech['name'] ?? 'Unknown Technician',
          'email': tech['email'] ?? '',
          'avatar': tech['avatar'] ?? tech['profilePicture'],
        };
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error fetching technician info: $e');
    }
  }

  Future<void> fetchWorkOrdersForSelectedDate() async {
    isLoading = true;
    errorMessage = null;
    workOrders.clear();
    notifyListeners();

    try {
      final dateStr = DateFormat('yyyy-MM-dd').format(_selectedDate);
      final fetchedOrders = await _repo.getWorkOrders(
        technicianId: _techId,
        date: dateStr,
      );

      workOrders = fetchedOrders.map((wo) {
        return {
          'id': wo.workOrderNum,
          'deviceName': wo.productName ?? 'Unknown Device',
          'customer': wo.customerName.isNotEmpty
              ? wo.customerName
              : (wo.firstName ?? 'Unknown'),
          'location': wo.addressString,
          'time': wo.appointment != null
              ? DateFormat('hh:mm a, MMM dd, yyyy').format(wo.appointment!)
              : 'No appointment',
        };
      }).toList();
    } catch (e) {
      errorMessage = 'Failed to load schedule';
      debugPrint('Error fetching work orders for date: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
