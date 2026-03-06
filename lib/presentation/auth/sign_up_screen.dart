import 'package:flutter/material.dart';
import 'widgets/auth_header.dart';
import 'widgets/auth_text_field.dart';
import 'widgets/auth_primary_button.dart';
import 'widgets/auth_footer_link.dart';
import '../common/core/themes/colors.dart';
import '../common/core/themes/dimens.dart';
import '../common/core/themes/text_styles.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background500,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimens.spaceLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppDimens.spaceXl),

              // Header Section 
              const AuthHeader(
                title: 'Register Now',
                subtitle: 'Fill in form below to create an account',
                showLogo: true,
                isCenter: false,
              ),

              const SizedBox(height: AppDimens.spaceXl),

              // Input Section
              const AuthTextField(
                label: 'Full Name',
                hintText: 'Nguyen Van A',
              ),
              
              const SizedBox(height: AppDimens.spaceMd),

              const AuthTextField(
                label: 'Email Address',
                hintText: 'name@gmail.com',
                keyboardType: TextInputType.emailAddress,
              ),
              
              const SizedBox(height: AppDimens.spaceMd),

              const AuthTextField(
                label: 'Phone Number',
                hintText: '0123456',
                keyboardType: TextInputType.phone,
              ),
                  
              const SizedBox(height: AppDimens.spaceMd),

              const AuthTextField(
                label: 'Password',
                hintText: 'Create a password',
                isPassword: true,
              ),

              const SizedBox(height: AppDimens.spaceXl),

              // Action Button
              AuthPrimaryButton(
                text: 'Sign Up',
                onPressed: () {
                  print("Đang xử lý đăng ký...");
                },
              ),

              const SizedBox(height: AppDimens.spaceXl),

              // Social Login Divider
              Row(
                children: [
                  Expanded(child: Divider(color: AppColors.secondary200)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text('Or sign up with', style: TextStyles.label),
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
                text: "Already have an account?",
                linkText: 'Log In',
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

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