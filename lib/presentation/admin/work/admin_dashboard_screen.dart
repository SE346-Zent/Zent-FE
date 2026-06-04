import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:zent_fe/routing/route_names.dart';

import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/presentation/common/core/themes/boxshadow.dart';
import 'package:zent_fe/presentation/common/core/ui/user_avatar.dart';
import 'package:zent_fe/presentation/common/core/app_assets.dart';
import 'package:zent_fe/di/injection_container.dart' as di;

import 'viewmodels/admin_dashboard_viewmodel.dart';
import 'widgets/admin_dashboard_quick_actions.dart';
import 'widgets/admin_dashboard_stat_card.dart';
import 'package:zent_fe/presentation/common/notifications/viewmodels/notifications_viewmodel.dart';
import 'package:zent_fe/presentation/common/notifications/notification_navigator.dart';
import 'package:zent_fe/presentation/common/auth/auth_view_model.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => di.sl<AdminDashboardViewModel>(),
      child: const _AdminDashboardScreenContent(),
    );
  }
}

class _AdminDashboardScreenContent extends StatefulWidget {
  const _AdminDashboardScreenContent();

  @override
  State<_AdminDashboardScreenContent> createState() =>
      _AdminDashboardScreenContentState();
}

class _AdminDashboardScreenContentState
    extends State<_AdminDashboardScreenContent> {
  bool _pendingProcessed = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_pendingProcessed) {
      _pendingProcessed = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final role = context.read<AuthViewModel>().role;
        NotificationNavigator.processPendingNotification(context, role);
      });
    }
    // Refresh notifications unread count on entry
    context.read<NotificationsViewModel>().fetchUnreadCount();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AdminDashboardViewModel>();
    final authViewModel = context.watch<AuthViewModel>();
    final userName = authViewModel.currentUser?.name ?? 'Admin';

    return Material(
      color: AppColors.background500,
      child: SafeArea(
        child: Column(
          children: [
            // Custom Header (Mimicking AppBar)
            Container(
              height: 60,
              color: AppColors.primary500,
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.spaceSm,
              ),
              child: Row(
                children: [
                  Builder(
                    builder: (context) => IconButton(
                      icon: const Icon(Icons.menu, color: Colors.white),
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                    ),
                  ),
                  const SizedBox(width: AppDimens.spaceSm),
                  Text(
                    'Zent',
                    style: TextStyles.headline.copyWith(color: Colors.white),
                  ),
                  const Spacer(),
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
                              top: 4,
                              right: 4,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: AppColors.tertiary500,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.primary500,
                                    width: 1.5,
                                  ),
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 16,
                                  minHeight: 16,
                                ),
                                child: Center(
                                  child: Text(
                                    viewModel.unreadCount > 99
                                        ? '99+'
                                        : '${viewModel.unreadCount}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 8,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                  GestureDetector(
                    onTap: () => context.goNamed(RouteNames.adminMe),
                    child: Container(
                      margin: const EdgeInsets.only(right: 16.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2.0),
                        boxShadow: [BoxShadowStyles.raised],
                      ),
                      child: UserAvatar(
                        name: userName,
                        avatarUrl: authViewModel.currentUser?.avatarUrl,
                        size: 32,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Body Content
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: IntrinsicHeight(
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Good morning, $userName',
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
                                trendValue:
                                    '${viewModel.activeJobsTrend.toInt()}%',
                                leftBarColor: AppColors.tertiary500,
                              ),
                              const SizedBox(height: AppDimens.spaceMd),

                              AdminDashboardStatCard(
                                title: 'Overall ratings',
                                value: '${viewModel.overallRating}',
                                suffix: '/5.0',
                                trendIcon: Icons.call_received,
                                trendColor: AppColors.error500,
                                trendValue:
                                    '${viewModel.ratingTrend.abs().toInt()}%',
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
          ],
        ),
      ),
    );
  }
}
