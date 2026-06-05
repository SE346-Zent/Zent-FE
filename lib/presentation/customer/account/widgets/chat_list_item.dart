import 'package:flutter/material.dart';
import 'package:zent_fe/presentation/common/core/utils/tap_debounce.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/presentation/common/core/ui/user_avatar.dart';
import 'package:zent_fe/presentation/customer/account/viewmodels/chat_viewmodel.dart';

class ChatListItem extends StatelessWidget {
  final ChatPreview chat;
  final VoidCallback onTap;

  const ChatListItem({super.key, required this.chat, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ThrottledInkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.spaceMd,
          vertical: AppDimens.spaceSm,
        ),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppColors.secondary50, width: 1.0),
          ),
        ),
        child: Row(
          children: [
            // Avatar
            UserAvatar(avatarUrl: chat.avatarUrl, name: chat.name, size: 44),
            const SizedBox(width: AppDimens.spaceMd),
            // Text Block
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    chat.name,
                    style: TextStyles.title.copyWith(
                      color: AppColors.primary500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    chat.lastMessage,
                    style: TextStyles.bodyMedium.copyWith(
                      color: chat.unreadCount > 0
                          ? AppColors.tertiary500
                          : AppColors.tertiary300,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppDimens.spaceSm),
            // Trailing Block
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  chat.time,
                  style: TextStyles.label.copyWith(
                    color: chat.unreadCount > 0
                        ? AppColors.tertiary500
                        : AppColors.tertiary300,
                  ),
                ),
                const SizedBox(height: 6.0),
                if (chat.unreadCount > 0)
                  Container(
                    width: 21.0,
                    height: 21.0,
                    decoration: BoxDecoration(
                      color: AppColors.tertiary50,
                      borderRadius: BorderRadius.circular(AppDimens.boraLg),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${chat.unreadCount}',
                      style: TextStyles.label.copyWith(
                        color: AppColors.tertiary500,
                      ),
                    ),
                  )
                else
                  const SizedBox(
                    width: 21.0,
                    height: 21.0,
                  ), // Spacer maintaining layout height
              ],
            ),
          ],
        ),
      ),
    );
  }
}
