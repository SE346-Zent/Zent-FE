import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

// Core Routing & Theming
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';

// Shared Auth Components
import 'widgets/auth_app_bar.dart';
import 'package:zent_fe/presentation/common/auth/login/widgets/auth_primary_button.dart';
import 'widgets/zent_bottom_logo.dart';

// Feature-specific Widgets
import 'widgets/verify_otp_header.dart';
import 'widgets/otp_input_section.dart';
import 'widgets/resend_otp_text.dart';

// ViewModel
import 'view_models/verify_otp_view_model.dart';
import 'package:zent_fe/di/injection_container.dart' as di;

class VerifyOtpScreen extends StatelessWidget {
  final String email;
  const VerifyOtpScreen({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => di.sl<VerifyOtpViewModel>(param1: email),
      child: const _VerifyOtpScreenContent(),
    );
  }
}

class _VerifyOtpScreenContent extends StatelessWidget {
  const _VerifyOtpScreenContent();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<VerifyOtpViewModel>();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.surface50,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Column(
            children: [
              const AuthAppBar(title: 'Verification'),
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
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                VerifyOtpHeader(email: viewModel.email),
                                const SizedBox(height: AppDimens.spaceXl),
                                OtpInputSection(onChanged: viewModel.setOtp),
                                const SizedBox(height: AppDimens.spaceXl),
                                ResendOtpText(
                                  countdown: viewModel.countdownSeconds,
                                  canResend: viewModel.canResendOTP,
                                  onResend: () async {
                                    await viewModel.resendOTP();
                                    if (context.mounted &&
                                        viewModel.errorMessage != null) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            viewModel.errorMessage!,
                                          ),
                                          backgroundColor: AppColors.error500,
                                        ),
                                      );
                                    }
                                  },
                                ),
                                const SizedBox(height: AppDimens.spaceXl),
                                AuthPrimaryButton(
                                  text: 'Send →',
                                  isLoading: viewModel.isLoading,
                                  onPressed: viewModel.otp.isEmpty
                                      ? null
                                      : () async {
                                          FocusScope.of(context).unfocus();
                                          final token = await viewModel
                                              .verifyOTP();
                                          if (token != null &&
                                              context.mounted) {
                                            context.goNamed(
                                              'resetPassword',
                                              extra: {
                                                'email': viewModel.email,
                                                'token': token,
                                              },
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
                                const Padding(
                                  padding: EdgeInsets.only(
                                    top: AppDimens.spaceLg,
                                  ),
                                  child: ZentBottomLogo(),
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
