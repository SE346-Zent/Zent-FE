import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/admin/account/viewmodels/user_management_viewmodel.dart';
import 'package:zent_fe/presentation/admin/account/widgets/user_list_item.dart';
import 'package:zent_fe/routing/route_names.dart';

class UserManagementList extends StatelessWidget {
  const UserManagementList({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<UserManagementViewModel>();
    final activeUsers = viewModel.activeUsers;

    if (viewModel.isLoading) {
      return const Expanded(child: Center(child: CircularProgressIndicator()));
    }

    return Expanded(
      child: ListView.separated(
        key: ValueKey<int>(viewModel.activeTabIndex),
        padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceMd),
        itemCount: activeUsers.length,
        separatorBuilder: (context, index) =>
            const SizedBox(height: AppDimens.spaceSm),
        itemBuilder: (context, index) {
          final user = activeUsers[index];
          return UserListItem(
            userId: user.id,
            userName: user.name,
            userRole: user.role.name,
            phoneNumber: user.phoneNumber,
            avatarUrl: user.avatarUrl,
            onEditTap: () => viewModel.editUser(index),
            onTap: () async {
              await context.pushNamed(
                RouteNames.adminStaffDetail,
                pathParameters: {'userId': user.id},
              );
              if (context.mounted) {
                context.read<UserManagementViewModel>().refreshData();
              }
            },
          );
        },
      ),
    );
  }
}
