import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../common/core/themes/colors.dart';
import '../../common/core/themes/dimens.dart';
import 'viewmodel/user_management_viewmodel.dart';
import 'widgets/account_header.dart';
import 'widgets/add_user_fab.dart';
import 'widgets/user_management_list.dart';
import 'widgets/user_role_tabs.dart';
import 'widgets/user_search_bar.dart';

class UserManagementScreen extends StatelessWidget {
  const UserManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<UserManagementViewModel>();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.background500,
        floatingActionButton: AddUserFab(
          onPressed: () => context.read<UserManagementViewModel>().addUser(),
        ),
        body: SafeArea(
          child: Column(
            children: [
              const AccountHeader(title: 'Manage Account'),
              const SizedBox(height: AppDimens.spaceLg),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: AppDimens.spaceMd),
                child: UserSearchBar(),
              ),
              const SizedBox(height: AppDimens.spaceMd),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.spaceMd,
                ),
                child: UserRoleTabs(
                  activeIndex: viewModel.activeTabIndex,
                  onTabChanged: (index) =>
                      context.read<UserManagementViewModel>().changeTab(index),
                ),
              ),
              const SizedBox(height: AppDimens.spaceLg),
              const UserManagementList(),
            ],
          ),
        ),
      ),
    );
  }
}
