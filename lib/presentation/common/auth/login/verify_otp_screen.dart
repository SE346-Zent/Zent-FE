import 'package:flutter/material.dart';
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

class VerifyOtpScreen extends StatelessWidget {
  const VerifyOtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface50,
      appBar: const AuthAppBar(title: 'Verification'),
      body: SafeArea(
        child: Column(
          children: [
            // Scrollable Main Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppDimens.spaceLg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: AppDimens.spaceXl),

                    const VerifyOtpHeader(email: 'name@gmail.com'),

                    const SizedBox(height: AppDimens.spaceXl),

                    const OtpInputSection(),

                    const SizedBox(height: AppDimens.spaceXl),

                    ResendOtpText(
                      onResend: () {
                        // TODO: Implement resend OTP logic
                      },
                    ),

                    const SizedBox(height: AppDimens.spaceXl),

                    AuthPrimaryButton(
                      text: 'Send →',
                      onPressed: () {
                        // Navigate to Reset Password
                        context.go('${Routes.login}/${Routes.forgetPassword}/${Routes.verifyOtp}/${Routes.resetPassword}');
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Fixed Bottom Logo
            const ZentBottomLogo(),
          ],
        ),
      ),
    );
  }
}