import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Core Routing & Theming
import 'package:zent_fe/routing/routes.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';

// Shared Auth Components
import '../widgets/auth_text_field.dart';
import '../widgets/auth_primary_button.dart';
import '../widgets/zent_bottom_logo.dart';

// Feature-specific Widgets
import '../widgets/forgot_password_header.dart';
import '../widgets/back_to_sign_in_button.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface50,
      body: SafeArea(
        child: Column(
          children: [
            // 1. Rollable Content (Scrollable Form Area)
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.spaceLg,
                  vertical: 40,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Section
                    const ForgotPasswordHeader(),

                    const SizedBox(height: AppDimens.spaceXl),

                    // Email Input Field
                    const AuthTextField(
                      hintText: 'Enter your email address',
                      keyboardType: TextInputType.emailAddress,
                    ),

                    const SizedBox(height: AppDimens.spaceXl),

                    // Action Button
                    AuthPrimaryButton(
                      text: 'Send OTP Code',
                      onPressed: () {
                        // Push to OTP Screen (Allows popping back to fix email)
                        context.push('${Routes.login}/${Routes.forgetPassword}/${Routes.verifyOtp}');
                      },
                    ),

                    const SizedBox(height: AppDimens.spaceLg),

                    // Back to Sign In Link
                    const BackToSignInButton(),
                  ],
                ),
              ),
            ),

            // 2. Freeze Content (Bottom Logo)
            const ZentBottomLogo(),
          ],
        ),
      ),
    );
  }
}