import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:zent_fe/di/injection_container.dart'; 
import 'view_models/personal_info_viewmodel.dart';
import 'widgets/personal_info_view.dart';

class PersonalInfoScreen extends StatelessWidget {
  const PersonalInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => sl<TechPersonalInfoViewModel>(), 
      child: const PersonalInfoView(),
    );
  }
}