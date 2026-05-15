import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:zent_fe/routing/route_names.dart';

import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/presentation/common/core/themes/boxshadow.dart';
import 'package:zent_fe/presentation/common/core/app_assets.dart';
import 'package:zent_fe/di/injection_container.dart' as di;

import 'viewmodels/admin_dashboard_viewmodel.dart';
import 'widgets/admin_dashboard_quick_actions.dart';
import 'widgets/admin_dashboard_stat_card.dart';
import 'package:zent_fe/presentation/common/notifications/viewmodels/notifications_viewmodel.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => di.sl<AdminDashboardViewModel>(),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => di.sl<NotificationsViewModel>()..fetchUnreadCount(),
          ),
        ],
        child: const _AdminDashboardScreenContent(),
      ),
    );
  }
}

class _AdminDashboardScreenContent extends StatelessWidget {
  const _AdminDashboardScreenContent();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AdminDashboardViewModel>();

    return Scaffold(
      backgroundColor: AppColors.background500,
      appBar: AppBar(
        backgroundColor: AppColors.primary500,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {},
        ),
        title: Text(
          'Zent',
          style: TextStyles.headline.copyWith(color: Colors.white),
        ),
        actions: [
          Consumer<NotificationsViewModel>(
            builder: (context, viewModel, _) {
              final hasUnread = viewModel.unreadCount > 0;
              return Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.notifications_none,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      context.pushNamed(RouteNames.adminNotifications);
                    },
                  ),
                  if (hasUnread)
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: AppColors.tertiary500,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.primary500,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          Container(
            margin: const EdgeInsets.only(right: 16.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2.0),
              boxShadow: [BoxShadowStyles.raised],
            ),
            child: const CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11'),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Good morning, ${viewModel.userName}',
                          style: TextStyles.label.copyWith(
                            color: AppColors.secondary300,
                          ),
                        ),
                        const SizedBox(height: AppDimens.spaceXs),
                        RichText(
                          text: TextSpan(
                            style: TextStyles.title.copyWith(
                              color: AppColors.primary500,
                              fontWeight: FontWeight.w600,
                            ),
                            children: [
                              const TextSpan(text: 'Welcome back to\n'),
                              TextSpan(
                                text: 'Dashboard',
                                style: TextStyles.title.copyWith(
                                  color: AppColors.tertiary500,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppDimens.spaceLg),

                        const AdminDashboardQuickActions(),
                        const SizedBox(height: 24.0),

                        AdminDashboardStatCard(
                          title: 'Active jobs',
                          value: '${viewModel.activeJobs}',
                          trendIcon: Icons.call_made,
                          trendColor: AppColors.success500,
                          trendValue: '${viewModel.activeJobsTrend.toInt()}%',
                          leftBarColor: AppColors.tertiary500,
                        ),
                        const SizedBox(height: AppDimens.spaceMd),

                        AdminDashboardStatCard(
                          title: 'Overall ratings',
                          value: '${viewModel.overallRating}',
                          suffix: '/5.0',
                          trendIcon: Icons.call_received,
                          trendColor: AppColors.error500,
                          trendValue: '${viewModel.ratingTrend.abs().toInt()}%',
                          leftBarColor: AppColors.secondary300,
                        ),
                        const SizedBox(height: AppDimens.spaceLg),
                        Expanded(
                          child: Center(
                            child: Opacity(
                              opacity: 0.5,
                              child: Image.asset(
                                AppAssets.blackLogo,
                                height: 150,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
