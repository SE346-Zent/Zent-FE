import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/presentation/common/core/themes/boxshadow.dart';
import 'package:zent_fe/di/injection_container.dart' as di;

import 'viewmodels/admin_reports_viewmodel.dart';
import 'widgets/time_range_tabs.dart';

class AdminReportsScreen extends StatelessWidget {
  const AdminReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => di.sl<AdminReportsViewModel>(),
      child: const _AdminReportsScreenContent(),
    );
  }
}

class _AdminReportsScreenContent extends StatefulWidget {
  const _AdminReportsScreenContent();

  @override
  State<_AdminReportsScreenContent> createState() =>
      _AdminReportsScreenContentState();
}

class _AdminReportsScreenContentState
    extends State<_AdminReportsScreenContent> {
  @override
  void initState() {
    super.initState();
    // Schedule after first frame to ensure context is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminReportsViewModel>().init();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AdminReportsViewModel>();

    return Scaffold(
      backgroundColor: AppColors.background500,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimens.spaceLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Reports & Analytics',
                style: TextStyles.display.copyWith(color: AppColors.primary500),
              ),
              const SizedBox(height: AppDimens.spaceLg),
              TimeRangeTabs(
                activeIndex: viewModel.activeTabIndex,
                onTabChanged: viewModel.changeTab,
              ),
              const SizedBox(height: AppDimens.spaceLg),
              if (viewModel.isLoading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 32.0),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (viewModel.error != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Center(
                    child: Text(
                      'Could not load analytics. Showing fallback data.',
                      style: TextStyles.bodyLarge.copyWith(
                        color: AppColors.error500,
                      ),
                    ),
                  ),
                ),
              _buildStatCard(
                title: 'TOTAL JOBS',
                value: viewModel.totalJobs,
                desc: 'Completed this week',
                trend: viewModel.totalJobsTrend,
                lineColor: AppColors.tertiary500,
              ),
              const SizedBox(height: AppDimens.spaceMd),
              // Chart Card
              _buildChartCard(viewModel),
              const SizedBox(height: AppDimens.spaceMd),
              _buildStatCard(
                title: 'TOTAL IMPORTED PARTS',
                value: viewModel.totalImported,
                desc: 'Imported this week',
                trend: viewModel.totalImportedTrend,
                lineColor: AppColors.tertiary500,
              ),
              const SizedBox(height: AppDimens.spaceMd),
              _buildStatCard(
                title: 'TOTAL RETURNED PARTS',
                value: viewModel.totalReturned,
                desc: 'Returned this week',
                trend: viewModel.totalReturnedTrend,
                lineColor: AppColors.surface700,
              ),
              const SizedBox(height: AppDimens.spaceMd),
              _buildCategoriesCard(viewModel),
              const SizedBox(height: AppDimens.spaceXl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required String desc,
    required String trend,
    required Color lineColor,
  }) {
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
            Container(width: 6.0, color: lineColor),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.spaceMd,
                  vertical: AppDimens.spaceMd,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          style: TextStyles.bodyLarge.copyWith(
                            color: AppColors.primary500,
                          ),
                        ),
                        const SizedBox(height: AppDimens.spaceSm),
                        Text(
                          value,
                          style: TextStyles.headline.copyWith(
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          desc,
                          style: TextStyles.bodyLarge.copyWith(
                            color: AppColors.secondary500,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.call_made,
                          color: AppColors.success500,
                          size: 16,
                        ),
                        const SizedBox(width: 4.0),
                        Text(
                          trend,
                          style: TextStyles.label.copyWith(
                            color: AppColors.success500,
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

  Widget _buildChartCard(AdminReportsViewModel viewModel) {
    double maxVal = 100.0;
    for (var m in viewModel.chartData) {
      if (m['current']! > maxVal) maxVal = m['current']!;
      if (m['previous']! > maxVal) maxVal = m['previous']!;
      if (m['complaint']! > maxVal) maxVal = m['complaint']!;
    }

    return Container(
      padding: const EdgeInsets.all(AppDimens.spaceLg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimens.boraMd),
        boxShadow: [BoxShadowStyles.raised],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'JOB COMPLETIONS TREND',
            style: TextStyles.title.copyWith(color: AppColors.primary500),
          ),
          const SizedBox(height: AppDimens.spaceSm),
          Wrap(
            spacing: AppDimens.spaceMd,
            runSpacing: AppDimens.spaceXs,
            children: [
              _buildLegend(color: AppColors.tertiary500, label: 'Current'),
              _buildLegend(color: AppColors.secondary100, label: 'Previous'),
              _buildLegend(color: AppColors.error500, label: 'Complaint'),
            ],
          ),
          const SizedBox(height: AppDimens.spaceXl),
          SizedBox(
            height: 180,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(viewModel.chartData.length, (index) {
                final d = viewModel.chartData[index];
                final label = viewModel.chartLabels[index];
                return Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            Container(
                              width: 32,
                              height: (d['previous']! / maxVal) * 160,
                              decoration: BoxDecoration(
                                color: AppColors.secondary100,
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                            ),
                            Container(
                              width: 32,
                              height: (d['current']! / maxVal) * 160,
                              decoration: BoxDecoration(
                                color: AppColors.tertiary500,
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                            ),
                            Container(
                              width: 32,
                              height: (d['complaint']! / maxVal) * 160,
                              decoration: BoxDecoration(
                                color: AppColors.error500,
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        label,
                        textAlign: TextAlign.center,
                        style: TextStyles.label.copyWith(
                          color: AppColors.secondary300,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend({required Color color, required String label}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        const SizedBox(width: 4.0),
        Text(
          label,
          style: TextStyles.bodyLarge.copyWith(color: AppColors.secondary500),
        ),
      ],
    );
  }

  Widget _buildCategoriesCard(AdminReportsViewModel viewModel) {
    final colors = [
      AppColors.primary500,
      AppColors.tertiary400,
      AppColors.tertiary200,
      AppColors.tertiary100,
    ];

    return Container(
      padding: const EdgeInsets.all(AppDimens.spaceLg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimens.boraMd),
        boxShadow: [BoxShadowStyles.raised],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PART CATEGORIES',
            style: TextStyles.title.copyWith(color: AppColors.primary500),
          ),
          const SizedBox(height: AppDimens.spaceLg),
          ...List.generate(viewModel.partCategories.length, (index) {
            final cat = viewModel.partCategories[index];
            final color = colors[index % colors.length];
            return Padding(
              padding: const EdgeInsets.only(bottom: AppDimens.spaceMd),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        cat['name'],
                        style: TextStyles.bodyLarge.copyWith(
                          color: AppColors.secondary500,
                        ),
                      ),
                      Text(
                        cat['label'],
                        style: TextStyles.label.copyWith(
                          color: AppColors.tertiary500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimens.spaceXs),
                  Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 6,
                        decoration: BoxDecoration(
                          color: AppColors.secondary50,
                          borderRadius: BorderRadius.circular(3.0),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: FractionallySizedBox(
                          widthFactor: cat['percentage'],
                          child: Container(
                            height: 6,
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(3.0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
