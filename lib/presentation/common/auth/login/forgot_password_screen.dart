import 'package:flutter/material.dart';
import 'package:zent_fe/presentation/common/core/utils/tap_debounce.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

// Core Routing & Theming
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';

// Shared Auth Components
import 'widgets/auth_text_field.dart';
import 'widgets/auth_primary_button.dart';
import 'widgets/zent_bottom_logo.dart';

// Feature-specific Widgets
import 'widgets/forgot_password_header.dart';
import 'widgets/back_to_sign_in_button.dart';

// ViewModel
import 'view_models/forgot_password_view_model.dart';
import 'package:zent_fe/di/injection_container.dart' as di;

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => di.sl<ForgotPasswordViewModel>(),
      child: const _ForgotPasswordScreenContent(),
    );
  }
}

class _ForgotPasswordScreenContent extends StatelessWidget {
  const _ForgotPasswordScreenContent();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ForgotPasswordViewModel>();

    return ThrottledGestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.surface50,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Column(
            children: [
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
                                const ForgotPasswordHeader(),
                                const SizedBox(height: AppDimens.spaceXl),

                                // Email input field
                                AuthTextField(
                                  hintText: 'Enter your email address',
                                  keyboardType: TextInputType.emailAddress,
                                  onChanged: viewModel.setEmail,
                                ),

                                const SizedBox(height: AppDimens.spaceMd),

                                // Selector buttons for Primary / Recovery Email
                                Row(
                                  children: [
                                    Expanded(
                                      child: _EmailTypeButton(
                                        label: 'Primary Email',
                                        isSelected: !viewModel.useRecoveryEmail,
                                        onTap: () => viewModel
                                            .setUseRecoveryEmail(false),
                                      ),
                                    ),
                                    const SizedBox(width: AppDimens.spaceMd),
                                    Expanded(
                                      child: _EmailTypeButton(
                                        label: 'Recovery Email',
                                        isSelected: viewModel.useRecoveryEmail,
                                        onTap: () =>
                                            viewModel.setUseRecoveryEmail(true),
                                      ),
                                    ),
                                  ],
                                ),

                                if (viewModel.errorMessage != null) ...[
                                  const SizedBox(height: AppDimens.spaceSm),
                                  Text(
                                    viewModel.errorMessage!,
                                    style: TextStyles.label.copyWith(
                                      color: AppColors.error500,
                                    ),
                                  ),
                                ],

                                const SizedBox(height: AppDimens.spaceXl),

                                AuthPrimaryButton(
                                  text: 'Send OTP Code',
                                  isLoading: viewModel.isLoading,
                                  onPressed: !viewModel.isEmailValid
                                      ? null
                                      : () async {
                                          FocusScope.of(context).unfocus();

                                          final isSuccess = await viewModel
                                              .requestOTP();

                                          if (isSuccess && context.mounted) {
                                            context.goNamed(
                                              'forgotPasswordVerifyOtp',
                                              extra: {
                                                'email': viewModel.email,
                                                'useRecoveryEmail':
                                                    viewModel.useRecoveryEmail,
                                              },
                                            );
                                          }
                                        },
                                ),

                                const SizedBox(height: AppDimens.spaceLg),
                                const BackToSignInButton(),
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

/// Reusable toggle button for Primary / Recovery Email selection.
class _EmailTypeButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _EmailTypeButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: BorderSide(
          color: isSelected ? AppColors.tertiary300 : AppColors.secondary200,
          width: 1.5,
        ),
        backgroundColor: isSelected ? AppColors.tertiary50 : Colors.transparent,
        foregroundColor: isSelected
            ? AppColors.tertiary500
            : AppColors.primary500,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.boraSm),
        ),
        padding: const EdgeInsets.symmetric(vertical: AppDimens.spaceMd),
        textStyle: TextStyles.bodyLarge,
      ),
      onPressed: onTap,
      child: Text(label),
    );
  }
}
