import 'package:flutter/material.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/presentation/common/core/ui/user_avatar.dart';
import '../../../../domain/entities/notification_item.dart';

class NotificationTile extends StatefulWidget {
  final NotificationItem notification;
  final VoidCallback onTap;

  const NotificationTile({
    super.key,
    required this.notification,
    required this.onTap,
  });

  @override
  State<NotificationTile> createState() => _NotificationTileState();
}

class _NotificationTileState extends State<NotificationTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: Container(
        constraints: const BoxConstraints(minHeight: 52),
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.spaceXs,
          vertical: AppDimens.spaceXs,
        ),
        child: Row(
          crossAxisAlignment: _isExpanded
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.center,
          children: [
            // Unread dot
            Padding(
              padding: EdgeInsets.only(top: _isExpanded ? 8.0 : 0),
              child: SizedBox(
                width: 14,
                child: Center(
                  child: !widget.notification.isRead
                      ? Container(
                          width: 7,
                          height: 7,
                          decoration: const BoxDecoration(
                            color: AppColors.tertiary500,
                            shape: BoxShape.circle,
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ),
            ),
            const SizedBox(width: AppDimens.spaceXs),
            // Avatar
            Padding(
              padding: EdgeInsets.only(top: _isExpanded ? 4.0 : 0),
              child: UserAvatar(
                avatarUrl:
                    widget.notification.senderAvatarName ??
                    widget.notification.data?['avatarUrl'] as String?,
                name:
                    widget.notification.senderName ??
                    widget.notification.data?['senderName'] as String? ??
                    widget.notification.title,
                size: 44,
              ),
            ),
            const SizedBox(width: AppDimens.spaceMd),
            // Content — body tap navigates, NOT expand/collapse
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: widget.onTap,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.notification.title,
                      style: TextStyles.middle.copyWith(
                        color: const Color(0xFF000000),
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: _isExpanded ? null : 1,
                      overflow: _isExpanded ? null : TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    AnimatedCrossFade(
                      firstChild: Text(
                        widget.notification.body,
                        style: TextStyles.bodyLarge.copyWith(
                          color: AppColors.secondary500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      secondChild: Text(
                        widget.notification.body,
                        style: TextStyles.bodyLarge.copyWith(
                          color: AppColors.secondary500,
                        ),
                      ),
                      crossFadeState: _isExpanded
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                      duration: const Duration(milliseconds: 300),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: AppDimens.spaceSm),
            // Expand arrow — only toggles expand/collapse
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              child: Padding(
                padding: EdgeInsets.only(top: _isExpanded ? 8.0 : 0),
                child: AnimatedRotation(
                  turns: _isExpanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 300),
                  child: const Icon(
                    Icons.keyboard_arrow_down,
                    color: AppColors.secondary400,
                    size: 20,
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
