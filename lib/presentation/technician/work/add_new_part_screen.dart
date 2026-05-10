import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/ui/account_header.dart';
import 'package:zent_fe/presentation/common/core/ui/button.dart';
import 'package:zent_fe/di/injection_container.dart' as di;

import 'viewmodels/add_new_part_viewmodel.dart';
import 'widgets/add_new_part_form.dart';

class AddNewPartScreen extends StatelessWidget {
  const AddNewPartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => di.sl<AddNewPartViewModel>(),
      child: const _AddNewPartContent(),
    );
  }
}

class _AddNewPartContent extends StatelessWidget {
  const _AddNewPartContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background500,
      body: SafeArea(
        child: Column(
          children: [
            const AccountHeader(title: "Add New Part"),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppDimens.spaceMd),
                child: Column(
                  children: [
                    const AddNewPartForm(),
                    PrimaryActionButton(
                      label: "Submit Part Form",
                      width: double.infinity,
                      onPressed: () {
                        debugPrint("action triggered: Submit Part Form");
                      },
                    ),
                    const SizedBox(height: AppDimens.spaceLg),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
