import 'package:flutter/material.dart';
import 'package:zent_fe/presentation/common/core/utils/tap_debounce.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:zent_fe/routing/route_names.dart';

import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/presentation/common/core/themes/boxshadow.dart';
import 'package:zent_fe/di/injection_container.dart' as di;

import 'viewmodels/tech_pause_work_order_viewmodel.dart';

class TechPauseWorkOrderScreen extends StatelessWidget {
  final String workOrderId;

  const TechPauseWorkOrderScreen({super.key, required this.workOrderId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          di.sl<TechPauseWorkOrderViewModel>()..initData(workOrderId),
      child: const _TechPauseWorkOrderContent(),
    );
  }
}

class _TechPauseWorkOrderContent extends StatelessWidget {
  const _TechPauseWorkOrderContent();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<TechPauseWorkOrderViewModel>();

    return ThrottledGestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight + 1.0),
          child: Column(
            children: [
              AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => context.pop(),
                ),
                title: Column(
                  children: [
                    Text(
                      'Pause Work Order',
                      style: TextStyles.headline.copyWith(
                        color: AppColors.primary500,
                      ),
                    ),
                    Text(
                      viewModel.workOrderId,
                      style: TextStyles.label.copyWith(
                        color: AppColors.secondary500,
                      ),
                    ),
                  ],
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(AppDimens.spaceLg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Reason for Pause',
                          style: TextStyles.headline.copyWith(
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: AppDimens.spaceMd),

                        ...viewModel.pauseReasons.map((reason) {
                          final isSelected =
                              viewModel.selectedReasonId == reason['id'];
                          return _buildReasonCard(
                            context,
                            title: reason['title']!,
                            subtitle: reason['subtitle'],
                            isSelected: isSelected,
                            onTap: () => viewModel.selectReason(reason['id']!),
                          );
                        }),

                        const SizedBox(height: AppDimens.spaceLg),

                        Text(
                          'Additional Notes',
                          style: TextStyles.headline.copyWith(
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: AppDimens.spaceMd),

                        TextField(
                          controller: viewModel.notesController,
                          maxLines: 5,
                          decoration: InputDecoration(
                            hintText:
                                'Add any relevant details about this pause decision',
                            hintStyle: TextStyles.bodyLarge.copyWith(
                              color: AppColors.secondary400,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                AppDimens.boraSm,
                              ),
                              borderSide: const BorderSide(
                                color: AppColors.secondary300,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                AppDimens.boraSm,
                              ),
                              borderSide: const BorderSide(
                                color: AppColors.primary500,
                              ),
                            ),
                            contentPadding: const EdgeInsets.all(
                              AppDimens.spaceMd,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildBottomButton(context),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildReasonCard(
    BuildContext context, {
    required String title,
    String? subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return ThrottledGestureDetector(
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: isSelected
                  ? AppColors.tertiary500
                  : AppColors.secondary200,
              size: 24,
            ),
            const SizedBox(width: AppDimens.spaceMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyles.title.copyWith(color: Colors.black),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2.0),
                    Text(
                      subtitle,
                      style: TextStyles.bodyMedium.copyWith(
                        color: AppColors.secondary500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppDimens.spaceLg,
        0,
        AppDimens.spaceLg,
        AppDimens.spaceLg,
      ),
      color: Colors.white,
      child: SafeArea(
        top: false,
        child: Container(
          width: double.infinity,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimens.boraSm),
            boxShadow: [BoxShadowStyles.glowing],
          ),
          child: ElevatedButton.icon(
            onPressed: () {
              context.goNamed(RouteNames.techWorkOrder);
            },
            icon: const Icon(Icons.pause, color: Colors.white),
            label: Text(
              'Confirm Pause',
              style: TextStyles.title.copyWith(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.tertiary500,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimens.boraSm),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
