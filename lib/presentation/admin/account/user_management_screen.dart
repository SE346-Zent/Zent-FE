import 'package:flutter/material.dart';
import 'package:zent_fe/presentation/common/core/utils/tap_debounce.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:zent_fe/presentation/admin/account/widgets/app_search_bar.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/admin/account/viewmodels/user_management_viewmodel.dart';
import 'package:zent_fe/presentation/common/core/ui/account_header.dart';
import 'package:zent_fe/presentation/admin/account/widgets/add_user_fab.dart';
import 'package:zent_fe/presentation/admin/account/widgets/user_management_list.dart';
import 'package:zent_fe/presentation/admin/account/widgets/user_role_tabs.dart';
import 'package:zent_fe/routing/route_names.dart';
import 'package:zent_fe/di/injection_container.dart' as di;

class UserManagementScreen extends StatelessWidget {
  const UserManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => di.sl<UserManagementViewModel>(),
      child: const _UserManagementScreenContent(),
    );
  }
}

class _UserManagementScreenContent extends StatelessWidget {
  const _UserManagementScreenContent();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<UserManagementViewModel>();

    return ThrottledGestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.background500,
        floatingActionButton: AddUserFab(
          onPressed: () =>
              context.pushNamed(RouteNames.adminChooseRoleCreateAccount),
        ),
        body: SafeArea(
          child: Column(
            children: [
              const AccountHeader(title: 'Manage Account', showDivider: true),
              const SizedBox(height: AppDimens.spaceLg),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: AppDimens.spaceMd),
                child: AppSearchBar(hintText: 'Search users by name or ID'),
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
                  showBothTabs: viewModel.showBothTabs,
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
