import 'package:flutter/material.dart';
import 'package:zent_fe/presentation/common/core/utils/tap_debounce.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:zent_fe/routing/route_names.dart';
import 'package:intl/intl.dart';

import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/presentation/common/core/themes/boxshadow.dart';
import 'package:zent_fe/presentation/common/core/ui/user_avatar.dart';
import 'package:zent_fe/presentation/common/core/app_assets.dart';
import 'package:zent_fe/di/injection_container.dart' as di;
import 'package:zent_fe/presentation/common/core/ui/zent_success_popup.dart';
import 'package:zent_fe/domain/entities/reject_form.dart';
import 'package:zent_fe/domain/entities/new_part_form.dart';

import 'viewmodels/admin_dashboard_viewmodel.dart';
import 'widgets/admin_dashboard_quick_actions.dart';
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

  Widget _buildSectionHeader({
    required String title,
    required VoidCallback onViewAll,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyles.middle.copyWith(
            color: AppColors.primary400,
            fontWeight: FontWeight.bold,
          ),
        ),
        ThrottledInkWell(
          onTap: onViewAll,
          child: Text(
            "View All",
            style: TextStyles.label.copyWith(color: AppColors.tertiary500),
          ),
        ),
      ],
    );
  }

  Widget _buildRejectionCard(BuildContext context, RejectForm form) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimens.spaceMd),
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spaceMd,
        vertical: AppDimens.spaceMd,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimens.boraMd),
        boxShadow: [BoxShadowStyles.raised],
        border: Border.all(color: AppColors.secondary50, width: 1.0),
      ),
      child: ThrottledGestureDetector(
        onTap: () async {
          final refresh = await context.pushNamed<bool>(
            RouteNames.adminRejectionDetail,
            pathParameters: {'id': form.id},
          );
          if (refresh == true && context.mounted) {
            ZentSuccessPopup.show(
              context,
              'Rejection request resolved successfully!',
            );
            context.read<AdminDashboardViewModel>().loadDashboardData();
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    form.workOrderNumber.startsWith('WO')
                        ? '#${form.workOrderNumber}'
                        : form.workOrderNumber.startsWith('#WO')
                        ? form.workOrderNumber
                        : '#${form.workOrderNumber}',
                    style: TextStyles.bodyLarge.copyWith(
                      color: AppColors.tertiary500,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    form.reason.isNotEmpty ? form.reason : 'No reason provided',
                    style: TextStyles.title.copyWith(
                      color: AppColors.primary500,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppDimens.spaceSm),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                UserAvatar(
                  name: form.technicianName.isNotEmpty
                      ? form.technicianName
                      : 'Technician',
                  avatarUrl: null,
                  size: 42,
                ),
                const SizedBox(width: 8.0),
                Text(
                  form.technicianName.isNotEmpty ? form.technicianName : 'N/A',
                  style: TextStyles.bodyLarge.copyWith(
                    color: AppColors.primary500,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPartRequestCard(BuildContext context, NewPartForm part) {
    final formattedDate = DateFormat('MMM dd, yyyy').format(part.createdAt);
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimens.spaceMd),
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spaceMd,
        vertical: AppDimens.spaceMd,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimens.boraMd),
        boxShadow: [BoxShadowStyles.raised],
        border: Border.all(color: AppColors.secondary50, width: 1.0),
      ),
      child: ThrottledGestureDetector(
        onTap: () async {
          final refresh = await context.pushNamed<bool>(
            RouteNames.adminDetailRequest,
            pathParameters: {'partId': part.id},
          );
          if (refresh == true && context.mounted) {
            ZentSuccessPopup.show(
              context,
              'Part request resolved successfully!',
            );
            context.read<AdminDashboardViewModel>().loadDashboardData();
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              part.partNumber.toUpperCase(),
              style: TextStyles.title.copyWith(
                color: AppColors.primary500,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                const Icon(
                  Icons.assignment_outlined,
                  size: 16,
                  color: AppColors.tertiary500,
                ),
                const SizedBox(width: 4.0),
                Text(
                  part.workOrderNumber,
                  style: TextStyles.bodyMedium.copyWith(
                    color: AppColors.tertiary500,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 16.0),
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 16,
                  color: AppColors.primary500,
                ),
                const SizedBox(width: 4.0),
                Text(
                  formattedDate,
                  style: TextStyles.bodyMedium.copyWith(
                    color: AppColors.primary500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AdminDashboardViewModel>();
    final authViewModel = context.watch<AuthViewModel>();
    final userName = authViewModel.currentUser?.name ?? 'Admin';

    return Material(
      color: AppColors.background500,
      child: Stack(
        children: [
          // Background Layer with Logo
          Center(
            child: Opacity(
              opacity: 0.1,
              child: Image.asset(
                AppAssets.blackLogo,
                width: 179,
                height: 229,
                fit: BoxFit.contain,
              ),
            ),
          ),
          SafeArea(
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
                        style: TextStyles.headline.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      const Spacer(),
                      Consumer<NotificationsViewModel>(
                        builder: (context, notificationsVM, _) {
                          final hasUnread = notificationsVM.unreadCount > 0;
                          return Stack(
                            alignment: Alignment.center,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.notifications_none,
                                  color: Colors.white,
                                ),
                                onPressed: () async {
                                  await context.pushNamed(
                                    RouteNames.adminNotifications,
                                  );
                                  if (context.mounted) {
                                    context
                                        .read<AdminDashboardViewModel>()
                                        .loadDashboardData();
                                  }
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
                                        notificationsVM.unreadCount > 99
                                            ? '99+'
                                            : '${notificationsVM.unreadCount}',
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
                      ThrottledGestureDetector(
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
                  child: RefreshIndicator(
                    color: AppColors.tertiary500,
                    onRefresh: () => viewModel.loadDashboardData(),
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
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

                          // Rejection Form Section
                          _buildSectionHeader(
                            title: 'Rejection Form',
                            onViewAll: () async {
                              await context.pushNamed(
                                RouteNames.adminRejectedWorkOrders,
                              );
                              if (context.mounted) {
                                context
                                    .read<AdminDashboardViewModel>()
                                    .loadDashboardData();
                              }
                            },
                          ),
                          const SizedBox(height: AppDimens.spaceMd),
                          if (viewModel.isLoadingData &&
                              viewModel.rejectedWorkOrders.isEmpty)
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.all(AppDimens.spaceLg),
                                child: CircularProgressIndicator(),
                              ),
                            )
                          else if (viewModel.rejectedWorkOrders.isEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: AppDimens.spaceLg,
                              ),
                              child: Center(
                                child: Text(
                                  'No pending rejections',
                                  style: TextStyles.bodyMedium.copyWith(
                                    color: AppColors.secondary400,
                                  ),
                                ),
                              ),
                            )
                          else
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: viewModel.rejectedWorkOrders.length,
                              itemBuilder: (context, index) {
                                return _buildRejectionCard(
                                  context,
                                  viewModel.rejectedWorkOrders[index],
                                );
                              },
                            ),

                          const SizedBox(height: 32.0),

                          // New Part Form Section
                          _buildSectionHeader(
                            title: 'New Part Form',
                            onViewAll: () async {
                              await context.pushNamed(
                                RouteNames.adminPartRequests,
                              );
                              if (context.mounted) {
                                context
                                    .read<AdminDashboardViewModel>()
                                    .loadDashboardData();
                              }
                            },
                          ),
                          const SizedBox(height: AppDimens.spaceMd),
                          if (viewModel.isLoadingData &&
                              viewModel.partRequests.isEmpty)
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.all(AppDimens.spaceLg),
                                child: CircularProgressIndicator(),
                              ),
                            )
                          else if (viewModel.partRequests.isEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: AppDimens.spaceLg,
                              ),
                              child: Center(
                                child: Text(
                                  'No pending part requests',
                                  style: TextStyles.bodyMedium.copyWith(
                                    color: AppColors.secondary400,
                                  ),
                                ),
                              ),
                            )
                          else
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: viewModel.partRequests.length,
                              itemBuilder: (context, index) {
                                return _buildPartRequestCard(
                                  context,
                                  viewModel.partRequests[index],
                                );
                              },
                            ),
                          const SizedBox(height: 32.0),
                        ],
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
