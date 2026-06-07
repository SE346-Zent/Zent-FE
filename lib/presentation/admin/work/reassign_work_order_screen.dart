import 'package:flutter/material.dart';
import 'package:zent_fe/presentation/common/core/utils/tap_debounce.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/presentation/common/core/themes/boxshadow.dart';
import 'package:zent_fe/presentation/common/core/ui/user_avatar.dart';
import 'package:zent_fe/di/injection_container.dart' as di;

import 'viewmodels/reassign_work_order_viewmodel.dart';

class ReassignWorkOrderScreen extends StatelessWidget {
  final String workOrderId;

  const ReassignWorkOrderScreen({super.key, required this.workOrderId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => di.sl<ReassignWorkOrderViewModel>()..initData(workOrderId),
      child: const _ReassignWorkOrderScreenContent(),
    );
  }
}

class _ReassignWorkOrderScreenContent extends StatelessWidget {
  const _ReassignWorkOrderScreenContent();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ReassignWorkOrderViewModel>();

    return ThrottledGestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
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
                Text(
                  'Available Technician',
                  style: TextStyles.headline.copyWith(color: Colors.black),
                ),
                const SizedBox(height: 4.0),
                Text(
                  'Assign the best-fit specialist based on proximity and expertise',
                  style: TextStyles.bodyMedium.copyWith(
                    color: AppColors.secondary500,
                  ),
                ),
                const SizedBox(height: AppDimens.spaceMd),
                _buildSearchBar(context, viewModel),
                const SizedBox(height: AppDimens.spaceLg),

                if (viewModel.isLoading && viewModel.technicians.isEmpty)
                  const Padding(
                    padding: EdgeInsets.only(top: 40.0),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (viewModel.technicians.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: Center(
                      child: Text(
                        'No available technicians found.',
                        style: TextStyles.bodyLarge.copyWith(
                          color: AppColors.secondary500,
                        ),
                      ),
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
      ),
    );
  }

