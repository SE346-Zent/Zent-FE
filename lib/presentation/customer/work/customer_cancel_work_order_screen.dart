import 'package:flutter/material.dart';
import 'package:zent_fe/presentation/common/core/utils/tap_debounce.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/presentation/common/core/themes/boxshadow.dart';
import 'package:zent_fe/di/injection_container.dart' as di;

import 'viewmodels/customer_cancel_work_order_viewmodel.dart';

class CustomerCancelWorkOrderScreen extends StatelessWidget {
  final String workOrderId;

  const CustomerCancelWorkOrderScreen({super.key, required this.workOrderId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          di.sl<CustomerCancelWorkOrderViewModel>()..initData(workOrderId),
      child: const _CustomerCancelWorkOrderContent(),
    );
  }
}

class _CustomerCancelWorkOrderContent extends StatelessWidget {
  const _CustomerCancelWorkOrderContent();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CustomerCancelWorkOrderViewModel>();

    return ThrottledGestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.background500,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight + 1.0),
          child: Column(
            children: [
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => context.pop(),
                ),
                title: Text(
                  'Cancel Work Order',
                  style: TextStyles.headline.copyWith(
                    color: AppColors.primary500,
                  ),
                ),
                centerTitle: true,
              ),
              const Divider(
                height: 1,
                thickness: 1,
                color: AppColors.secondary50,
              ),
            ],
          ),
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(AppDimens.spaceLg),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Reason for Cancellation',
                              style: TextStyles.title.copyWith(
                                color: AppColors.primary500,
                              ),
                            ),
                            const SizedBox(height: AppDimens.spaceMd),

                            ...viewModel.cancelReasons.map((reason) {
                              final isSelected =
                                  viewModel.selectedReasonId == reason['id'];
                              return _buildReasonCard(
                                title: reason['title']!,
                                isSelected: isSelected,
                                onTap: () =>
                                    viewModel.selectReason(reason['id']!),
                              );
                            }),

                            const SizedBox(height: AppDimens.spaceLg),

                            Text(
                              'Additional Comments',
                              style: TextStyles.title.copyWith(
                                color: AppColors.primary500,
                              ),
                            ),
                            const SizedBox(height: AppDimens.spaceMd),

                            TextField(
                              controller: viewModel.notesController,
                              maxLines: 5,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                hintText:
                                    'Add any relevant details about this cancellation',
                                hintStyle: TextStyles.bodyMedium.copyWith(
                                  color: AppColors.secondary400,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    AppDimens.boraSm,
                                  ),
                                  borderSide: const BorderSide(
                                    color: AppColors.secondary200,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    AppDimens.boraSm,
                                  ),
                                  borderSide: const BorderSide(
                                    color: AppColors.tertiary500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppDimens.spaceSm),
                      _buildBottomButton(context),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildReasonCard({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return ThrottledGestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10.0),
        padding: const EdgeInsets.all(AppDimens.spaceMd),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppDimens.boraSm),
          border: Border.all(
            color: isSelected ? AppColors.tertiary500 : AppColors.secondary100,
            width: 1.0,
          ),
          boxShadow: [BoxShadowStyles.raised],
        ),
        child: Row(
          children: [
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: isSelected
                  ? AppColors.tertiary500
                  : AppColors.secondary200,
              size: 20,
            ),
            const SizedBox(width: AppDimens.spaceMd),
            Text(title, style: TextStyles.middle.copyWith(color: Colors.black)),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButton(BuildContext context) {
    final viewModel = context.watch<CustomerCancelWorkOrderViewModel>();

    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppDimens.spaceLg,
        0,
        AppDimens.spaceLg,
        AppDimens.spaceLg,
      ),
      color: Colors.transparent,
      child: SafeArea(
        top: false,
        child: Container(
          width: double.infinity,
          height: 52,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimens.boraSm),
            boxShadow: [BoxShadowStyles.raised],
          ),
          child: ElevatedButton(
            onPressed: viewModel.isLoading
                ? null
                : () async {
                    FocusScope.of(context).unfocus();

                    final success = await viewModel.submitCancel();

                    if (!context.mounted) return;

                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Work order cancelled successfully'),
                          backgroundColor: Colors.green,
                        ),
                      );
                      context.pop(true);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error: ${viewModel.errorMessage}'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error500,
              disabledBackgroundColor: AppColors.error200,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimens.boraSm),
              ),
            ),
            child: viewModel.isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                : Text(
                    'Confirm Cancellation',
                    style: TextStyles.title.copyWith(color: Colors.white),
                  ),
          ),
        ),
      ),
    );
  }
}
