import 'package:flutter/material.dart';
import '../../../common/core/themes/colors.dart';
import '../../../common/core/themes/dimens.dart';
import '../../../common/core/themes/text_styles.dart';

enum UserStatus { active, away, inactive }

class UserListItem extends StatelessWidget {
  final String userName;
  final String userRole;
  final String? avatarUrl;
  final UserStatus status;
  final VoidCallback onEditTap;

  const UserListItem({
    super.key,
    required this.userName,
    required this.userRole,
    this.avatarUrl,
    required this.status,
    required this.onEditTap,
  });

  String get _statusText {
    switch (status) {
      case UserStatus.active:
        return 'Active';
      case UserStatus.away:
        return 'Away';
      case UserStatus.inactive:
        return 'Inactive';
    }
  }

  Color get _statusBgColor {
    switch (status) {
      case UserStatus.active:
        return AppColors.success50;
      case UserStatus.away:
        return AppColors
            .error50; // Closest existing value without inventing new Warning colors
      case UserStatus.inactive:
        return AppColors.secondary50;
    }
  }

  Color get _statusTextColor {
    switch (status) {
      case UserStatus.active:
        return AppColors.success500;
      case UserStatus.away:
        return AppColors.error500; // Closest existing value
      case UserStatus.inactive:
        return AppColors.secondary500;
    }
  }

  Color get _statusDotColor {
    switch (status) {
      case UserStatus.active:
        return AppColors.success300;
      case UserStatus.away:
        return AppColors.error300;
      case UserStatus.inactive:
        return AppColors.secondary300;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 364.0,
      height: 62.0,
      decoration: BoxDecoration(
        color: AppColors.surface100,
        borderRadius: BorderRadius.circular(AppDimens.boraMd),
        border: Border.all(color: AppColors.secondary100, width: 1.0),
      ),
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceMd),
      child: Row(
        children: [
          // Avatar Block
          SizedBox(
            width: 49.0,
            height: 49.0,
            child: Stack(
              children: [
                Container(
                  width: 49.0,
                  height: 49.0,
                  decoration: BoxDecoration(
                    color: AppColors.surface600,
                    shape: BoxShape.circle,
                    image: avatarUrl != null
                        ? DecorationImage(
                            image: NetworkImage(avatarUrl!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  alignment: Alignment.center,
                  child: avatarUrl == null
                      ? Text(
                          userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
                          style: TextStyles.title.copyWith(
                            color: AppColors.primary500,
                          ),
                        )
                      : null,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 12.0,
                    height: 12.0,
                    decoration: BoxDecoration(
                      color: _statusDotColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.surface100,
                        width: 2.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppDimens.spaceMd),

          // Text Block
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  userName,
                  style: TextStyles.middle.copyWith(
                    color: AppColors.secondary500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  userRole,
                  style: TextStyles.bodyMedium.copyWith(
                    color: AppColors.secondary300,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // Status Badge
          Container(
            width: 72.0,
            height: 31.0,
            decoration: BoxDecoration(
              color: _statusBgColor,
              borderRadius: BorderRadius.circular(AppDimens.boraSm),
            ),
            alignment: Alignment.center,
            child: Text(
              _statusText,
              style: TextStyles.bodyMedium.copyWith(
                color: _statusTextColor,
              ),
            ),
          ),
          const SizedBox(width: AppDimens.spaceMd),

          // Trailing Edit Icon
          InkWell(
            onTap: onEditTap,
            child: const SizedBox(
              width: 17.0,
              height: 17.0,
              child: Icon(
                Icons.edit_outlined,
                color: AppColors.tertiary500,
                size: 17.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
