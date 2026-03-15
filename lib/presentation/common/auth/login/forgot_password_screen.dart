import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

// Core Routing & Theming
import 'package:zent_fe/routing/routes.dart';
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

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ForgotPasswordViewModel>();
    debugPrint('ViewModel check: $viewModel');
    return Scaffold(
      backgroundColor: AppColors.surface50,
      resizeToAvoidBottomInset: false, 
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 1.0, 
              width: double.infinity,
              color: AppColors.primary900, 
            ),

            // 1. Rollable Content (Scrollable Form Area)
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppDimens.spaceLg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Section
                    const ForgotPasswordHeader(),

                    const SizedBox(height: AppDimens.spaceXl),

                    // Email Input Field
                    const AuthTextField(
                      hintText: 'Enter your new email address',
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