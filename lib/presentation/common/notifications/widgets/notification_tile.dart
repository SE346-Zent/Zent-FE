import 'package:flutter/material.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/presentation/common/core/themes/boxshadow.dart';
import '../../../../domain/entities/notification_item.dart';

class NotificationTile extends StatelessWidget {
  final NotificationItem notification;
  final VoidCallback onExpanded;

  const NotificationTile({
    super.key,
    required this.notification,
    required this.onExpanded,
  });

  String _formatDate(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else {
      return '${diff.inDays}d ago';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimens.spaceMd),
      decoration: BoxDecoration(
        color: notification.isRead ? Colors.white : AppColors.surface100,
        borderRadius: BorderRadius.circular(AppDimens.boraMd),
        border: Border.all(
          color: notification.isRead
              ? AppColors.secondary200
              : AppColors.tertiary300,
          width: 1.0,
        ),
        boxShadow: [BoxShadowStyles.raised],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          onExpansionChanged: (expanded) {
            if (expanded && !notification.isRead) {
              onExpanded();
            }
          },
          tilePadding: const EdgeInsets.symmetric(
            horizontal: AppDimens.spaceMd,
            vertical: AppDimens.spaceSm,
          ),
          leading: CircleAvatar(
            radius: 20,
            backgroundColor: notification.isRead
                ? AppColors.secondary100
                : AppColors.tertiary100,
            child: Icon(
              notification.isRead
                  ? Icons.notifications_none
                  : Icons.notifications_active,
              color: notification.isRead
                  ? AppColors.secondary500
                  : AppColors.tertiary500,
              size: 20,
            ),
          ),
          title: Text(
            notification.title,
            style: TextStyles.title.copyWith(
              color: notification.isRead
                  ? AppColors.secondary700
                  : Colors.black,
              fontWeight: notification.isRead
                  ? FontWeight.normal
                  : FontWeight.bold,
            ),
          ),
          subtitle: Text(
            _formatDate(notification.createdAt.toLocal()),
            style: TextStyles.label.copyWith(color: AppColors.secondary400),
          ),
          children: [
            const Divider(height: 1, color: AppColors.secondary100),
            Padding(
              padding: const EdgeInsets.all(AppDimens.spaceLg),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  notification.body,
                  style: TextStyles.bodyLarge.copyWith(
                    color: AppColors.secondary700,
                    height: 1.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
