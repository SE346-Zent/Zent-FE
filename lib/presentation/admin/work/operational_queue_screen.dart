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

class OperationalQueueScreen extends StatefulWidget {
  final int initialTab;
  const OperationalQueueScreen({super.key, this.initialTab = 0});

  @override
  State<OperationalQueueScreen> createState() => _OperationalQueueScreenState();
}

class _OperationalQueueScreenState extends State<OperationalQueueScreen> {
  void _showFilterDialog(
    BuildContext context,
    OperationalQueueViewModel viewModel,
  ) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (ctx) {
        return FilterDialog(viewModel: viewModel);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => di.sl<OperationalQueueViewModel>()
        ..changeTab(widget.initialTab)
        ..loadWorkOrders(),
      child: Consumer<OperationalQueueViewModel>(
        builder: (context, viewModel, child) {
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
                      style: TextStyles.display.copyWith(
                        color: AppColors.primary500,
                      ),
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
                          onTap: () => _showFilterDialog(context, viewModel),
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            color: Colors.transparent,
                            child: const Icon(
                              Icons.filter_list,
                              color: Colors.black,
                            ),
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
                                  title: 'Pending',
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
                    child: viewModel.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : ListView.separated(
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
        },
      ),
    );
  }
}