  Widget _buildSearchBar(
    BuildContext context,
    ReassignWorkOrderViewModel viewModel,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimens.boraSm),
        border: Border.all(color: AppColors.secondary300),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search users by name or ID',
          hintStyle: TextStyles.bodyLarge.copyWith(
            color: AppColors.secondary400,
          ),
          prefixIcon: const Icon(Icons.search, color: AppColors.secondary400),
          suffixIcon: Builder(
            builder: (iconContext) {
              return GestureDetector(
                onTap: () {
                  _showFilterDialog(iconContext, viewModel);
                },
                child: const Icon(Icons.filter_list, color: Colors.black),
              );
            },
          ),

          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14.0),
        ),
      ),
    );
  }

  void _showFilterDialog(
    BuildContext iconContext,
    ReassignWorkOrderViewModel viewModel,
  ) {
    final RenderBox renderBox = iconContext.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;
    final screenWidth = MediaQuery.of(iconContext).size.width;

    showDialog(
      context: iconContext,
      barrierColor: Colors.transparent,
      useSafeArea: false,
      builder: (context) {
        return Stack(
          children: [
            Positioned(
              top: offset.dy + size.height + 8.0,
              right: screenWidth - offset.dx - size.width,
              child: StatefulBuilder(
                builder: (context, setState) {
                  return Material(
                    color: Colors.white,
                    elevation: 8,
                    shadowColor: Colors.black26,
                    borderRadius: BorderRadius.circular(AppDimens.boraMd),
                    child: Container(
                      width: 240,
                      padding: const EdgeInsets.all(AppDimens.spaceMd),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(AppDimens.boraMd),
                        border: Border.all(
                          color: AppColors.secondary200,
                          width: 1,
                        ),
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
                          const Divider(
                            color: AppColors.secondary50,
                            thickness: 1.0,
                            height: 16,
                          ),
                          const SizedBox(height: AppDimens.spaceSm),
                          _buildSortRow(
                            'Workload',
                            viewModel.workloadSort,
                            ['None', 'Min first', 'Max first'],
                            (val) {
                              if (val != null) {
                                viewModel.updateWorkloadSort(val);
                                setState(() {});
                              }
                            },
                          ),
                          const SizedBox(height: AppDimens.spaceSm),
                          _buildSortRow(
                            'Name',
                            viewModel.nameSort,
                            ['None', 'A to Z', 'Z to A'],
                            (val) {
                              if (val != null) {
                                viewModel.updateNameSort(val);
                                setState(() {});
                              }
                            },
                          ),
                          const SizedBox(height: AppDimens.spaceMd),
                          ElevatedButton(
                            onPressed: () {
                              viewModel.resetSort();
                              setState(() {});
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.tertiary500,
                              minimumSize: const Size(80, 36),
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppDimens.spaceLg,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  AppDimens.boraSm,
                                ),
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
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSortRow(
    String label,
    String value,
    List<String> options,
    ValueChanged<String?> onChanged,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyles.bodyLarge.copyWith(color: AppColors.secondary500),
        ),
        PopupMenuButton<String>(
          initialValue: value,
          onSelected: onChanged,
          offset: const Offset(0, 40),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 4.0,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppDimens.boraSm),
              border: Border.all(color: AppColors.secondary200),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  value,
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
          itemBuilder: (BuildContext context) {
            return options.map((String option) {
              return PopupMenuItem<String>(
                value: option,
                child: Text(
                  option,
                  style: TextStyles.bodyMedium.copyWith(
                    color: value == option
                        ? AppColors.tertiary500
                        : AppColors.secondary500,
                    fontWeight: value == option
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              );
            }).toList();
          },
        ),
      ],
    );
  }

  Widget _buildTechnicianCard(
    BuildContext context,
    ReassignWorkOrderViewModel viewModel,
    Map<String, dynamic> data,
  ) {
    int workload = 0;
    if (data['workload'] != null) {
      workload = (num.tryParse(data['workload'].toString()) ?? 0).toInt();
    }

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UserAvatar(name: data['name'] ?? '', size: 40),
              const SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data['fullName'] ?? data['name'] ?? 'Unknown Technician',
                      style: TextStyles.title.copyWith(color: Colors.black),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4.0),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text:
                                '${data['averageRating'] ?? data['rating'] ?? "5.0"}',
                            style: TextStyles.bodyLarge.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: '/5.0',
                            style: TextStyles.label.copyWith(
                              color: AppColors.secondary500,
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
                      final isActive = index < workload;
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
          const SizedBox(height: AppDimens.spaceMd),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      context.pushNamed(
                        'adminViewSchedule',
                        pathParameters: {
                          'techId': data['id']?.toString() ?? 'TECH-9999',
                        },
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(25),
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimens.spaceSm,
                      ),
                      side: const BorderSide(
                        color: AppColors.tertiary500,
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppDimens.boraSm),
                      ),
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
                const SizedBox(width: AppDimens.spaceMd),
                Expanded(
                  child: ElevatedButton(
                    onPressed:
                        viewModel.reassigningTechId == data['id']?.toString()
                        ? null
                        : () async {
                            if (viewModel.reassigningTechId != null) return;
                            final techId = data['id']?.toString();
                            if (techId == null || techId.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Error: Invalid Technician ID'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Reassigning technician...'),
                              ),
                            );

                            final success = await viewModel.submitReassign(
                              techId,
                            );

                            if (!context.mounted) return;

                            if (success) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Technician reassigned successfully!',
                                  ),
                                  backgroundColor: Colors.green,
                                ),
                              );
                              context.pop(true);
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
                      minimumSize: const Size.fromHeight(25),
                      backgroundColor: AppColors.tertiary500,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimens.spaceSm,
                      ),
                      side: const BorderSide(
                        color: AppColors.tertiary500,
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppDimens.boraSm),
                      ),
                    ),
                    child: viewModel.reassigningTechId == data['id']?.toString()
                        ? const SizedBox(
                            width: 24,
                            height: 24,
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
