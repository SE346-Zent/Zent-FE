import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/di/injection_container.dart' as di;

import 'viewmodels/operational_queue_viewmodel.dart';
import 'widgets/filter_dialog.dart';
import 'widgets/operational_queue_tab_item.dart';
import 'widgets/operational_queue_job_card.dart';

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
        return const FilterDialog();
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
                          OperationalQueueTabItem(
                            title: 'All Jobs',
                            isSelected: viewModel.activeTabIndex == 0,
                            onTap: () => viewModel.changeTab(0),
                          ),
                          OperationalQueueTabItem(
                            title: 'Assigned',
                            isSelected: viewModel.activeTabIndex == 1,
                            onTap: () => viewModel.changeTab(1),
                          ),
                          OperationalQueueTabItem(
                            title: 'Unassigned',
                            isSelected: viewModel.activeTabIndex == 2,
                            onTap: () => viewModel.changeTab(2),
                          ),
                          OperationalQueueTabItem(
                            title: 'Completed',
                            isSelected: viewModel.activeTabIndex == 3,
                            onTap: () => viewModel.changeTab(3),
                          ),
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
                  return OperationalQueueJobCard(job: job);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
