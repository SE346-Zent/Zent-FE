import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:zent_fe/di/injection_container.dart'; 
import 'view_models/security_viewmodel.dart';
import 'widgets/security_view.dart';

class TechSecurityScreen extends StatelessWidget {
  const TechSecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => sl<TechSecurityViewModel>(), 
      child: const TechSecurityView(),
    );
  }
}