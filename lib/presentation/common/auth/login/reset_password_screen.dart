import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

// Core Routing & Theming
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';

// Shared Auth Components
import 'widgets/auth_app_bar.dart';
import 'widgets/auth_header.dart';
import 'widgets/auth_text_field.dart';
import 'package:zent_fe/presentation/common/auth/login/widgets/auth_primary_button.dart';
import 'widgets/zent_bottom_logo.dart';

// Feature-specific Widgets
import 'widgets/password_strength_indicator.dart';
import 'widgets/password_requirements_box.dart';

// ViewModel
import 'view_models/reset_password_view_model.dart';
import 'package:zent_fe/di/injection_container.dart' as di;

class ResetPasswordScreen extends StatelessWidget {
  final String email;
  final String token;
  const ResetPasswordScreen({
    super.key,
    required this.email,
    required this.token,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          di.sl<ResetPasswordViewModel>(param1: email, param2: token),
      child: const _ResetPasswordScreenContent(),
    );
  }
}

class _ResetPasswordScreenContent extends StatelessWidget {
  const _ResetPasswordScreenContent();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ResetPasswordViewModel>();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.surface50,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Column(
            children: [
              const AuthAppBar(title: 'Reset Password'),
              Container(
                height: 1.0,
                width: double.infinity,
                color: AppColors.secondary50,
              ),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: IntrinsicHeight(
                          child: Padding(
                            padding: const EdgeInsets.all(AppDimens.spaceLg),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const AuthHeader(
                                  title: 'Create New Password',
                                  subtitle:
                                      'Your new password must be different from previously used password',
                                  showLogo: false,
                                  isCenter: false,
                                ),
                                const SizedBox(height: AppDimens.spaceMd),
                                AuthTextField(
                                  label: 'New Password',
                                  hintText: 'Enter your new password',
                                  isPassword: true,
                                  onChanged: viewModel.setNewPassword,
                                ),
                                const SizedBox(height: AppDimens.spaceLg),
                                PasswordStrengthIndicator(
                                  strengthLevel: viewModel.passwordStrength,
                                ),
                                const SizedBox(height: AppDimens.spaceLg),
                                AuthTextField(
                                  label: 'Confirm Password',
                                  hintText: 'Confirm new password',
                                  isPassword: true,
                                  onChanged: viewModel.setConfirmPassword,
                                ),
                                const SizedBox(height: AppDimens.spaceLg),
                                PasswordRequirementsBox(
                                  hasMinLength: viewModel.hasMinLength,
                                  hasNumber: viewModel.hasNumber,
                                  hasSpecialChar: viewModel.hasSpecialChar,
                                ),
                                const SizedBox(height: AppDimens.spaceXl),
                                AuthPrimaryButton(
                                  text: 'Reset Password',
                                  isLoading: viewModel.isLoading,
                                  onPressed: !viewModel.doPasswordsMatch
                                      ? null
                                      : () async {
                                          FocusScope.of(context).unfocus();
                                          final isSuccess = await viewModel
                                              .submitNewPassword();

                                          if (isSuccess && context.mounted) {
                                            context.goNamed(
                                              'resetSuccessfully',
                                            );
                                          } else if (viewModel.errorMessage !=
                                                  null &&
                                              context.mounted) {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  viewModel.errorMessage!,
                                                ),
                                                backgroundColor:
                                                    AppColors.error500,
                                              ),
                                            );
                                          }
                                        },
                                ),
                                const Spacer(),
                                const Center(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      top: AppDimens.spaceLg,
                                    ),
                                    child: ZentBottomLogo(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
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
