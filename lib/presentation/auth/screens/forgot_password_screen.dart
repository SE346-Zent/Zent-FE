import 'package:flutter/material.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/auth_primary_button.dart';
import '../../common/core/themes/colors.dart';
import '../../common/core/themes/dimens.dart';
import '../../common/core/themes/text_styles.dart';
import 'verify_otp_screen.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface50,
      body: SafeArea(
        child: Column(
          children: [
            // Rollable content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.spaceLg,
                  vertical: 40,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Forgot Password?',
                      style: TextStyles.display.copyWith(color: AppColors.primary500),
                    ),
                    
                    const SizedBox(height: AppDimens.spaceSm),
                    
                    Text(
                      'Enter your email address to receive password reset instructions',
                      style: TextStyles.bodyMedium.copyWith(color: AppColors.secondary400),
                    ),
                    
                    const SizedBox(height: AppDimens.spaceXl),

                    const AuthTextField(
                      hintText: 'Enter your new email address',
                      keyboardType: TextInputType.emailAddress,
                    ),

                    const SizedBox(height: AppDimens.spaceXl),

                    AuthPrimaryButton(
                      text: 'Send OTP Code',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const VerifyOtpScreen()),
                        );
                      },
                    ),

                    const SizedBox(height: AppDimens.spaceLg),

                    // Back to Sign In
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Text(
                        '← Back to Sign In',
                        style: TextStyles.label.copyWith(
                          color: AppColors.tertiary500,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Freeze content (Logo + App Name)
            Padding(
              padding: const EdgeInsets.only(bottom: AppDimens.spaceLg),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/ZentAvatar.png', height: 28, fit: BoxFit.contain),
                  const SizedBox(width: AppDimens.spaceSm),
                  Text(
                    'ZENT',
                    style: TextStyles.title.copyWith(
                      letterSpacing: 1.5,
                      color: AppColors.primary500,
                      fontWeight: FontWeight.bold,
                    ),
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