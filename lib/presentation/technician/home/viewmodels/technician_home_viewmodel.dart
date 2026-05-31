import 'package:zent_fe/presentation/common/core/safe_change_notifier.dart';
import 'package:flutter/foundation.dart';
import 'package:zent_fe/di/injection_container.dart';
import 'package:zent_fe/presentation/common/auth/auth_view_model.dart';
import 'package:zent_fe/domain/usecases/work_order/get_many_work_orders_usecase.dart';
import 'package:zent_fe/domain/usecases/auth/get_current_user_usecase.dart';

class TechScheduleItem {
  final String id;
  final String time;
  final String ampm;
  final String title;
  final String address;

  TechScheduleItem({
    required this.id,
    required this.time,
    required this.ampm,
    required this.title,
    required this.address,
  });
}

class TechnicianHomeViewModel extends ChangeNotifier with SafeChangeNotifier {
  final GetManyWorkOrdersUseCase? getManyWorkOrdersUseCase;
  final GetCurrentUserUseCase? getCurrentUserUseCase;

  TechnicianHomeViewModel({
    this.getManyWorkOrdersUseCase,
    this.getCurrentUserUseCase,
  });

  String get userName => sl<AuthViewModel>().currentUser?.name ?? 'Technician';

  final int _jobsDone = 10;
  int get jobsDone => _jobsDone;

  final double _averageRating = 4.5;
  double get averageRating => _averageRating;

  List<TechScheduleItem> _todaySchedule = [];
  List<TechScheduleItem> get todaySchedule => _todaySchedule;

  bool isLoading = false;

  Future<void> fetchTodaySchedule() async {
    isLoading = true;
    notifyListeners();

    try {
      final user = await getCurrentUserUseCase?.execute();
      if (user != null && getManyWorkOrdersUseCase != null) {
        final results = await getManyWorkOrdersUseCase!.execute(
          technicianId: user.id,
          limit: 100,
        );

        final now = DateTime.now();
        // 1. Filter only today's work orders
        final todayOrders = results.where((order) {
          final timeSource = order.appointment ?? order.createdAt;
          return timeSource.year == now.year &&
              timeSource.month == now.month &&
              timeSource.day == now.day;
        }).toList();

        // 2. Sort from earliest to latest (sớm đến muộn)
        todayOrders.sort((a, b) {
          final timeA = a.appointment ?? a.createdAt;
          final timeB = b.appointment ?? b.createdAt;
          return timeA.compareTo(timeB);
        });

        final List<TechScheduleItem> items = [];
        for (final order in todayOrders) {
          final timeSource = order.appointment ?? order.createdAt;
          final hour = timeSource.hour;
          final minute = timeSource.minute.toString().padLeft(2, '0');
          final isPm = hour >= 12;
          final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
          final timeStr = "$displayHour:$minute";
          final ampmStr = isPm ? "PM" : "AM";

          final woNum = order.workOrderNum.isNotEmpty
              ? order.workOrderNum
              : order.id.substring(0, 8);
          final titleStr = "$woNum | ${order.title}";

          items.add(
            TechScheduleItem(
              id: order.id,
              time: timeStr,
              ampm: ampmStr,
              title: titleStr,
              address: order.address,
            ),
          );
        }

        _todaySchedule = items;
      }
    } catch (e) {
      debugPrint("Error fetching technician schedule: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void refreshData() {
    fetchTodaySchedule();
  }
}
