import 'package:flutter/material.dart';
import 'package:zent_fe/presentation/common/core/utils/tap_debounce.dart';
import 'package:provider/provider.dart';

import 'package:zent_fe/di/injection_container.dart';
import 'package:zent_fe/presentation/admin/account/widgets/login_history_section.dart';
import 'package:zent_fe/presentation/common/core/themes/boxshadow.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';

import 'widgets/customer_app_bar.dart';
import 'widgets/customer_text_field.dart';
import 'widgets/customer_primary_button.dart';
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

class _CustomerSecurityView extends StatefulWidget {
  const _CustomerSecurityView();

  @override
  State<_CustomerSecurityView> createState() => _CustomerSecurityViewState();
}

class _CustomerSecurityViewState extends State<_CustomerSecurityView> {
  final _recoveryEmailCtrl = TextEditingController();
  final _recoveryPasswordCtrl = TextEditingController();
  final _otpCtrl = TextEditingController();
  final _currentPasswordCtrl = TextEditingController();
  final _newPasswordCtrl = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _currentPasswordCtrl.addListener(_onPasswordFieldsChanged);
    _newPasswordCtrl.addListener(_onPasswordFieldsChanged);
    _confirmPasswordCtrl.addListener(_onPasswordFieldsChanged);
  }

  void _onPasswordFieldsChanged() {
    final viewModel = context.read<CustomerSecurityViewModel>();
    if (viewModel.changePasswordSuccess ||
        viewModel.changePasswordError != null) {
      viewModel.resetChangePasswordState();
    }
  }

  @override
  void dispose() {
    _currentPasswordCtrl.removeListener(_onPasswordFieldsChanged);
    _newPasswordCtrl.removeListener(_onPasswordFieldsChanged);
    _confirmPasswordCtrl.removeListener(_onPasswordFieldsChanged);
    _recoveryEmailCtrl.dispose();
    _recoveryPasswordCtrl.dispose();
    _otpCtrl.dispose();
    _currentPasswordCtrl.dispose();
    _newPasswordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CustomerSecurityViewModel>();

    return ThrottledGestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.background500,
        appBar: const CustomerAppBar(
          title: 'Security Settings',
          showBackButton: true,
          showBottomDivider: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimens.spaceMd),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // CHANGE PASSWORD
                _buildSectionTitle(Icons.lock_outline, 'Change Password'),
                _buildGroupWrapper(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CustomerTextField(
                        controller: _currentPasswordCtrl,
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
                        controller: _newPasswordCtrl,
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
                        controller: _confirmPasswordCtrl,
                        label: 'Confirm New Password',
                        hint: '••••••••',
                        suffixIcon: Icons.visibility_off_outlined,
                        obscureText: true,
                        labelStyle: TextStyles.bodyLarge.copyWith(
                          color: AppColors.primary500,
                        ),
                      ),
                      if (viewModel.changePasswordError != null) ...[
                        const SizedBox(height: AppDimens.spaceSm),
                        Text(
                          viewModel.changePasswordError!,
                          style: TextStyles.label.copyWith(color: Colors.red),
                        ),
                      ] else if (viewModel.changePasswordSuccess) ...[
                        const SizedBox(height: AppDimens.spaceSm),
                        Text(
                          'Password changed successfully!',
                          style: TextStyles.label.copyWith(
                            color: AppColors.tertiary500,
                          ),
                        ),
                      ],
                      const SizedBox(height: AppDimens.spaceMd),
                      CustomerPrimaryButton(
                        text: viewModel.isChangePasswordLoading
                            ? 'Changing…'
                            : 'Change Password',
                        isLoading: viewModel.isChangePasswordLoading,
                        onPressed: viewModel.isChangePasswordLoading
                            ? null
                            : () {
                                final current = _currentPasswordCtrl.text;
                                final newPass = _newPasswordCtrl.text;
                                final confirm = _confirmPasswordCtrl.text;

                                if (current.isEmpty ||
                                    newPass.isEmpty ||
                                    confirm.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Please fill all password fields',
                                      ),
                                    ),
                                  );
                                  return;
                                }
                                if (newPass != confirm) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'New passwords do not match',
                                      ),
                                    ),
                                  );
                                  return;
                                }
                                viewModel
                                    .changePassword(
                                      currentPassword: current,
                                      newPassword: newPass,
                                    )
                                    .then((_) {
                                      if (viewModel.changePasswordSuccess) {
                                        _currentPasswordCtrl.clear();
                                        _newPasswordCtrl.clear();
                                        _confirmPasswordCtrl.clear();
                                      }
                                    });
                              },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppDimens.spaceXl),

                // RECOVERY EMAIL
                _buildSectionTitle(Icons.mail_outline, 'Recovery Email'),
                _buildRecoveryEmailSection(context, viewModel),
                const SizedBox(height: AppDimens.spaceXl),

                // LOGIN HISTORY
                LoginHistorySection(
                  history: viewModel.loginHistory,
                  isLoading: viewModel.isLoadingHistory,
                ),
                const SizedBox(height: AppDimens.spaceLg),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecoveryEmailSection(
    BuildContext context,
    CustomerSecurityViewModel viewModel,
  ) {
    if (viewModel.recoveryStep == RecoveryEmailStep.done) {
      return _buildGroupWrapper(
        child: Row(
          children: [
            const Icon(Icons.check_circle, color: AppColors.tertiary500),
            const SizedBox(width: AppDimens.spaceSm),
            Text(
              'Recovery email verified!',
              style: TextStyles.bodyLarge.copyWith(
                color: AppColors.tertiary500,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: viewModel.resetRecoveryFlow,
              child: const Text('Change'),
            ),
          ],
        ),
      );
    }

    if (viewModel.recoveryStep == RecoveryEmailStep.awaitingOtp) {
      return _buildGroupWrapper(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Enter the 6-digit OTP sent to your recovery email.',
              style: TextStyles.bodyMedium.copyWith(
                color: AppColors.secondary400,
              ),
            ),
            const SizedBox(height: AppDimens.spaceMd),
            CustomerTextField(
              controller: _otpCtrl,
              label: 'OTP Code',
              hint: '123456',
              keyboardType: TextInputType.number,
              labelStyle: TextStyles.bodyLarge.copyWith(
                color: AppColors.primary500,
              ),
            ),
            if (viewModel.recoveryError != null) ...[
              const SizedBox(height: AppDimens.spaceSm),
              Text(
                viewModel.recoveryError!,
                style: TextStyles.label.copyWith(color: Colors.red),
              ),
            ],
            const SizedBox(height: AppDimens.spaceMd),
            Row(
              children: [
                TextButton(
                  onPressed: viewModel.isRecoveryLoading
                      ? null
                      : viewModel.resetRecoveryFlow,
                  child: const Text('Back'),
                ),
                const SizedBox(width: AppDimens.spaceMd),
                Expanded(
                  child: CustomerPrimaryButton(
                    text: viewModel.isRecoveryLoading
                        ? 'Verifying…'
                        : 'Verify OTP',
                    isLoading: viewModel.isRecoveryLoading,
                    onPressed: viewModel.isRecoveryLoading
                        ? null
                        : () => viewModel.verifyRecoveryOtp(
                            context: context,
                            otpCode: _otpCtrl.text.trim(),
                          ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    // idle state – show email + password fields
    return _buildGroupWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomerTextField(
            controller: _recoveryEmailCtrl,
            label: 'Recovery Email',
            hint: 'name@gmail.com',
            keyboardType: TextInputType.emailAddress,
            labelStyle: TextStyles.bodyMedium.copyWith(
              color: AppColors.secondary300,
            ),
          ),
          const SizedBox(height: AppDimens.spaceMd),
          CustomerTextField(
            controller: _recoveryPasswordCtrl,
            label: 'Your Current Password',
            hint: '••••••••',
            obscureText: true,
            suffixIcon: Icons.visibility_off_outlined,
            labelStyle: TextStyles.bodyMedium.copyWith(
              color: AppColors.secondary300,
            ),
          ),
          if (viewModel.recoveryError != null) ...[
            const SizedBox(height: AppDimens.spaceSm),
            Text(
              viewModel.recoveryError!,
              style: TextStyles.label.copyWith(color: Colors.red),
            ),
          ],
          const SizedBox(height: AppDimens.spaceMd),
          CustomerPrimaryButton(
            text: viewModel.isRecoveryLoading
                ? 'Sending OTP…'
                : 'Set Recovery Email',
            isLoading: viewModel.isRecoveryLoading,
            onPressed: viewModel.isRecoveryLoading
                ? null
                : () => viewModel.requestRecoveryEmailOtp(
                    context: context,
                    recoveryEmail: _recoveryEmailCtrl.text.trim(),
                    password: _recoveryPasswordCtrl.text,
                  ),
          ),
        ],
      ),
    );
  }

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
