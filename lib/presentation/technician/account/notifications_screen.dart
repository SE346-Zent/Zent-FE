import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:zent_fe/di/injection_container.dart';
import 'view_models/notifications_viewmodel.dart';
import 'widgets/notifications_view.dart';

class TechNotificationsScreen extends StatelessWidget {
  const TechNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => sl<TechNotificationsViewModel>(),
      child: const TechNotificationsView(),
    );
  }
}