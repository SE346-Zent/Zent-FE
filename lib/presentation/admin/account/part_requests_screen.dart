import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Core
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/presentation/common/core/themes/boxshadow.dart';
import 'package:zent_fe/di/injection_container.dart' as di;

// Widgets
import 'widgets/app_search_bar.dart';
import 'widgets/part_request_card.dart';
import 'viewmodels/part_request_viewmodel.dart';
import 'package:zent_fe/presentation/common/core/ui/account_header.dart';

class PartRequestsScreen extends StatelessWidget {
  const PartRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => di.sl<PartRequestsViewModel>()..loadRequests(),
      child: const _PartRequestsContent(),
    );
  }
}

class _PartRequestsContent extends StatelessWidget {
  const _PartRequestsContent();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<PartRequestsViewModel>();

    return Scaffold(
      backgroundColor: AppColors.background500,
      body: SafeArea(
        child: Column(
          children: [
            const AccountHeader(title: 'Part Requests', showDivider: true),
            Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(AppDimens.spaceMd),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppSearchBar(
                          hintText: 'Search work order ID',
                          onChanged: viewModel.onSearchChanged,
                        ),
                        const SizedBox(height: AppDimens.spaceLg),
                        Row(
                          children: [
                            Expanded(
                              child: _buildSummaryBox(
                                'PENDING',
                                viewModel.pendingCount.toString(),
                                AppColors.warning500,
                              ),
                            ),
                            const SizedBox(width: AppDimens.spaceMd),
                            Expanded(
                              child: _buildSummaryBox(
                                'APPROVED',
                                viewModel.approvedCount.toString(),
                                AppColors.success500,
                              ),
                            ),
                            const SizedBox(width: AppDimens.spaceMd),
                            Expanded(
                              child: _buildSummaryBox(
                                'REJECTED',
                                viewModel.rejectedCount.toString(),
                                AppColors.error500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppDimens.spaceMd),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () => viewModel.loadRequests(),
                      color: AppColors.tertiary500,
                      child: viewModel.isLoading && viewModel.requests.isEmpty
                          ? const Center(child: CircularProgressIndicator())
                          : ListView.separated(
                              physics: const AlwaysScrollableScrollPhysics(),
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppDimens.spaceMd,
                              ),
                              itemCount: viewModel.requests.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: AppDimens.spaceMd),
                              itemBuilder: (context, index) {
                                final item = viewModel.requests[index];
                                final statusLower = item.status.toLowerCase();
                                Color statusColor = statusLower == 'pending'
                                    ? AppColors.warning500
                                    : (statusLower == 'approved'
                                          ? AppColors.success500
                                          : AppColors.error500);
                                return PartRequestCard(
                                  partId: item.id,
                                  partName: item.partName,
                                  woId: item.woId,
                                  date: item.date,
                                  status: item.status,
                                  statusColor: statusColor,
                                );
                              },
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryBox(String label, String value, Color borderColor) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppDimens.spaceMd,
        horizontal: AppDimens.spaceSm,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface100,
        borderRadius: BorderRadius.circular(AppDimens.boraMd),
        boxShadow: [BoxShadowStyles.subtle],
        border: Border.all(color: borderColor, width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyles.bodyLarge.copyWith(color: AppColors.secondary500),
          ),
          const SizedBox(height: AppDimens.spaceXs),
          Text(
            value,
            style: TextStyles.headline.copyWith(color: AppColors.tertiary500),
          ),
        ],
      ),
    );
  }
}
