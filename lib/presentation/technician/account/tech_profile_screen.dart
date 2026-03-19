import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zent_fe/di/injection_container.dart';

// Widgets
import 'widgets/tech_profile_view.dart';

// ViewModel
import 'view_models/tech_profile_viewmodel.dart';

class TechProfileScreen extends StatelessWidget {
  const TechProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => sl<TechProfileViewModel>(),
      child: const TechProfileView(),
    );
  }
}
