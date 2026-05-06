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
      create: (_) => di.sl<PartRequestsViewModel>(),
      child: const _PartRequestsScreenContent(),
    );
  }
}

class _PartRequestsScreenContent extends StatelessWidget {
  const _PartRequestsScreenContent();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<PartRequestsViewModel>();

    return Scaffold(
      backgroundColor: AppColors.background500,
      body: SafeArea(
        child: Column(
          children: [
            const AccountHeader(
              title: 'Part Requests',
              showDivider: true,
            ),
            Expanded(
              child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimens.spaceMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppSearchBar(hintText: 'Search work order ID'),
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
              const SizedBox(height: AppDimens.spaceXl),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: viewModel.requests.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: AppDimens.spaceMd),
                itemBuilder: (context, index) {
                  final item = viewModel.requests[index];
                  Color statusColor = item.status == 'Pending'
                      ? AppColors.warning500
                      : (item.status == 'Approved'
                            ? AppColors.success500
                            : AppColors.error500);
                  return PartRequestCard(
                    partName: item.partName,
                    woId: item.woId,
                    date: item.date,
                    status: item.status,
                    statusColor: statusColor,
                  );
                },
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
