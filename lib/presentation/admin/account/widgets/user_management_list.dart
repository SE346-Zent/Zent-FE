import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import '../viewmodel/user_management_viewmodel.dart';
import 'user_list_item.dart';

class UserManagementList extends StatelessWidget {
  const UserManagementList({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<UserManagementViewModel>();
    final activeData = viewModel.activeData;

    return Expanded(
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceMd),
        itemCount: activeData.length,
        separatorBuilder: (context, index) =>
            const SizedBox(height: AppDimens.spaceMd),
        itemBuilder: (context, index) {
          final user = activeData[index];
          return UserListItem(
            userName: user['userName'],
            userRole: user['userRole'],
            avatarUrl: user['avatarUrl'],
            initialStatus: user['status'],
            onEditTap: () => viewModel.editUser(index),
          );
        },
      ),
    );
  }
}
