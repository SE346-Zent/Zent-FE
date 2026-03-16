import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

// Core Routing & Theming
import 'package:zent_fe/routing/routes.dart';
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

class VerifyOtpScreen extends StatelessWidget {
  const VerifyOtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<VerifyOtpViewModel>();
    debugPrint('ViewModel check: $viewModel');
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
                                  onPressed: () => context.go(
                                    '${Routes.login}/${Routes.forgetPassword}/${Routes.verifyOtp}/${Routes.resetPassword}',
                                  ),
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
