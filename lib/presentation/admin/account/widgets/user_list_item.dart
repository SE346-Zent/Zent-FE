import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/presentation/admin/account/blocs/user_status_bloc.dart';
import 'package:zent_fe/presentation/admin/account/blocs/user_status_state.dart';

class UserListItem extends StatelessWidget {
  final String userName;
  final String userRole;
  final String? avatarUrl;
  final VoidCallback onEditTap;

  const UserListItem({
    super.key,
    required this.userName,
    required this.userRole,
    this.avatarUrl,
    required this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<UserStatusBloc, UserStatusState, String>(
      selector: (state) => state.getStatusFor(userName),
      builder: (context, status) {
        return Container(
          width: double.infinity,
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
                              userName.isNotEmpty
                                  ? userName[0].toUpperCase()
                                  : 'U',
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
                          color: UserStatusState.getDotColor(status),
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
                  color: UserStatusState.getBackgroundColor(status),
                  borderRadius: BorderRadius.circular(AppDimens.boraSm),
                ),
                alignment: Alignment.center,
                child: Text(
                  status,
                  style: TextStyles.bodyLarge.copyWith(
                    color: UserStatusState.getTextColor(status),
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
      },
    );
  }
}
