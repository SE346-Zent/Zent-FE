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
  final String workOrderId;

  const AddNewPartScreen({super.key, required this.workOrderId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => di.sl<AddNewPartViewModel>(),
      child: _AddNewPartContent(workOrderId: workOrderId),
    );
  }
}

class _AddNewPartContent extends StatelessWidget {
  final String workOrderId;

  const _AddNewPartContent({required this.workOrderId});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AddNewPartViewModel>();

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
                    const SizedBox(height: AppDimens.spaceLg),
                    viewModel.isLoading
                        ? const CircularProgressIndicator()
                        : PrimaryActionButton(
                            label: "Submit Part Form",
                            width: double.infinity,
                            onPressed: () async {
                              final success = await viewModel.submitPartRequest(workOrderId);

                              if (success) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Add part request submitted successfully!"), 
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                  Navigator.pop(context);
                                }
                              } else {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Error: ${viewModel.errorMessage}"), 
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              }
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