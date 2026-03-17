import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

// ViewModel
import 'view_models/login_view_model.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<LoginViewModel>();

    // Automatically show error if it exists
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (viewModel.errorMessage != null && context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(viewModel.errorMessage!)));
      }
    });

    final screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.background500,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Stack(
              children: [
                SizedBox(
                  height: screenHeight * 0.28,
                  width: double.infinity,
                  child: const LoginBackground(),
                ),

                Container(
                  margin: EdgeInsets.only(top: screenHeight * 0.25),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimens.spaceLg,
                    vertical: AppDimens.spaceMd,
                  ),
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
                      const AuthHeader(
                        title: 'Welcome back!',
                        subtitle:
                            'Log in your Zent account to experience the wonderful app',
                        showLogo: false,
                      ),

                      const SizedBox(height: AppDimens.spaceLg),

                      AuthTextField(
                        label: 'Email Address',
                        hintText: 'name@gmail.com',
                        keyboardType: TextInputType.emailAddress,
                        controller: viewModel.emailController,
                      ),

                      const SizedBox(height: AppDimens.spaceMd),

                      AuthTextField(
                        label: 'Password',
                        hintText: 'Enter your password',
                        isPassword: true,
                        controller: viewModel.passwordController,
                      ),

                      const ForgotPasswordButton(),

                      const SizedBox(height: AppDimens.spaceMd),

                      viewModel.isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : AuthPrimaryButton(
                              text: 'Sign In',
                              onPressed: () async {
                                final success = await viewModel.login();
                                if (success && context.mounted) {
                                  // Router will pick up the change if it listens to token store
                                }
                              },
                            ),

                      const SizedBox(height: AppDimens.spaceLg),

                      const SocialLoginSection(),

                      const SizedBox(height: AppDimens.spaceLg),

                      AuthFooterLink(
                        text: "Don't have an account?",
                        linkText: 'Sign Up',
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
