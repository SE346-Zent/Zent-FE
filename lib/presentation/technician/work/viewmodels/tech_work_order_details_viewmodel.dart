import 'package:flutter/material.dart';

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

class TechWorkOrderDetailsViewModel extends ChangeNotifier {
  final String workOrderId;

  TechWorkOrderDetailsViewModel({required this.workOrderId}) {
    // Initialize with mock data
    _loadDetails();
  }

  final String _jobName = "Laptop Repair";
  String get jobName => _jobName;

  final String _status = "In Progress";
  String get status => _status;

  final String _customerName = "John Doe";
  String get customerName => _customerName;

  final String _customerAddress = "123 Hoa Binh, Quan Tan Phu, TPHCM";
  String get customerAddress => _customerAddress;

  // Timer state
  final int _hours = 12;
  final int _minutes = 22;
  final int _seconds = 11;

  int get hours => _hours;
  int get minutes => _minutes;
  int get seconds => _seconds;

  // Checklist state
  final List<TaskChecklistItem> _checklist = [
    TaskChecklistItem(title: "Check valid serial number", isCompleted: true),
    TaskChecklistItem(
      title: "Use tester to check the status",
      isCompleted: true,
    ),
    TaskChecklistItem(
      title: "Use tester to check the status",
      isCompleted: false,
    ),
    TaskChecklistItem(
      title: "Use tester to check the status",
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

  void _loadDetails() {
    // In a real app, fetch data from repository using workOrderId
    notifyListeners();
  }

  void toggleTask(int index) {
    if (index >= 0 && index < _checklist.length) {
      _checklist[index].isCompleted = !_checklist[index].isCompleted;
      notifyListeners();
    }
  }

  void onNavigatePressed() {
    debugPrint("action triggered: Navigate to $_customerAddress");
  }

  void onContactPressed() {
    debugPrint("action triggered: Contact $_customerName");
  }

  void onPausePressed() {
    debugPrint("action triggered: Pause Timer");
  }

  void onFillFormPressed(BuildContext context) {
    debugPrint("action triggered: Fill Form");
  }
}
