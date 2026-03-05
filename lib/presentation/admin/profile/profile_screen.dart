import 'package:flutter/material.dart';
import '../../common/core/themes/colors.dart';
import '../../common/core/themes/dimens.dart';
import '../../common/core/themes/text_styles.dart';
import 'widgets/profile_avatar.dart';
import 'widgets/profile_logout_button.dart';
import 'widgets/profile_menu_item.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
              _buildHeader(),
              const SizedBox(height: AppDimens.spaceLg),
              const ProfileAvatar(
                name:
                    'Hung dep zai', // Replacing placeholder for UI demonstration, could use asset ZentarAvatar.png
              ),
              const SizedBox(height: AppDimens.spaceMd),
              // User Info
              _buildUserInfo(),
              const SizedBox(height: AppDimens.spaceXl),
              // Menu Items
              _buildMenuOptions(),
              const SizedBox(height: AppDimens.spaceXl),
              // Sign Out Button
              ProfileLogoutButton(onPressed: () {}),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfo() {
    return Column(
      children: [
        Text(
          'Hung dep zai',
          style: TextStyles.headline.copyWith(color: AppColors.primary500),
        ),
        const SizedBox(height: AppDimens.spaceXs),
        Text(
          'Super Admin',
          style: TextStyles.bodyLarge.copyWith(color: AppColors.secondary500),
        ),
      ],
    );
  }

  Widget _buildMenuOptions() {
    return Column(
      children: [
        ProfileMenuItem(
          title: 'User Management',
          subtitle: 'Contact details & address',
          iconData: Icons.person_outline,
          onTap: () {},
        ),
        const SizedBox(height: AppDimens.spaceMd),
        ProfileMenuItem(
          title: 'Security Settings',
          subtitle: 'Security & Biomaker',
          iconData: Icons.lock_outline,
          onTap: () {},
        ),
        const SizedBox(height: AppDimens.spaceMd),
        ProfileMenuItem(
          title: 'System Log',
          subtitle: 'Security & Biomaker',
          iconData: Icons.person_outline,
          onTap: () {},
        ),
        const SizedBox(height: AppDimens.spaceMd),
        ProfileMenuItem(
          title: 'Company Settings',
          subtitle: 'Security & Biomaker',
          iconData: Icons.business_outlined,
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        SizedBox(
          width: 40.0,
          height: 32.0,
          child: IconButton(
            padding: EdgeInsets.zero,
            icon: const Icon(Icons.arrow_back, color: AppColors.primary500),
            onPressed: () {},
          ),
        ),
        Expanded(
          child: Center(
            child: Text(
              'Profile',
              style: TextStyles.headline.copyWith(color: AppColors.primary500),
            ),
          ),
        ),
        const SizedBox(width: 40.0), // Balance the row
      ],
    );
  }
}
