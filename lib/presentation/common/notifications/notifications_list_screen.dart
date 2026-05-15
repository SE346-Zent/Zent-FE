import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';

import 'package:provider/provider.dart';
import 'package:zent_fe/di/injection_container.dart' as di;
import 'package:zent_fe/domain/entities/notification_item.dart';

import 'viewmodels/notifications_viewmodel.dart';
import 'widgets/notification_tile.dart';

class NotificationsListScreen extends StatelessWidget {
  const NotificationsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          di.sl<NotificationsViewModel>()..fetchNotifications(refresh: true),
      child: const _NotificationsListScreenContent(),
    );
  }
}

class _NotificationsListScreenContent extends StatefulWidget {
  const _NotificationsListScreenContent();

  @override
  State<_NotificationsListScreenContent> createState() =>
      _NotificationsListScreenContentState();
}

class _NotificationsListScreenContentState
    extends State<_NotificationsListScreenContent> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final viewModel = context.read<NotificationsViewModel>();
      viewModel.fetchNotifications();
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<NotificationsViewModel>();

    return Scaffold(
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
                'Notifications',
                style: TextStyles.headline.copyWith(
                  color: AppColors.primary500,
                  fontWeight: FontWeight.bold,
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
      body: _buildBody(context, viewModel),
    );
  }

  Widget _buildBody(BuildContext context, NotificationsViewModel viewModel) {
    if (viewModel.isLoading && viewModel.notifications.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (viewModel.errorMessage != null && viewModel.notifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Error: ${viewModel.errorMessage}',
              style: TextStyles.bodyLarge,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => viewModel.fetchNotifications(refresh: true),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    final todayItems = viewModel.todayNotifications;
    final weekItems = viewModel.thisWeekNotifications;

    if (todayItems.isEmpty && weekItems.isEmpty) {
      return const Center(child: Text('No notifications'));
    }

    return RefreshIndicator(
      onRefresh: () async {
        viewModel.fetchNotifications(refresh: true);
      },
      child: ListView(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.spaceMd,
          vertical: AppDimens.spaceMd,
        ),
        children: [
          // Summary line
          Padding(
            padding: const EdgeInsets.only(
              top: AppDimens.spaceMd,
              bottom: AppDimens.spaceXs,
            ),
            child: RichText(
              text: TextSpan(
                style: TextStyles.label.copyWith(color: AppColors.secondary500),
                children: [
                  const TextSpan(text: 'You have '),
                  TextSpan(
                    text: '${todayItems.length} notifications',
                    style: TextStyles.label.copyWith(
                      color: AppColors.tertiary500,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const TextSpan(text: ' today'),
                ],
              ),
            ),
          ),

          // Today Section
          if (todayItems.isNotEmpty) ...[
            _buildSectionHeader('Today'),
            ..._buildNotificationGroup(todayItems, viewModel),
          ],

          const SizedBox(height: AppDimens.spaceMd),

          // This Week Section
          if (weekItems.isNotEmpty) ...[
            _buildSectionHeader('This Week'),
            ..._buildNotificationGroup(weekItems, viewModel),
          ],

          if (viewModel.hasMore)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Center(child: CircularProgressIndicator()),
            ),

          const SizedBox(height: 32), // Extra space at bottom
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(
        top: AppDimens.spaceSm,
        bottom: AppDimens.spaceSm,
      ),
      child: Text(
        title,
        style: TextStyles.headline.copyWith(
          color: AppColors.primary500,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  List<Widget> _buildNotificationGroup(
    List<NotificationItem> items,
    NotificationsViewModel viewModel,
  ) {
    return List.generate(items.length, (index) {
      final item = items[index];
      final isLast = index == items.length - 1;

      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppDimens.spaceSm),
            child: NotificationTile(
              notification: item,
              onTap: () {
                viewModel.markAsRead(item.notificationId);
                // Handle tap logic if any
              },
            ),
          ),
          if (!isLast)
            const Divider(
              height: 1,
              thickness: 1,
              color: AppColors.secondary100,
            ),
        ],
      );
    });
  }
}
