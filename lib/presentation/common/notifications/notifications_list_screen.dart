import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';

import 'package:provider/provider.dart';
import 'package:zent_fe/di/injection_container.dart' as di;

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
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    final viewModel = context.watch<NotificationsViewModel>();

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
    return viewModel.notifications.isEmpty
        ? const Center(child: Text('No notifications'))
        : RefreshIndicator(
            onRefresh: () async {
              viewModel.fetchNotifications(refresh: true);
            },
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(AppDimens.spaceMd),
              itemCount:
                  viewModel.notifications.length + (viewModel.hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == viewModel.notifications.length) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                final notification = viewModel.notifications[index];
                return NotificationTile(
                  notification: notification,
                  onExpanded: () {
                    context.read<NotificationsViewModel>().markAsRead(
                      notification.notificationId,
                    );
                  },
                );
              },
            ),
          );
  }
}
