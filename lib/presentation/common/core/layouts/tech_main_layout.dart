import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zent_fe/presentation/technician/account/widgets/tech_bottom_nav_bar.dart';

class TechMainLayout extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const TechMainLayout({super.key, required this.navigationShell});

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      // Support re-tapping the current tab to pop to root of that tab's stack
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBody: true, // (Bật cái này lên nếu ông muốn phần thân nội dung cuộn luồn xuống dưới cái thanh Nav)
      body: navigationShell,

      bottomNavigationBar: TechBottomNavBar(
        currentIndex: navigationShell.currentIndex,
        onTap: _goBranch,
        onCenterButtonTap: () {
          // TODO: Nút cờ lê - Chỗ này thường dùng để mở Popup/BottomSheet tạo Work Order nhanh
          debugPrint('🔧 Đã bấm nút cờ lê sửa chữa!');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Sẵn sàng sửa chữa! 🔧')),
          );
        },
      ),
    );
  }
}
