import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:zent_fe/presentation/common/core/utils/string_extensions.dart';

import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/presentation/common/core/themes/boxshadow.dart';
import 'package:zent_fe/presentation/common/core/ui/user_avatar.dart';
import 'package:zent_fe/di/injection_container.dart' as di;

import 'viewmodels/assigned_work_order_detail_viewmodel.dart';

class AssignedWorkOrderDetailScreen extends StatelessWidget {
  final String workOrderId;

  const AssignedWorkOrderDetailScreen({super.key, required this.workOrderId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          di.sl<AssignedWorkOrderDetailViewModel>()..initData(workOrderId),
      child: const _AssignedWorkOrderDetailScreenContent(),
    );
  }
}

class _AssignedWorkOrderDetailScreenContent extends StatelessWidget {
  const _AssignedWorkOrderDetailScreenContent();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AssignedWorkOrderDetailViewModel>();

    return Scaffold(
      backgroundColor: AppColors.background500,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 1.0),
        child: Column(
          children: [
            AppBar(
              backgroundColor: AppColors.background500,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => context.pop(),
              ),
              title: Column(
                children: [
                  Text(
                    'Work Order Detail',
                    style: TextStyles.headline.copyWith(
                      color: AppColors.primary500,
                    ),
                  ),
                  Text(
                    viewModel.displayOrderId.toShortWorkOrderId,
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimens.spaceLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCurrentStatusCard(viewModel),
              const SizedBox(height: AppDimens.spaceLg),
              _buildJobSpecificationCard(viewModel),
              const SizedBox(height: AppDimens.spaceLg),
              _buildAppointmentCard(viewModel),
              const SizedBox(height: AppDimens.spaceLg),
              _buildSymptomCard(viewModel),
              const SizedBox(height: AppDimens.spaceLg),
              _buildDescriptionCard(viewModel),
              const SizedBox(height: AppDimens.spaceLg),
              _buildAssignedTechnicianCard(context, viewModel),
              if (viewModel.isRejectInReview) ...[
                const SizedBox(height: AppDimens.spaceLg),
                _buildRefusalActions(context, viewModel),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentStatusCard(AssignedWorkOrderDetailViewModel viewModel) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimens.boraMd),
        border: Border.all(color: AppColors.secondary300, width: 1.0),
        boxShadow: [BoxShadowStyles.raised],
      ),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(width: 6.0, color: AppColors.secondary700),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppDimens.spaceMd),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Status',
                      style: TextStyles.title.copyWith(color: Colors.black),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      'Tech Assigned: ${viewModel.techAssignedTime}',
                      style: TextStyles.bodyLarge.copyWith(
                        color: AppColors.secondary500,
                      ),
                    ),
                    const SizedBox(height: AppDimens.spaceXl),
                    _buildProgressBar(),
                    const SizedBox(height: AppDimens.spaceSm),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
          left: 40,
          right: 40,
          top: 18,
          child: Row(
            children: [
              Expanded(
                child: Container(height: 1.5, color: AppColors.tertiary500),
              ),
              Expanded(
                child: Container(height: 1.5, color: AppColors.secondary700),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProgressStep(
              icon: Icons.person_add_alt_1,
              label: 'Tech assigned',
              isActive: true,
            ),
            _buildProgressStep(
              icon: Icons.view_column_outlined,
              label: 'In Progress',
              isActive: false,
            ),
            _buildProgressStep(
              icon: Icons.assignment_turned_in_outlined,
              label: 'Done',
              isActive: false,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProgressStep({
    required IconData icon,
    required String label,
    required bool isActive,
  }) {
    return SizedBox(
      width: 80,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: isActive ? AppColors.tertiary500 : AppColors.surface600,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: isActive ? Colors.white : AppColors.secondary500,
              size: 20,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyles.label.copyWith(color: AppColors.secondary500),
          ),
        ],
      ),
    );
  }

  Widget _buildJobSpecificationCard(
    AssignedWorkOrderDetailViewModel viewModel,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppDimens.spaceMd),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimens.boraMd),
        border: Border.all(color: AppColors.secondary400, width: 1.0),
        boxShadow: [BoxShadowStyles.raised],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.description_outlined,
                color: AppColors.tertiary500,
              ),
              const SizedBox(width: 8.0),
              Text(
                'Job Specification',
                style: TextStyles.title.copyWith(color: Colors.black),
              ),
            ],
          ),
          const SizedBox(height: AppDimens.spaceMd),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(6.0),
                decoration: BoxDecoration(
                  color: AppColors.surface600,
                  borderRadius: BorderRadius.circular(AppDimens.boraSm),
                ),
                child: const Icon(
                  Icons.location_on_outlined,
                  color: AppColors.secondary400,
                  size: 18,
                ),
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: Text(
                  viewModel.location,
                  style: TextStyles.bodyLarge.copyWith(
                    color: AppColors.secondary500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimens.spaceMd),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(6.0),
                decoration: BoxDecoration(
                  color: AppColors.surface600,
                  borderRadius: BorderRadius.circular(AppDimens.boraSm),
                ),
                child: const Icon(
                  Icons.calendar_today_outlined,
                  color: AppColors.secondary400,
                  size: 18,
                ),
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: Text(
                  viewModel.time,
                  style: TextStyles.bodyLarge.copyWith(
                    color: AppColors.secondary500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentCard(AssignedWorkOrderDetailViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(AppDimens.spaceMd),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimens.boraMd),
        border: Border.all(color: AppColors.secondary400, width: 1.0),
        boxShadow: [BoxShadowStyles.raised],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.calendar_month_outlined,
                color: AppColors.tertiary500,
              ),
              const SizedBox(width: 8.0),
              Text(
                'Appointment',
                style: TextStyles.title.copyWith(color: Colors.black),
              ),
            ],
          ),
          const SizedBox(height: AppDimens.spaceMd),
          IntrinsicHeight(
            child: Row(
              children: [
                Container(width: 6.0, color: AppColors.tertiary500),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: AppDimens.spaceMd),
                    child: Text(
                      viewModel.appointment,
                      style: TextStyles.bodyLarge.copyWith(
                        color: AppColors.primary500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSymptomCard(AssignedWorkOrderDetailViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(AppDimens.spaceMd),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimens.boraMd),
        border: Border.all(color: AppColors.secondary400, width: 1.0),
        boxShadow: [BoxShadowStyles.raised],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.report_problem_outlined,
                color: AppColors.tertiary500,
              ),
              const SizedBox(width: 8.0),
              Text(
                'Symptom',
                style: TextStyles.title.copyWith(color: Colors.black),
              ),
            ],
          ),
          const SizedBox(height: AppDimens.spaceMd),
          IntrinsicHeight(
            child: Row(
              children: [
                Container(width: 6.0, color: AppColors.tertiary500),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: AppDimens.spaceMd),
                    child: Text(
                      viewModel.symptom,
                      style: TextStyles.bodyLarge.copyWith(
                        color: AppColors.primary500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionCard(AssignedWorkOrderDetailViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(AppDimens.spaceMd),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimens.boraMd),
        border: Border.all(color: AppColors.secondary400, width: 1.0),
        boxShadow: [BoxShadowStyles.raised],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.description_outlined,
                color: AppColors.tertiary500,
              ),
              const SizedBox(width: 8.0),
              Text(
                'Description',
                style: TextStyles.title.copyWith(color: Colors.black),
              ),
            ],
          ),
          const SizedBox(height: AppDimens.spaceMd),
          IntrinsicHeight(
            child: Row(
              children: [
                Container(width: 6.0, color: AppColors.tertiary500),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: AppDimens.spaceMd),
                    child: Text(
                      viewModel.description,
                      style: TextStyles.bodyLarge.copyWith(
                        color: AppColors.primary500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssignedTechnicianCard(
    BuildContext context,
    AssignedWorkOrderDetailViewModel viewModel,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppDimens.spaceMd),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimens.boraMd),
        border: Border.all(color: AppColors.secondary300, width: 1.0),
        boxShadow: [BoxShadowStyles.raised],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.person_outline, color: AppColors.tertiary500),
              const SizedBox(width: 8.0),
              Text(
                'Assigned Technician',
                style: TextStyles.title.copyWith(color: Colors.black),
              ),
            ],
          ),
          const SizedBox(height: AppDimens.spaceMd),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              UserAvatar(name: viewModel.technician['name'] ?? '', size: 48),
              const SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      viewModel.technician['name'],
                      style: TextStyles.title.copyWith(color: Colors.black),
                    ),
                    const SizedBox(height: 4.0),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text:
                                '${viewModel.technician['averageRating'] ?? viewModel.technician['rating'] ?? "5.0"}',
                            style: TextStyles.bodyLarge.copyWith(
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: '/5.0',
                            style: TextStyles.label.copyWith(
                              color: AppColors.secondary300,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimens.spaceLg),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              boxShadow: [BoxShadowStyles.glowing],
              borderRadius: BorderRadius.circular(AppDimens.boraSm),
            ),
            child: ElevatedButton(
              onPressed: () async {
                final cleanId = viewModel.orderId.replaceAll('#', '');
                final result = await context.pushNamed(
                  'adminReassignWorkOrder',
                  pathParameters: {'workOrderId': cleanId},
                );
                if (result == true) {
                  viewModel.initData(viewModel.orderId);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.tertiary500,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimens.boraSm),
                ),
              ),
              child: Text(
                'Reassign',
                style: TextStyles.title.copyWith(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRefusalActions(
    BuildContext context,
    AssignedWorkOrderDetailViewModel viewModel,
  ) {
    if (viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return Container(
      padding: const EdgeInsets.all(AppDimens.spaceMd),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimens.boraMd),
        border: Border.all(color: AppColors.error400, width: 1.0),
        boxShadow: [BoxShadowStyles.raised],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: AppColors.error500,
              ),
              const SizedBox(width: 8.0),
              Text(
                'Rejection Review',
                style: TextStyles.title.copyWith(color: AppColors.error500),
              ),
            ],
          ),
          const SizedBox(height: AppDimens.spaceSm),
          Text(
            'The technician requested to reject this work order. Please review and decide whether to approve or deny.',
            style: TextStyles.bodyLarge,
          ),
          const SizedBox(height: AppDimens.spaceLg),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () async {
                    final error = await viewModel.denyRefusal();
                    if (context.mounted) {
                      if (error == null) {
                        debugPrint('Refusal Denied Success');
                        context.pop();
                      } else {
                        debugPrint('Refusal Denied Error: $error');
                      }
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    side: const BorderSide(
                      color: AppColors.error500,
                      width: 1.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimens.boraSm),
                    ),
                  ),
                  child: Text(
                    'Deny Rejection',
                    style: TextStyles.title.copyWith(color: AppColors.error500),
                  ),
                ),
              ),
              const SizedBox(width: AppDimens.spaceMd),
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    final error = await viewModel.approveRefusal();
                    if (context.mounted) {
                      if (error == null) {
                        debugPrint('Refusal Approved Success');
                        context.pop();
                      } else {
                        debugPrint('Refusal Approved Error: $error');
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.success500,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimens.boraSm),
                    ),
                  ),
                  child: Text(
                    'Approve',
                    style: TextStyles.title.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
