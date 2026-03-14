import 'package:flutter/material.dart';

// Core Routing & Theming
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';

// Shared Auth Components
import 'widgets/auth_header.dart';
import 'widgets/auth_text_field.dart';
import 'widgets/auth_primary_button.dart';
import 'widgets/auth_footer_link.dart';

// Feature-specific Widgets
import 'widgets/login_background.dart';
import 'widgets/forgot_password_button.dart';
import 'widgets/social_login_section.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background500,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            // 1. Background Image
            const LoginBackground(),

            // 2. Main Form Container
            Container(
              margin: const EdgeInsets.only(top: 280),
              padding: const EdgeInsets.all(AppDimens.spaceLg),
              decoration: BoxDecoration(
                color: AppColors.background500,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppDimens.spaceMd),

                  // Header Section
                  const AuthHeader(
                    title: 'Welcome back!',
                    subtitle: 'Log in your Zent account to experience the wonderful app',
                    showLogo: false,
                  ),

                  const SizedBox(height: AppDimens.spaceXl),

                  // Input Section
                  const AuthTextField(
                    label: 'Email Address',
                    hintText: 'name@gmail.com',
                    keyboardType: TextInputType.emailAddress,
                  ),

                  const SizedBox(height: AppDimens.spaceMd),

                  const AuthTextField(
                    label: 'Password',
                    hintText: 'Enter your password',
                    isPassword: true,
                  ),

                  // Forgot Password Link
                  const ForgotPasswordButton(),

                  const SizedBox(height: AppDimens.spaceLg),

                  // Action Button
                  AuthPrimaryButton(
                    text: 'Sign In',
                    onPressed: () {
                      // TODO: Implement login logic
                    },
                  ),

                  const SizedBox(height: AppDimens.spaceXl),

                  // Social Login Section
                  const SocialLoginSection(),

                  const SizedBox(height: AppDimens.spaceXl),

                  // Footer Section (Optional: Kept just in case)
                  AuthFooterLink(
                    text: "Don't have an account?",
                    linkText: 'Sign Up',
                    onTap: () {
                      // TODO: Navigate to Sign Up screen via GoRouter
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}