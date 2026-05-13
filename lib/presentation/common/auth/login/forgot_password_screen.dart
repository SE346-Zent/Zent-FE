import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

// Core Routing & Theming
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';

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

    return GestureDetector(
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

                                AuthTextField(
                                  hintText: 'Enter your new email address',
                                  keyboardType: TextInputType.emailAddress,
                                  onChanged: viewModel.setEmail,
                                ),

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
                                              extra: viewModel.email,
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
