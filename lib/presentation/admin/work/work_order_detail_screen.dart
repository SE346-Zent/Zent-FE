import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../routing/route_names.dart';

import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/presentation/common/core/themes/boxshadow.dart';
import 'package:zent_fe/di/injection_container.dart' as di;

import 'viewmodels/assign_work_order_viewmodel.dart';
import 'viewmodels/change_appointment_viewmodel.dart';

class AssignWorkOrderScreen extends StatelessWidget {
  final String workOrderId;

  const AssignWorkOrderScreen({super.key, required this.workOrderId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => di.sl<AssignWorkOrderViewModel>()..initData(workOrderId),
      child: _WorkOrderDetailScreenContent(),
    );
  }
}

class _WorkOrderDetailScreenContent extends StatelessWidget {
  _WorkOrderDetailScreenContent();

  final GlobalKey _filterKey = GlobalKey();

  void _showSortingDialog(BuildContext context) {
    final RenderBox? renderBox =
        _filterKey.currentContext?.findRenderObject() as RenderBox?;
    final position = renderBox?.localToGlobal(Offset.zero);

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
              top: (position?.dy ?? 250.0) - 20,
              right: 16.0,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: 220,
                  padding: const EdgeInsets.all(AppDimens.spaceSm),
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
                      const SizedBox(height: AppDimens.spaceXs),
                      _buildSortRow('Rating'),
                      const SizedBox(height: AppDimens.spaceXs),
                      _buildSortRow('Workload'),
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

  void _showChangeAppointmentDialog(
    BuildContext context,
    String workOrderId,
    AssignWorkOrderViewModel mainViewModel,
  ) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(primary: AppColors.primary500),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate == null) return;
    if (!context.mounted) return;
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime == null) return;
    final newAppointment = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );
    if (!context.mounted) return;
    final changeApptVM = di.sl<ChangeAppointmentViewModel>();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Changing appointment...')));
    final success = await changeApptVM.submitNewAppointment(
      workOrderId,
      newAppointment,
    );
    if (!context.mounted) return;
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Appointment changed successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      mainViewModel.initData(workOrderId);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${changeApptVM.errorMessage}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AssignWorkOrderViewModel>();

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
                'Assign',
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
                        null,
                      ),
                    ),
                    const SizedBox(width: AppDimens.spaceMd),
                    Expanded(
                      child: _buildInfoCard(
                        Icons.calendar_today_outlined,
                        viewModel.time,
                        () => _showChangeAppointmentDialog(
                          context,
                          viewModel.orderId.replaceAll('#', ''),
                          viewModel,
                        ),
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
                    key: _filterKey,
                    onTap: () => _showSortingDialog(context),
                    child: const Icon(Icons.filter_list, color: Colors.black),
                  ),
                ],
              ),
              const SizedBox(height: AppDimens.spaceXs),
              Text(
                'Assign the best-fit specialist based on proximity and expertise',
                style: TextStyles.bodyMedium.copyWith(
                  color: AppColors.secondary500,
                ),
              ),

              const SizedBox(height: AppDimens.spaceLg),
              if (viewModel.isLoadingTechs)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(AppDimens.spaceLg),
                    child: CircularProgressIndicator(),
                  ),
                )
              else
                ...viewModel.technicians.map(
                  (t) => _buildTechnicianCard(context, viewModel, t),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(IconData icon, String text, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.spaceSm,
          vertical: AppDimens.spaceMd,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppDimens.boraMd),
          boxShadow: [BoxShadowStyles.raised],
          border: onTap != null
              ? Border.all(color: AppColors.secondary100)
              : null,
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
              child: Icon(icon, color: AppColors.secondary400, size: 22),
            ),
            const SizedBox(width: 8.0),
            Expanded(
              child: Text(
                text,
                style: TextStyles.label.copyWith(color: Colors.black),
              ),
            ),
            if (onTap != null)
              const Icon(Icons.edit, size: 16, color: AppColors.primary500),
          ],
        ),
      ),
    );
  }

  Widget _buildTechnicianCard(
    BuildContext context,
    AssignWorkOrderViewModel viewModel,
    Map<String, dynamic> data,
  ) {
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
                            text: '${data['averageRating'] ?? data['rating'] ?? "5.0"}',
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
                      int workloadVal = 0;
                      if (data['workload'] != null) {
                        workloadVal = data['workload'] is int ? data['workload'] : int.tryParse(data['workload'].toString()) ?? 0;
                      }
                      final isActive = index < workloadVal;
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
                        pathParameters: {'techId': data['id'] ?? 'TECH-9999'},
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
                    onPressed: viewModel.isAssigning
                        ? null
                        : () async {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Assigning technician...'),
                              ),
                            );

                            final success = await viewModel.submitAssign(
                              data['id'],
                            );

                            if (!context.mounted) return;

                            if (success) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Technician assigned successfully!',
                                  ),
                                  backgroundColor: Colors.green,
                                ),
                              );
                              final cleanId = viewModel.orderId.replaceAll(
                                '#',
                                '',
                              );
                              context.pushReplacementNamed(
                                RouteNames.adminAssignedWorkOrderDetails,
                                pathParameters: {'workOrderId': cleanId},
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Error: ${viewModel.errorMessage}',
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
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
                    child: viewModel.isAssigning
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            'Assign',
                            style: TextStyles.middle.copyWith(
                              color: Colors.white,
                            ),
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
