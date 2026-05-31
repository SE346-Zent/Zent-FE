import 'package:zent_fe/presentation/common/core/safe_change_notifier.dart';
import 'package:flutter/foundation.dart';
import 'package:zent_fe/di/injection_container.dart';
import 'package:zent_fe/presentation/common/auth/auth_view_model.dart';
import 'package:zent_fe/domain/usecases/work_order/get_many_work_orders_usecase.dart';

class TechScheduleItem {
  final String time;
  final String ampm;
  final String title;
  final String address;

  TechScheduleItem({
    required this.time,
    required this.ampm,
    required this.title,
    required this.address,
  });
}

class TechnicianHomeViewModel extends ChangeNotifier with SafeChangeNotifier {
  final GetManyWorkOrdersUseCase? getManyWorkOrdersUseCase;

  TechnicianHomeViewModel({this.getManyWorkOrdersUseCase});

  String get userName => sl<AuthViewModel>().currentUser?.name ?? 'Technician';

  final int _jobsDone = 10;
  int get jobsDone => _jobsDone;

  final double _averageRating = 4.5;
  double get averageRating => _averageRating;

  final List<TechScheduleItem> _todaySchedule = [
    TechScheduleItem(
      time: "14:00",
      ampm: "PM",
      title: "Laptop Repair",
      address: "123 Hoa Binh Street, Ward 5",
    ),
    TechScheduleItem(
      time: "09:30",
      ampm: "AM",
      title: "Network Setup",
      address: "456 Le Loi Avenue, District 1",
    ),
    TechScheduleItem(
      time: "16:00",
      ampm: "PM",
      title: "Laptop Repair",
      address: "123 Hoa Binh Street, Ward 5",
    ),
  ];
  List<TechScheduleItem> get todaySchedule => _todaySchedule;

  void refreshData() {
    // In a real app, this would fetch from a repository.
    notifyListeners();
  }
}
