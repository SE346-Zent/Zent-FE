import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../routing/route_names.dart';

import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/presentation/common/core/themes/boxshadow.dart';
import 'package:zent_fe/di/injection_container.dart' as di;

import 'viewmodels/work_order_detail_viewmodel.dart';

class WorkOrderDetailScreen extends StatelessWidget {
  final String workOrderId;

  const WorkOrderDetailScreen({super.key, required this.workOrderId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => di.sl<WorkOrderDetailViewModel>()..initData(workOrderId),
      child: const _WorkOrderDetailScreenContent(),
    );
  }
}

class _WorkOrderDetailScreenContent extends StatelessWidget {
  const _WorkOrderDetailScreenContent();

  void _showSortingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (ctx) {
        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onTap: () => Navigator.pop(ctx),
                behavior: HitTestBehavior.opaque,
                child: const SizedBox.expand(),
              ),
            ),
            Positioned(
              top: 250.0,
              right: 16.0,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: 220,
                  padding: const EdgeInsets.all(AppDimens.spaceMd),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppDimens.boraMd),
                    boxShadow: [BoxShadowStyles.overlay],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sorting',
                        style: TextStyles.middle.copyWith(
                          color: AppColors.primary500,
                        ),
                      ),
                      const SizedBox(height: AppDimens.spaceSm),
                      const Divider(
                        color: AppColors.secondary50,
                        height: 1.0,
                        thickness: 1.0,
                      ),
                      const SizedBox(height: AppDimens.spaceMd),
                      _buildSortRow('Rating'),
                      const SizedBox(height: AppDimens.spaceMd),
                      _buildSortRow('Workload'),
                      const SizedBox(height: AppDimens.spaceLg),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(ctx),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.tertiary500,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppDimens.boraSm,
                            ),
                            side: BorderSide.none,
                          ),
                        ),
                        child: Text(
                          'Reset',
                          style: TextStyles.bodyLarge.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSortRow(String label) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyles.bodyLarge.copyWith(color: AppColors.secondary500),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppDimens.boraSm),
            border: Border.all(color: AppColors.secondary200),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'None',
                style: TextStyles.bodyMedium.copyWith(
                  color: AppColors.secondary500,
                ),
              ),
              const SizedBox(width: 4.0),
              const Icon(
                Icons.keyboard_arrow_down,
                size: 16,
                color: AppColors.secondary500,
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<WorkOrderDetailViewModel>();

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
              title: Text(
                'Work Order Detail',
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimens.spaceLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  final cleanId = viewModel.orderId.replaceAll('#', '');
                  context.pushNamed(
                    RouteNames.adminAssignedWorkOrderDetails,
                    pathParameters: {'workOrderId': cleanId},
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppDimens.boraMd),
                    boxShadow: [BoxShadowStyles.raised],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: IntrinsicHeight(
                    child: Row(
                      children: [
                        Container(width: 6.0, color: AppColors.tertiary500),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(AppDimens.spaceMd),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  viewModel.orderId,
                                  style: TextStyles.middle.copyWith(
                                    color: AppColors.secondary500,
                                  ),
                                ),
                                const SizedBox(height: AppDimens.spaceXs),
                                Text(
                                  viewModel.deviceName,
                                  style: TextStyles.headline.copyWith(
                                    color: AppColors.primary500,
                                  ),
                                ),
                                const SizedBox(height: AppDimens.spaceXs),
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 12,
                                      backgroundColor: AppColors.secondary200,
                                      child: const Icon(
                                        Icons.person,
                                        size: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 8.0),
                                    Text(
                                      viewModel.customerName,
                                      style: TextStyles.label.copyWith(
                                        color: AppColors.secondary400,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppDimens.spaceMd),
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: _buildInfoCard(
                        Icons.location_on_outlined,
                        viewModel.location,
                      ),
                    ),
                    const SizedBox(width: AppDimens.spaceMd),
                    Expanded(
                      child: _buildInfoCard(
                        Icons.calendar_today_outlined,
                        viewModel.time,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppDimens.spaceXl),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Select Technician',
                    style: TextStyles.headline.copyWith(color: Colors.black),
                  ),
                  GestureDetector(
                    onTap: () => _showSortingDialog(context),
                    child: const Icon(Icons.filter_list, color: Colors.black),
                  ),
                ],
              ),
              const SizedBox(height: AppDimens.spaceXs),
              Text(
                'Assign the best-fit specialist based on proximity and experties',
                style: TextStyles.bodyMedium.copyWith(
                  color: AppColors.secondary500,
                ),
              ),

              const SizedBox(height: AppDimens.spaceLg),
              ...viewModel.technicians.map(
                (t) => _buildTechnicianCard(context, t),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spaceMd,
        vertical: AppDimens.spaceMd,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimens.boraMd),
        boxShadow: [BoxShadowStyles.raised],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6.0),
            decoration: BoxDecoration(
              color: AppColors.surface600,
              borderRadius: BorderRadius.circular(AppDimens.boraSm),
            ),
            child: Icon(icon, color: AppColors.secondary400, size: 18),
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(
              text,
              style: TextStyles.label.copyWith(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTechnicianCard(BuildContext context, Map<String, dynamic> data) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimens.spaceMd),
      padding: const EdgeInsets.all(AppDimens.spaceMd),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimens.boraMd),
        boxShadow: [BoxShadowStyles.raised],
        border: Border.all(color: AppColors.secondary300, width: 1.0),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.secondary200,
                child: const Icon(Icons.person, size: 24, color: Colors.white),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data['name'],
                      style: TextStyles.title.copyWith(color: Colors.black),
                    ),
                    const SizedBox(height: 4.0),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '${data['rating']}',
                            style: TextStyles.bodyLarge.copyWith(
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: '/5.0',
                            style: TextStyles.bodyMedium.copyWith(
                              color: AppColors.secondary300,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'WORKLOAD',
                    style: TextStyles.label.copyWith(color: Colors.black),
                  ),
                  const SizedBox(height: 4.0),
                  Row(
                    children: List.generate(4, (index) {
                      final isActive = index < (data['workload'] as int);
                      return Container(
                        margin: const EdgeInsets.only(left: 2.0),
                        width: 5,
                        height: 15,
                        decoration: BoxDecoration(
                          color: isActive
                              ? AppColors.tertiary500
                              : AppColors.secondary100,
                          borderRadius: BorderRadius.circular(2.0),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppDimens.spaceLg),
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppDimens.boraSm),
                    boxShadow: [BoxShadowStyles.glowing],
                  ),
                  child: OutlinedButton(
                    onPressed: () {
                      context.pushNamed(
                        'adminViewSchedule',
                        pathParameters: {'techId': 'TECH-9999'},
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14.0),
                      side: const BorderSide(
                        color: AppColors.tertiary500,
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppDimens.boraSm),
                      ),
                      elevation: 0,
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'View Sched',
                        style: TextStyles.middle.copyWith(
                          color: AppColors.tertiary500,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppDimens.spaceMd),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppDimens.boraSm),
                    boxShadow: [BoxShadowStyles.glowing],
                  ),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.tertiary500,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14.0),
                      side: const BorderSide(
                        color: AppColors.tertiary500,
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppDimens.boraSm),
                      ),
                    ),
                    child: Text(
                      'Assign',
                      style: TextStyles.middle.copyWith(color: Colors.white),
                    ),
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
