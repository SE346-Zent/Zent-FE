import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/ui/account_header.dart';
import 'package:zent_fe/presentation/common/core/ui/button.dart';
import 'package:zent_fe/presentation/common/core/ui/zent_error_popup.dart';
import 'package:zent_fe/presentation/common/core/ui/zent_success_popup.dart';
import 'package:zent_fe/di/injection_container.dart' as di;

import 'viewmodels/add_new_part_viewmodel.dart';
import 'widgets/add_new_part_form.dart';

class AddNewPartScreen extends StatelessWidget {
  final String workOrderId;
  final String workOrderNumber;

  const AddNewPartScreen({
    super.key,
    required this.workOrderId,
    required this.workOrderNumber,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => di.sl<AddNewPartViewModel>(),
      child: _AddNewPartContent(
        workOrderId: workOrderId,
        workOrderNumber: workOrderNumber,
      ),
    );
  }
}

class _AddNewPartContent extends StatefulWidget {
  final String workOrderId;
  final String workOrderNumber;

  const _AddNewPartContent({
    required this.workOrderId,
    required this.workOrderNumber,
  });

  @override
  State<_AddNewPartContent> createState() => _AddNewPartContentState();
}

class _AddNewPartContentState extends State<_AddNewPartContent> {
  final TextEditingController _woNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AddNewPartViewModel>().loadCategories();
    });
  }

  @override
  void dispose() {
    _woNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final woId = widget.workOrderId;
    final woNumber = widget.workOrderNumber;

    if (_woNumberController.text.isEmpty) {
      _woNumberController.text = woNumber;
    }

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
                    Consumer<AddNewPartViewModel>(
                      builder: (context, viewModel, _) {
                        final canSubmit = !viewModel.isSubmitting;
                        return PrimaryActionButton(
                          label: viewModel.isSubmitting
                              ? "Submitting..."
                              : "Submit Part Form",
                          width: double.infinity,
                          onPressed: canSubmit
                              ? () async {
                                  final success = await viewModel.submitPart(
                                    workOrderId: woId,
                                    workOrderNumber: _woNumberController.text
                                        .trim(),
                                  );
                                  if (success && context.mounted) {
                                    ZentSuccessPopup.show(
                                      context,
                                      'New part form submitted successfully!',
                                    );
                                    Navigator.of(context).pop(true);
                                  } else if (context.mounted &&
                                      viewModel.errorMessage != null) {
                                    ZentErrorPopup.show(
                                      context,
                                      viewModel.errorMessage!,
                                    );
                                  }
                                }
                              : null,
                        );
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
