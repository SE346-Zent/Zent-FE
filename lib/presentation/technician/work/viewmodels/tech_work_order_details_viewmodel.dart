import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zent_fe/presentation/common/core/safe_change_notifier.dart';
import 'package:zent_fe/presentation/common/core/ui/zent_error_popup.dart';
import 'package:zent_fe/domain/entities/work_order.dart';
import 'package:zent_fe/domain/entities/enums/work_order_status.dart';
import 'package:zent_fe/domain/usecases/work_order/get_single_work_order_usecase.dart';
import 'package:zent_fe/data/repositories/work_order_repository_impl.dart';
import 'package:zent_fe/di/injection_container.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zent_fe/main.dart' show rootScaffoldMessengerKey;

class TaskChecklistItem {
  final String title;
  bool isCompleted;

  TaskChecklistItem({required this.title, this.isCompleted = false});
}

class WorkOrderArtifact {
  final String name;
  final String type;

  WorkOrderArtifact({required this.name, required this.type});
}

class TechWorkOrderDetailsViewModel extends ChangeNotifier
    with SafeChangeNotifier {
  final String workOrderId;
  final GetSingleWorkOrderUseCase getSingleWorkOrderUseCase;
  final SharedPreferences sharedPreferences;

  WorkOrder? workOrder;
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  TechWorkOrderDetailsViewModel({
    required this.workOrderId,
    required this.getSingleWorkOrderUseCase,
    required this.sharedPreferences,
  }) {
    _loadDetails();
  }

  String get jobName => workOrder?.title ?? "Laptop Repair";
  String get status {
    if (workOrder == null) return "In Progress";
    switch (workOrder!.status) {
      case WorkOrderStatus.pending:
        return "Pending";
      case WorkOrderStatus.inProg:
        return "In Progress";
      case WorkOrderStatus.complete:
        return "Complete";
      case WorkOrderStatus.rejectInReview:
        return "Reject In Review";
      case WorkOrderStatus.rejected:
        return "Rejected";
    }
  }

  String get customerName => workOrder?.customerName ?? "John Doe";
  String get customerAddress =>
      workOrder?.addressString ?? "123 Hoa Binh, Quan Tan Phu, TPHCM";

  String get displayWorkOrderNum =>
      (workOrder?.workOrderNum != null && workOrder!.workOrderNum.isNotEmpty)
      ? workOrder!.workOrderNum
      : workOrderId;

  String get symptom => workOrder?.title ?? '';
  String get description => workOrder?.description ?? '';
  String get appointmentFormatted {
    final dt = workOrder?.appointment;
    if (dt == null) return '';
    return DateFormat("HH'h'mm, dd/MM/yyyy").format(dt);
  }

  // Timer state
  final int _hours = 12;
  final int _minutes = 22;
  final int _seconds = 11;

  int get hours => _hours;
  int get minutes => _minutes;
  int get seconds => _seconds;

  // Checklist state
  final List<TaskChecklistItem> _checklist = [
    TaskChecklistItem(title: "Post-Repair Cosmetic Check", isCompleted: false),
    TaskChecklistItem(title: "AC adapter/battery charging", isCompleted: false),
    TaskChecklistItem(
      title: "Lan Port/Wifi/WWAN/Bluetooth",
      isCompleted: false,
    ),
    TaskChecklistItem(title: "LCD touch/rotate/flip test", isCompleted: false),
    TaskChecklistItem(
      title: "LCD Lid open/close degree check no flickering",
      isCompleted: false,
    ),
    TaskChecklistItem(title: "No part Replacement", isCompleted: false),
    TaskChecklistItem(
      title: "Speaker/Audio jack/Webcam/Microphone",
      isCompleted: false,
    ),
    TaskChecklistItem(
      title: "Update latest BIOS/FW/Driver",
      isCompleted: false,
    ),
    TaskChecklistItem(
      title: "Update MTM/SN/UUID/Product Name",
      isCompleted: false,
    ),
    TaskChecklistItem(
      title: "USB & I/O Ports/SD Slot/Sim Slot",
      isCompleted: false,
    ),
  ];

  List<TaskChecklistItem> get checklist => _checklist;

  int get completedTasksCount =>
      _checklist.where((item) => item.isCompleted).length;
  int get totalTasksCount => _checklist.length;

  // Artifacts state
  final List<WorkOrderArtifact> _artifacts = [
    WorkOrderArtifact(name: "Main Unit Manual", type: "PDF Document"),
  ];

  List<WorkOrderArtifact> get artifacts => _artifacts;

  Future<void> _loadChecklistFromLocal() async {
    final key = "details_checklist_${workOrderId.replaceAll('#', '')}";
    final savedList = sharedPreferences.getStringList(key);
    if (savedList != null) {
      for (int i = 0; i < _checklist.length && i < savedList.length; i++) {
        _checklist[i].isCompleted = savedList[i] == 'true';
      }
    }
  }

  Future<void> _saveChecklistToLocal() async {
    final key = "details_checklist_${workOrderId.replaceAll('#', '')}";
    final listToSave = _checklist
        .map((item) => item.isCompleted.toString())
        .toList();
    await sharedPreferences.setStringList(key, listToSave);
  }

  Future<void> _loadDetails() async {
    _isLoading = true;
    notifyListeners();
    try {
      final cleanId = workOrderId.replaceAll('#', '');
      workOrder = await getSingleWorkOrderUseCase.execute(cleanId);
      await _loadChecklistFromLocal();
    } catch (e) {
      debugPrint("Error loading work order: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void toggleTask(int index) {
    if (index >= 0 && index < _checklist.length) {
      _checklist[index].isCompleted = !_checklist[index].isCompleted;
      _saveChecklistToLocal();
      notifyListeners();
    }
  }

  Future<void> onNavigatePressed() async {
    final address = customerAddress;
    if (address.isEmpty) return;

    final url = Uri.parse(
      "https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(address)}",
    );
    try {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint("Error launching maps: $e");
    }
  }

  Future<void> onContactPressed() async {
    final phone = workOrder?.phoneNumber;
    if (phone == null || phone.isEmpty) {
      debugPrint("No phone number available for contact");
      rootScaffoldMessengerKey.currentState?.showSnackBar(
        const SnackBar(
          content: Text('No phone number available for this customer.'),
        ),
      );
      return;
    }

    final url = Uri.parse("tel:${phone.replaceAll(' ', '')}");
    try {
      await launchUrl(url);
    } catch (e) {
      debugPrint("Error launching phone dialer: $e");
      rootScaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(content: Text('Could not open phone dialer: $e')),
      );
    }
  }

  void onPausePressed() {
    debugPrint("action triggered: Pause Timer");
  }

  void onFillFormPressed(BuildContext context) {
    debugPrint("action triggered: Fill Form");
  }

  // Start Job with Geofencing
  Future<void> startJob(BuildContext context) async {
    _isLoading = true;
    notifyListeners();
    try {
      // 1. Get current GPS location
      final pos = await _getCurrentLocation();
      final lat = pos?.latitude ?? 10.7769; // Fallback to HCM
      final lng = pos?.longitude ?? 106.7009;

      // 2. Call Start Job API
      final repo = sl<WorkOrderRepositoryImpl>();
      final cleanId = workOrderId.replaceAll('#', '');
      await repo.startWorkOrder(cleanId, lat, lng);

      // 3. Refresh work order details
      await _loadDetails();
    } catch (e) {
      if (context.mounted) {
        ZentErrorPopup.show(
          context,
          'Start Job Failed: ${e.toString().replaceAll('Exception: ', '')}',
        );
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Position?> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return null;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return null;
      }

      if (permission == LocationPermission.deniedForever) return null;

      try {
        return await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            timeLimit: Duration(seconds: 5),
          ),
        );
      } catch (_) {
        return null;
      }
    } catch (_) {
      return null;
    }
  }
}
