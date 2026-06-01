import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Core Dependency Injection
import 'package:zent_fe/di/injection_container.dart';
import 'package:zent_fe/presentation/admin/account/widgets/login_history_section.dart';

// Core Theming
import 'package:zent_fe/presentation/common/core/themes/boxshadow.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';

// Shared Customer Components
import 'widgets/customer_app_bar.dart';
import 'widgets/customer_text_field.dart';
import 'widgets/customer_primary_button.dart';

// ViewModel
import 'viewmodels/security_viewmodel.dart';

class CustomerSecurityScreen extends StatelessWidget {
  const CustomerSecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => sl<CustomerSecurityViewModel>(),
      child: const _CustomerSecurityView(),
    );
  }
}

class _CustomerSecurityView extends StatelessWidget {
  const _CustomerSecurityView();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CustomerSecurityViewModel>();

    return Scaffold(
      backgroundColor: AppColors.background500,
      appBar: const CustomerAppBar(
        title: 'Security Settings',
        showBackButton: true,
        showBottomDivider: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 0,
            vertical: AppDimens.spaceMd,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(AppDimens.spaceMd),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // CHANGE PASSWORD
                    _buildSectionTitle(Icons.lock_outline, 'Change Password'),
                    _buildGroupWrapper(
                      child: Column(
                        children: [
                          CustomerTextField(
                            label: 'Current Password',
                            hint: '••••••••',
                            suffixIcon: Icons.visibility_off_outlined,
                            obscureText: true,
                            labelStyle: TextStyles.bodyLarge.copyWith(
                              color: AppColors.primary500,
                            ),
                          ),
                          const SizedBox(height: AppDimens.spaceMd),
                          CustomerTextField(
                            label: 'New Password',
                            hint: '••••••••',
                            suffixIcon: Icons.visibility_off_outlined,
                            obscureText: true,
                            labelStyle: TextStyles.bodyLarge.copyWith(
                              color: AppColors.primary500,
                            ),
                          ),
                          const SizedBox(height: AppDimens.spaceMd),
                          CustomerTextField(
                            label: 'Confirm New Password',
                            hint: '••••••••',
                            suffixIcon: Icons.visibility_off_outlined,
                            obscureText: true,
                            labelStyle: TextStyles.bodyLarge.copyWith(
                              color: AppColors.primary500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppDimens.spaceXl),

                    // RECOVERY EMAIL
                    _buildSectionTitle(Icons.mail_outline, 'Recovery Email'),
                    _buildGroupWrapper(
                      child: CustomerTextField(
                        label: 'Update recovery email address',
                        hint: 'name@gmail.com',
                        labelStyle: TextStyles.bodyMedium.copyWith(
                          color: AppColors.secondary300,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppDimens.spaceXl),

                    // LOGIN HISTORY
                    LoginHistorySection(
                      history: viewModel.loginHistory,
                      isLoading: viewModel.isLoadingHistory,
                    ),
                    const SizedBox(height: AppDimens.spaceXl),

                    // SAVE BUTTON
                    CustomerPrimaryButton(
                      text: 'Save Changes',
                      icon: Icons.save_outlined,
                      onPressed: () => viewModel.saveChanges(context),
                    ),
                    const SizedBox(height: AppDimens.spaceLg),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Icon + Text
  Widget _buildSectionTitle(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Icon(icon, color: AppColors.tertiary500, size: 24.0),
          const SizedBox(width: AppDimens.spaceSm),
          Text(
            title,
            style: TextStyles.title.copyWith(color: AppColors.primary500),
          ),
        ],
      ),
    );
  }

  // border secondary100
  Widget _buildGroupWrapper({
    required Widget child,
    EdgeInsetsGeometry? padding,
  }) {
    return Container(
      padding: padding ?? const EdgeInsets.all(AppDimens.spaceMd),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimens.boraMd),
        border: Border.all(color: AppColors.secondary100, width: 1.5),
        boxShadow: [BoxShadowStyles.subtle],
      ),
      child: child,
    );
  }
}
