import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/presentation/common/core/themes/boxshadow.dart';
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

    return GestureDetector(
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
                  'Assign the best-fit specialist based on proximity and experties',
                  style: TextStyles.bodyMedium.copyWith(
                    color: AppColors.secondary500,
                  ),
                ),
                const SizedBox(height: AppDimens.spaceMd),
                Row(
                  children: [
                    Expanded(
                      child: _buildSearchBar(), 
                    ),
                    const SizedBox(width: AppDimens.spaceMd),
                    // Icon Filter đặt bên phải
                    GestureDetector(
                      onTap: () {
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        child: const Icon(
                          Icons.filter_list, 
                          color: Colors.black,
                          size: 26,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimens.spaceLg),
                ...viewModel.technicians.map(
                  (t) => _buildTechnicianCard(context, t),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
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
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14.0),
        ),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(
                  'https://i.pravatar.cc/150?img=11',
                ),
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
            ],
          ),
        ],
      ),
    );
  }
}
