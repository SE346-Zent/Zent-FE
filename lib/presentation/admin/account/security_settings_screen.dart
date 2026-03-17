import 'package:flutter/material.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/ui/account_header.dart';
import 'widgets/change_password_section.dart';
import 'widgets/save_changes_button.dart';
import 'widgets/two_factor_section.dart';
import 'package:provider/provider.dart';
import 'viewmodel/security_settings_viewmodel.dart';

class SecuritySettingsScreen extends StatelessWidget {
  const SecuritySettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SecuritySettingsViewModel(),
      child: const _SecuritySettingsScreenContent(),
    );
  }
}

class _SecuritySettingsScreenContent extends StatelessWidget {
  const _SecuritySettingsScreenContent();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SecuritySettingsViewModel>();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.background500,
        body: SafeArea(
          child: Column(
            children: [
              const AccountHeader(title: 'Security Settings'),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppDimens.spaceMd),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const ChangePasswordSection(),
                      const SizedBox(height: AppDimens.spaceXl),
                      TwoFactorSection(
                        securityData: viewModel.settingsData,
                        onToggle: (value) => viewModel.toggleTwoFactor(value),
                      ),
                      const SizedBox(height: AppDimens.spaceXl),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: AppDimens.spaceMd,
                  right: AppDimens.spaceMd,
                  bottom: AppDimens.spaceLg,
                  top: AppDimens.spaceSm,
                ),
                child: SaveChangesButton(
                  onPressed: () {
                    context.read<SecuritySettingsViewModel>().saveChanges();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
