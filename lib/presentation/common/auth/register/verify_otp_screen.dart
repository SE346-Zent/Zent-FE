import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:zent_fe/routing/route_names.dart';

// Core Routing & Theming
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';

// Shared Auth Components
import 'package:zent_fe/presentation/common/auth/login/widgets/auth_app_bar.dart';
import 'package:zent_fe/presentation/common/auth/login/widgets/auth_primary_button.dart';
import 'package:zent_fe/presentation/common/auth/login/widgets/zent_bottom_logo.dart';

// Feature-specific Widgets
import 'package:zent_fe/presentation/common/auth/login/widgets/verify_otp_header.dart';
import 'package:zent_fe/presentation/common/auth/login/widgets/otp_input_section.dart';
import 'package:zent_fe/presentation/common/auth/login/widgets/resend_otp_text.dart';

// ViewModel
import 'view_models/verify_otp_view_model.dart';
import 'package:zent_fe/di/injection_container.dart' as di;

class VerifyOtpScreen extends StatefulWidget {
  final String email;
  final bool isRegistration;
  const VerifyOtpScreen({
    super.key,
    required this.email,
    this.isRegistration = false,
  });

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  late final VerifyOtpViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = di.sl<VerifyOtpViewModel>();
    _viewModel.init(email: widget.email, isRegistration: widget.isRegistration);
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
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
                                    await viewModel.resendOtp();
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
                                          final isSuccess = await viewModel
                                              .submitOtp();

                                          if (isSuccess && context.mounted) {
                                            if (viewModel.isRegistration) {
                                              context.goNamed(RouteNames.login);
                                            } else {
                                              context.goNamed(
                                                RouteNames.resetPassword,
                                                extra: {
                                                  'email': viewModel.email,
                                                  'token': viewModel.otp,
                                                },
                                              );
                                            }
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
