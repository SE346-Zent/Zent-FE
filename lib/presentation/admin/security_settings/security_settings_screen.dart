import 'package:flutter/material.dart';
import '../../common/core/themes/colors.dart';
import '../../common/core/themes/dimens.dart';
import '../../common/core/themes/text_styles.dart';
import 'widgets/password_input_field.dart';
import 'widgets/save_changes_button.dart';
import 'widgets/security_card_container.dart';
import 'widgets/security_section_title.dart';
import 'widgets/two_factor_auth_toggle.dart';

class SecuritySettingsScreen extends StatelessWidget {
  const SecuritySettingsScreen({super.key});

  void _onBackPressed() {
    debugPrint("action triggered: _onBackPressed");
  }

  void _onSavePressed() {
    debugPrint("action triggered: _onSavePressed");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background500,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppDimens.spaceMd),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildChangePasswordSection(),
                    const SizedBox(height: AppDimens.spaceXl),
                    _buildTwoFactorSection(),
                    const SizedBox(height: AppDimens.spaceXl),
                  ],
                ),
              ),
            ),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildChangePasswordSection() {
    return Column(
      children: const [
        SecuritySectionTitle(
          title: 'Change Password',
          iconData: Icons.lock_outline,
          iconColor: AppColors.tertiary400,
          iconSize: 18.0,
        ),
        SizedBox(height: AppDimens.spaceMd),
        SecurityCardContainer(
          child: Column(
            children: [
              PasswordInputField(label: 'Current Password'),
              SizedBox(height: AppDimens.spaceMd),
              PasswordInputField(label: 'New Password'),
              SizedBox(height: AppDimens.spaceMd),
              PasswordInputField(label: 'Confirm New Password'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTwoFactorSection() {
    return Column(
      children: [
        const SecuritySectionTitle(
          title: 'Two-Factor Authentication',
          iconData: Icons.security_outlined,
          iconColor: AppColors.tertiary500,
          iconSize: 20.0,
        ),
        const SizedBox(height: AppDimens.spaceMd),
        SecurityCardContainer(
          child: TwoFactorAuthToggle(onChanged: (value) {}),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppDimens.spaceMd,
        right: AppDimens.spaceMd,
        bottom: AppDimens.spaceLg,
        top: AppDimens.spaceSm,
      ),
      child: SaveChangesButton(onPressed: _onSavePressed),
    );
  }

  Widget _buildHeader() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.spaceMd,
            vertical: AppDimens.spaceSm,
          ),
          child: Row(
            children: [
              SizedBox(
                width: 32.0,
                height: 40.0,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(
                    Icons.arrow_back,
                    color: AppColors.primary500,
                  ),
                  onPressed: _onBackPressed,
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    'Security Settings',
                    style: TextStyles.headline.copyWith(
                      color: AppColors.primary500,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 32.0), // Balance the row
            ],
          ),
        ),
        Container(
          width: double.infinity,
          height: 1.0,
          color: AppColors.secondary50,
        ),
      ],
    );
  }
}
