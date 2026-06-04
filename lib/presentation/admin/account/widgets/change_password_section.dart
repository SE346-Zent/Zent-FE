import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/presentation/admin/account/viewmodels/security_settings_viewmodel.dart';
import 'password_input_field.dart';
import 'security_card_container.dart';
import 'security_section_title.dart';

class ChangePasswordSection extends StatefulWidget {
  const ChangePasswordSection({super.key});

  @override
  State<ChangePasswordSection> createState() => _ChangePasswordSectionState();
}

class _ChangePasswordSectionState extends State<ChangePasswordSection> {
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
    final viewModel = context.read<SecuritySettingsViewModel>();
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
    _currentPasswordCtrl.dispose();
    _newPasswordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SecuritySettingsViewModel>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SecuritySectionTitle(
          title: 'Change Password',
          iconData: Icons.lock_outline,
          iconColor: AppColors.tertiary400,
          iconSize: 24.0,
        ),
        const SizedBox(height: AppDimens.spaceMd),
        SecurityCardContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              PasswordInputField(
                label: 'Current Password',
                controller: _currentPasswordCtrl,
              ),
              const SizedBox(height: AppDimens.spaceMd),
              PasswordInputField(
                label: 'New Password',
                controller: _newPasswordCtrl,
              ),
              const SizedBox(height: AppDimens.spaceMd),
              PasswordInputField(
                label: 'Confirm New Password',
                controller: _confirmPasswordCtrl,
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
              Align(
                alignment: Alignment.centerRight,
                child: FilledButton(
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
                                content: Text('New passwords do not match'),
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
                  child: viewModel.isChangePasswordLoading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Change Password'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
