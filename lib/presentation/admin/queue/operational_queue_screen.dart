import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/presentation/common/core/themes/boxshadow.dart';
import 'package:zent_fe/routing/route_names.dart';
import 'package:go_router/go_router.dart';
import 'package:zent_fe/di/injection_container.dart' as di;

import 'viewmodels/operational_queue_viewmodel.dart';

class OperationalQueueScreen extends StatelessWidget {
  const OperationalQueueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => di.sl<OperationalQueueViewModel>(),
      child: const _OperationalQueueScreenContent(),
    );
  }
}

class _OperationalQueueScreenContent extends StatelessWidget {
  const _OperationalQueueScreenContent();

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (ctx) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          alignment: Alignment.topCenter,
          insetPadding: const EdgeInsets.only(
            top: 130.0,
            left: 16.0,
            right: 16.0,
          ),
          child: Container(
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
                  'Filtering',
                  style: TextStyles.middle.copyWith(color: Colors.black),
                ),
                const SizedBox(height: AppDimens.spaceSm),
                const Divider(color: AppColors.secondary50, height: 1),
                const SizedBox(height: AppDimens.spaceMd),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Appointment',
                      style: TextStyles.bodyLarge.copyWith(color: Colors.black),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 6.0,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(AppDimens.boraSm),
                        border: Border.all(color: AppColors.secondary200),
                      ),
                      child: Row(
                        children: [
                          Text(
                            'None',
                            style: TextStyles.bodyMedium.copyWith(
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(width: 4.0),
                          const Icon(
                            Icons.keyboard_arrow_down,
                            size: 16,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<OperationalQueueViewModel>();

    return Scaffold(
      backgroundColor: AppColors.background500,
      appBar: AppBar(
        backgroundColor: AppColors.background500,
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppDimens.spaceLg,
                AppDimens.spaceLg,
                AppDimens.spaceLg,
                AppDimens.spaceSm,
              ),
              child: Text(
                'Operational Queue',
                style: TextStyles.display.copyWith(color: AppColors.primary500),
              ),
            ),
            const SizedBox(height: AppDimens.spaceSm),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.spaceLg,
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => _showFilterDialog(context),
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      color: Colors.transparent,
                      child: const Icon(Icons.filter_list, color: Colors.black),
                    ),
                  ),
                  const SizedBox(width: AppDimens.spaceSm),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildTabItem(context, viewModel, 'All Jobs', 0),
                          _buildTabItem(context, viewModel, 'Assigned', 1),
                          _buildTabItem(context, viewModel, 'Unassigned', 2),
                          _buildTabItem(context, viewModel, 'Completed', 3),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimens.spaceLg),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(
                  AppDimens.spaceLg,
                  0,
                  AppDimens.spaceLg,
                  100,
                ),
                itemCount: viewModel.currentJobs.length,
                separatorBuilder: (ctx, idx) =>
                    const SizedBox(height: AppDimens.spaceMd),
                itemBuilder: (ctx, index) {
                  final job = viewModel.currentJobs[index];
                  return _buildJobCard(ctx, job);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem(
    BuildContext context,
    OperationalQueueViewModel viewModel,
    String title,
    int index,
  ) {
    final isSelected = viewModel.activeTabIndex == index;

    return GestureDetector(
      onTap: () => viewModel.changeTab(index),
      child: Container(
        margin: const EdgeInsets.only(right: 12.0),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.tertiary500 : Colors.white,
          borderRadius: BorderRadius.circular(20.0),
          border: isSelected ? null : Border.all(color: AppColors.secondary200),
        ),
        child: Text(
          title,
          style: TextStyles.bodyLarge.copyWith(
            color: isSelected ? Colors.white : AppColors.secondary500,
          ),
        ),
      ),
    );
  }

  Widget _buildJobCard(BuildContext context, Map<String, dynamic> job) {
    return Container(
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
                      job['id'],
                      style: TextStyles.middle.copyWith(
                        color: AppColors.secondary500,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      job['title'],
                      style: TextStyles.headline.copyWith(
                        color: AppColors.primary500,
                      ),
                    ),
                    const SizedBox(height: AppDimens.spaceSm),
                    _buildIconTextRow(Icons.person_outline, job['assignee']),
                    const SizedBox(height: 4.0),
                    _buildIconTextRow(
                      Icons.location_on_outlined,
                      job['location'],
                    ),
                    const SizedBox(height: 4.0),
                    _buildIconTextRow(
                      Icons.calendar_today_outlined,
                      job['time'],
                    ),
                    const SizedBox(height: AppDimens.spaceMd),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AppColors.warning500,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: AppDimens.spaceXs),
                            Text(
                              job['status'],
                              style: TextStyles.middle.copyWith(
                                color: AppColors.secondary500,
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            context.pushNamed(
                              RouteNames.adminWorkOrderDetails,
                              pathParameters: {
                                'workOrderId': job['id'].toString().replaceAll(
                                  '#',
                                  '',
                                ),
                              },
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14.0,
                              vertical: 6.0,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary500,
                              borderRadius: BorderRadius.circular(
                                AppDimens.boraSm,
                              ),
                              boxShadow: [BoxShadowStyles.subtle],
                            ),
                            child: Text(
                              'Assign',
                              style: TextStyles.title.copyWith(
                                color: Colors.white,
                              ),
                            ),
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
    );
  }

  Widget _buildIconTextRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.secondary400),
        const SizedBox(width: 6.0),
        Expanded(
          child: Text(
            text,
            style: TextStyles.label.copyWith(color: AppColors.secondary400),
          ),
        ),
      ],
    );
  }
}
