import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

// Core Routing & Theming
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';

// Shared Auth Components
import 'widgets/auth_app_bar.dart';
import 'widgets/auth_primary_button.dart';
import 'widgets/zent_bottom_logo.dart';

// Feature-specific Widgets
import 'widgets/verify_otp_header.dart';
import 'widgets/otp_input_section.dart';
import 'widgets/resend_otp_text.dart';

// ViewModel
import 'view_models/verify_otp_view_model.dart';
import 'package:zent_fe/di/injection_container.dart' as di;

class VerifyOtpScreen extends StatelessWidget {
  const VerifyOtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => di.sl<VerifyOtpViewModel>(),
      child: const _VerifyOtpScreenContent(),
    );
  }
}

class _VerifyOtpScreenContent extends StatelessWidget {
  const _VerifyOtpScreenContent();

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final viewModel = context.watch<VerifyOtpViewModel>();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.surface50,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Column(
            children: [
              Container(
                height: 1.0,
                width: double.infinity,
                color: Colors.black,
              ),
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
                                const VerifyOtpHeader(email: 'name@gmail.com'),
                                const SizedBox(height: AppDimens.spaceXl),
                                const OtpInputSection(),
                                const SizedBox(height: AppDimens.spaceXl),
                                ResendOtpText(onResend: () {}),
                                const SizedBox(height: AppDimens.spaceXl),
                                AuthPrimaryButton(
                                  text: 'Send →',
                                  onPressed: () =>
                                      context.goNamed('resetPassword'),
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
