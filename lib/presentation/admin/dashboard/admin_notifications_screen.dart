import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/di/injection_container.dart' as di;

import 'viewmodels/admin_notifications_viewmodel.dart';

class AdminNotificationsScreen extends StatelessWidget {
  const AdminNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => di.sl<AdminNotificationsViewModel>(),
      child: const _AdminNotificationsScreenContent(),
    );
  }
}

class _AdminNotificationsScreenContent extends StatelessWidget {
  const _AdminNotificationsScreenContent();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AdminNotificationsViewModel>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 1.0),
        child: Column(
          children: [
            AppBar(
              backgroundColor: Colors.white,
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.spaceLg,
          vertical: AppDimens.spaceMd,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(
                    style: TextStyles.bodyMedium.copyWith(
                      color: AppColors.secondary500,
                    ),
                    children: [
                      const TextSpan(text: 'You have '),
                      TextSpan(
                        text: '${viewModel.todayCount} notifications',
                        style: const TextStyle(color: AppColors.tertiary500),
                      ),
                      const TextSpan(text: ' today'),
                    ],
                  ),
                ),
                const Icon(Icons.filter_list, color: Colors.black),
              ],
            ),
            const SizedBox(height: AppDimens.spaceLg),
            Text(
              'Today',
              style: TextStyles.title.copyWith(color: Colors.black),
            ),
            const SizedBox(height: AppDimens.spaceSm),
            ...viewModel.todayNotifications.map(
              (noti) => _buildNotificationItem(noti),
            ),
            const SizedBox(height: AppDimens.spaceLg),
            Text(
              'This Week',
              style: TextStyles.title.copyWith(color: Colors.black),
            ),
            const SizedBox(height: AppDimens.spaceSm),
            ...viewModel.thisWeekNotifications.map(
              (noti) => _buildNotificationItem(noti),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationItem(Map<String, dynamic> data) {
    final bool isUnread = data['isUnread'];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppDimens.spaceMd),
          child: Row(
            children: [
              SizedBox(
                width: 12,
                child: isUnread
                    ? Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.tertiary500,
                          shape: BoxShape.circle,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 8.0),

              CircleAvatar(
                radius: 24,
                backgroundImage: NetworkImage(data['avatar']),
                backgroundColor: AppColors.secondary200,
              ),
              const SizedBox(width: 12.0),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data['name'],
                      style: TextStyles.middle.copyWith(color: Colors.black),
                    ),
                    const SizedBox(height: AppDimens.spaceXs),
                    Text(
                      data['action'],
                      style: TextStyles.bodyLarge.copyWith(
                        color: AppColors.secondary500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1, thickness: 1, color: AppColors.secondary200),
      ],
    );
  }
}
