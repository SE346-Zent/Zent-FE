import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Themes
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';

// Components
import 'profile_avatar.dart';
import 'profile_user_info.dart';
import 'profile_menu_options.dart';
import 'tech_app_bar.dart';

// ViewModel
import '../view_models/tech_profile_viewmodel.dart';

class TechProfileView extends StatelessWidget {
  const TechProfileView({super.key});

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
            ],
          ),
        ),
      ),
    );
  }
}