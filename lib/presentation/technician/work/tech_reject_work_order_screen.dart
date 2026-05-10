import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:zent_fe/routing/route_names.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/presentation/common/core/themes/boxshadow.dart';
import 'package:zent_fe/di/injection_container.dart' as di;

import 'viewmodels/tech_reject_work_order_viewmodel.dart';

class TechRejectWorkOrderScreen extends StatelessWidget {
  final String workOrderId;

  const TechRejectWorkOrderScreen({super.key, required this.workOrderId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          di.sl<TechRejectWorkOrderViewModel>()..initData(workOrderId),
      child: const _TechRejectWorkOrderContent(),
    );
  }
}

class _TechRejectWorkOrderContent extends StatelessWidget {
  const _TechRejectWorkOrderContent();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<TechRejectWorkOrderViewModel>();

    return GestureDetector(
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
                  'Reject Work Order',
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
                            _buildAssignmentCard(viewModel),
                            const SizedBox(height: AppDimens.spaceXl),

                            Text(
                              'Reason for Rejection',
                              style: TextStyles.title.copyWith(
                                color: AppColors.primary500,
                              ),
                            ),
                            const SizedBox(height: AppDimens.spaceMd),

                            ...viewModel.rejectReasons.map((reason) {
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
                              'Additional Explanation',
                              style: TextStyles.title.copyWith(
                                color: AppColors.primary500,
                              ),
                            ),
                            const SizedBox(height: AppDimens.spaceMd),

                            TextField(
                              controller: viewModel.notesController,
                              maxLines: 4,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                hintText:
                                    'Add any relevant details about this rejection',
                                hintStyle: TextStyles.bodyMedium.copyWith(
                                  color: AppColors.secondary300,
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
                      const Spacer(),
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

  Widget _buildAssignmentCard(TechRejectWorkOrderViewModel viewModel) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimens.boraSm),
        boxShadow: [BoxShadowStyles.raised],
      ),
      clipBehavior: Clip.hardEdge,
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(width: 4.0, color: AppColors.tertiary500),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppDimens.spaceMd),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Assignment',
                      style: TextStyles.title.copyWith(
                        color: AppColors.tertiary500,
                      ),
                    ),
                    const SizedBox(height: AppDimens.spaceSm),
                    _buildInfoRow('Work Order ID', viewModel.workOrderId),
                    const SizedBox(height: 4.0),
                    _buildInfoRow(
                      'Customer',
                      viewModel.assignmentDetails['customer']!,
                    ),
                    const SizedBox(height: 4.0),
                    _buildInfoRow(
                      'Assigner',
                      viewModel.assignmentDetails['assigner']!,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyles.bodyLarge.copyWith(color: AppColors.secondary500),
        ),
        Text(value, style: TextStyles.middle.copyWith(color: Colors.black)),
      ],
    );
  }

  Widget _buildReasonCard({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10.0),
        padding: const EdgeInsets.all(10.0),
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
                  : AppColors.secondary400,
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
    return Container(
      padding: const EdgeInsets.all(AppDimens.spaceLg),
      color: AppColors.background500,
      child: SafeArea(
        top: false,
        child: Container(
          width: double.infinity,
          height: 52,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimens.boraSm),
            boxShadow: [BoxShadowStyles.glowing],
          ),
          child: ElevatedButton(
            onPressed: () {
              context.goNamed(RouteNames.techWorkOrder);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.tertiary500,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimens.boraSm),
              ),
            ),
            child: Text(
              'Confirm Rejection',
              style: TextStyles.title.copyWith(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
