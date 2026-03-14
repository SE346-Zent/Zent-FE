import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Core Routing & Theming
import 'package:zent_fe/routing/routes.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';

// Shared Auth Components
import 'widgets/auth_app_bar.dart';
import 'widgets/auth_header.dart';
import 'widgets/auth_text_field.dart';
import 'widgets/auth_primary_button.dart';
import 'widgets/zent_bottom_logo.dart';

// Feature-specific Widgets
import 'widgets/password_strength_indicator.dart';
import 'widgets/password_requirements_box.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface50,
      
      appBar: const AuthAppBar(title: 'Reset Password'),
      
      body: SafeArea(
        child: Column(
          children: [
            // Rollable content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppDimens.spaceLg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AuthHeader(
                      title: 'Create New Password',
                      subtitle: 'Your new password must be different from previously used password',
                      showLogo: false,
                      isCenter: false,
                    ),
                    
                    const SizedBox(height: AppDimens.spaceXl),

                    const AuthTextField(
                      label: 'New Password',
                      hintText: 'Enter your new password',
                      isPassword: true,
                    ),

                    const SizedBox(height: AppDimens.spaceSm),

                    // Password strength indicator (demo with static weak level,
                    // can be dynamic based on input)
                    const PasswordStrengthIndicator(),

                    const SizedBox(height: AppDimens.spaceLg),

                    const AuthTextField(
                      label: 'Confirm Password',
                      hintText: 'Confirm new password',
                      isPassword: true,
                    ),

                    const SizedBox(height: AppDimens.spaceLg),

                    // Password requirements box (static for now,
                    // can be dynamic based on input)
                    const PasswordRequirementsBox(),

                    const SizedBox(height: AppDimens.spaceXl),

                    AuthPrimaryButton(
                      text: 'Reset Password',
                      onPressed: () {
                        // Navigate to Success Screen via GoRouter
                        context.go('${Routes.login}/${Routes.forgetPassword}/${Routes.verifyOtp}/${Routes.resetPassword}/${Routes.resetSuccessfully}');
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