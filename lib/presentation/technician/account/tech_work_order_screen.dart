import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../di/injection_container.dart';
import 'view_models/tech_work_order_viewmodel.dart';
import 'widgets/tech_work_order_view.dart';

class TechWorkOrderScreen extends StatelessWidget {
  const TechWorkOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TechWorkOrderViewModel>(
      create: (_) => sl<TechWorkOrderViewModel>(),
      child: const TechWorkOrderView(),
    );
  }
}
