import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/admin/account/viewmodel/user_management_viewmodel.dart';
import 'package:zent_fe/presentation/common/core/ui/account_header.dart';
import 'package:zent_fe/presentation/admin/account/widgets/add_user_fab.dart';
import 'package:zent_fe/presentation/admin/account/widgets/user_management_list.dart';
import 'package:zent_fe/presentation/admin/account/widgets/user_role_tabs.dart';
import 'package:zent_fe/presentation/admin/account/widgets/user_search_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zent_fe/presentation/admin/account/blocs/user_status_bloc.dart';
import 'package:zent_fe/di/injection_container.dart' as di;

class UserManagementScreen extends StatelessWidget {
  const UserManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = di.sl<UserManagementViewModel>();
    return ChangeNotifierProvider.value(
      value: viewModel,
      child: BlocProvider(
        create: (context) => UserStatusBloc(viewModel.initialStatusMap),
        child: const _UserManagementScreenContent(),
      ),
    );
  }
}

class _UserManagementScreenContent extends StatelessWidget {
  const _UserManagementScreenContent();

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
