import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zent_fe/presentation/common/core/themes/boxshadow.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/presentation/common/core/ui/user_avatar.dart';
import 'package:zent_fe/presentation/admin/account/viewmodels/user_management_viewmodel.dart';
import 'package:zent_fe/domain/entities/enums/account_status.dart';

class UserListItem extends StatelessWidget {
  final String userId;
  final String userName;
  final String userRole;
  final String? avatarUrl;
  final String? phoneNumber;
  final VoidCallback onEditTap;
  final VoidCallback? onTap;

  const UserListItem({
    super.key,
    required this.userId,
    required this.userName,
    required this.userRole,
    this.avatarUrl,
    this.phoneNumber,
    required this.onEditTap,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Selector<UserManagementViewModel, AccountStatus>(
      selector: (_, vm) => vm.getStatusForUser(userId),
      builder: (context, status, _) {
        return GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            height: 62.0,
            decoration: BoxDecoration(
              color: AppColors.surface100,
              borderRadius: BorderRadius.circular(AppDimens.boraMd),
              border: Border.all(color: AppColors.secondary100, width: 1.0),
              boxShadow: [BoxShadowStyles.raised],
            ),
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceMd),
            child: Row(
              children: [
                // Avatar Block
                SizedBox(
                  width: 44.0,
                  height: 44.0,
                  child: Stack(
                    children: [
                      UserAvatar(
                        avatarUrl: avatarUrl,
                        name: userName,
                        size: 44,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 12.0,
                          height: 12.0,
                          decoration: BoxDecoration(
                            color: UserManagementViewModel.getDotColor(status),
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
                        style: TextStyles.bodyLarge.copyWith(
                          color: AppColors.secondary500,
                          fontWeight: FontWeight.w600,
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
                    color: UserManagementViewModel.getBackgroundColor(status),
                    borderRadius: BorderRadius.circular(AppDimens.boraSm),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    status.name[0].toUpperCase() + status.name.substring(1),
                    style: TextStyles.bodyLarge.copyWith(
                      color: UserManagementViewModel.getTextColor(status),
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
          ),
        );
      },
    );
  }
}
