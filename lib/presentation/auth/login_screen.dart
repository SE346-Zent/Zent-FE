import 'package:flutter/material.dart';
import 'widgets/auth_header.dart';
import 'widgets/auth_text_field.dart';
import 'widgets/auth_primary_button.dart';
import 'widgets/auth_footer_link.dart';
import '../common/core/themes/colors.dart';
import '../common/core/themes/dimens.dart';
import '../common/core/themes/text_styles.dart';
import 'sign_up_screen.dart';
import 'forgot_password_screen.dart';

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
            Image.asset(
              'assets/images/LoginBackground.png', 
              width: double.infinity,
              height: 320, 
              fit: BoxFit.cover,
              cacheHeight: 400,
            ),

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
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()),
                        );
                      },
                      child: Text(
                        'Forgot Password?',
                        style: TextStyles.label.copyWith(
                          color: AppColors.tertiary500,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: AppDimens.spaceLg),

                  // Action Button
                  AuthPrimaryButton(
                    text: 'Sign In',
                    onPressed: () {
                      
                    },
                  ),

                  const SizedBox(height: AppDimens.spaceXl),

                  // Social Login Divider
                  Row(
                    children: [
                      Expanded(child: Divider(color: AppColors.secondary200)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text('Or continue with', style: TextStyles.label),
                      ),
                      Expanded(child: Divider(color: AppColors.secondary200)),
                    ],
                  ),

                  const SizedBox(height: AppDimens.spaceLg),

                  // Social Buttons 
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _socialIconTile(Icons.g_mobiledata), 
                      _socialIconTile(Icons.discord),      
                      _socialIconTile(Icons.terminal),     
                    ],
                  ),

                  const SizedBox(height: AppDimens.spaceXl),

                  // Footer Section
                  AuthFooterLink(
                    text: "Don't have an account?",
                    linkText: 'Sign Up',
                    onTap: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SignUpScreen()),
                      );
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

  // Helper Widget
  Widget _socialIconTile(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.secondary200),
        borderRadius: BorderRadius.circular(AppDimens.boraSm),
      ),
      child: Icon(icon, color: AppColors.primary500),
    );
  }
}