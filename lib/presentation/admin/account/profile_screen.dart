import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/ui/account_header.dart';
import 'package:zent_fe/presentation/common/core/ui/avatar.dart';
import 'package:zent_fe/presentation/common/core/ui/button.dart';
import 'widgets/profile_menu_options.dart';
import 'widgets/profile_user_info.dart';
import 'viewmodel/profile_viewmodel.dart';
import 'package:zent_fe/di/injection_container.dart' as di;

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => di.sl<ProfileViewModel>(),
      child: const _ProfileScreenContent(),
    );
  }
}

class _ProfileScreenContent extends StatelessWidget {
  const _ProfileScreenContent();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ProfileViewModel>();

    return Scaffold(
      backgroundColor: AppColors.background500,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 0,
            vertical: AppDimens.spaceMd,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const AccountHeader(
                title: 'Profile',
                showDivider: false,
                horizontalPadding: 0,
                verticalPadding: 0,
              ),
              const SizedBox(height: AppDimens.spaceLg),
              Avatar(name: viewModel.userInfo.userName),
              const SizedBox(height: AppDimens.spaceMd),
              // User Info
              ProfileUserInfo(userInfo: viewModel.userInfo),
              const SizedBox(height: AppDimens.spaceXl),
              // Menu Items
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: AppDimens.spaceMd),
                child: ProfileMenuOptions(),
              ),
              const SizedBox(height: AppDimens.spaceXl),
              // Sign Out Button
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.spaceMd,
                ),
                child: PrimaryActionButton(
                  label: 'Sign Out',
                  width: double.infinity,
                  icon: Icons.logout,
                  onPressed: () => context.read<ProfileViewModel>().logout(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
