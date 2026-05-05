import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Core Dependency Injection
import 'package:zent_fe/di/injection_container.dart';

// Core Theming
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';

// Shared Tech Components
import 'widgets/tech_app_bar.dart';
import 'package:zent_fe/presentation/common/core/ui/button.dart';

// Feature-specific Widgets
import 'widgets/profile_avatar.dart';
import 'widgets/profile_user_info.dart';
import 'widgets/profile_menu_options.dart';

// ViewModel
import 'viewmodels/tech_profile_viewmodel.dart';

class TechProfileScreen extends StatelessWidget {
  const TechProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => sl<TechProfileViewModel>(),
      child: const _TechProfileView(),
    );
  }
}

class _TechProfileView extends StatelessWidget {
  const _TechProfileView();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<TechProfileViewModel>();

    return Scaffold(
      backgroundColor: AppColors.background500,
      appBar: const TechAppBar(
        title: 'Profile',
        showBackButton: false,
        showBottomDivider: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.spaceMd,
            vertical: AppDimens.spaceSm,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ProfileAvatar(name: viewModel.userInfo.userName),
              const SizedBox(height: AppDimens.spaceMd),

              ProfileUserInfo(userInfo: viewModel.userInfo),
              const SizedBox(height: AppDimens.spaceXl),

              const ProfileMenuOptions(),
              const SizedBox(height: AppDimens.spaceXl),
              
              PrimaryActionButton(
                label: 'Sign Out',
                width: double.infinity,
                icon: Icons.logout,
                onPressed: () => viewModel.logout(context),
              ),
              const SizedBox(height: AppDimens.spaceXl),
            ],
          ),
        ),
      ),
    );
  }
}
