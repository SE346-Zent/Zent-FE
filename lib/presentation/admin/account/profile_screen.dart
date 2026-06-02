import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/ui/account_header.dart';
import 'package:zent_fe/presentation/common/core/ui/avatar.dart';
import 'package:zent_fe/presentation/common/auth/auth_view_model.dart';
import 'widgets/profile_menu_options.dart';
import 'widgets/profile_user_info.dart';
import 'viewmodels/profile_viewmodel.dart';
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
    final authViewModel = context.watch<AuthViewModel>();
    final userName = authViewModel.currentUser?.name ?? 'Admin';
    final role = authViewModel.currentUser?.role != null
        ? (authViewModel.currentUser!.role.name[0].toUpperCase() +
              authViewModel.currentUser!.role.name.substring(1))
        : 'Administrator';

    return Scaffold(
      backgroundColor: AppColors.background500,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 35.0),
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
                  showLeading: false,
                ),
                const SizedBox(height: AppDimens.spaceLg),
                Avatar(name: userName),
                const SizedBox(height: AppDimens.spaceMd),
                // User Info
                ProfileUserInfo(
                  userInfo: UserProfileInfo(
                    userName: userName,
                    role: role,
                    avatarUrl: '',
                  ),
                ),
                const SizedBox(height: AppDimens.spaceXl),
                // Menu Items
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppDimens.spaceMd),
                  child: ProfileMenuOptions(),
                ),
                // Sign Out button removed — logout only available via sidebar
              ],
            ),
          ),
        ),
      ),
    );
  }
}
