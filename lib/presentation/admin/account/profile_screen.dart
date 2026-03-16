import 'package:flutter/material.dart';
import '../../common/core/themes/dimens.dart';
import '../../common/core/themes/colors.dart';
import '../../common/core/ui/account_header.dart';
import '../../common/core/ui/avatar.dart';
import '../../common/core/ui/button.dart';
import 'widgets/profile_menu_options.dart';
import 'widgets/profile_user_info.dart';
import 'package:provider/provider.dart';
import 'viewmodel/profile_viewmodel.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ProfileViewModel>();

    return Scaffold(
      backgroundColor: AppColors.background500,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.spaceMd,
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
              const ProfileMenuOptions(),
              const SizedBox(height: AppDimens.spaceXl),
              // Sign Out Button
              PrimaryActionButton(
                label: 'Sign Out',
                icon: Icons.logout,
                onPressed: () => context.read<ProfileViewModel>().logout(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
