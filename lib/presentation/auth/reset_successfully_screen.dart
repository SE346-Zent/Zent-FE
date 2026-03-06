import 'package:flutter/material.dart';
import 'login_screen.dart';
import '../common/core/themes/colors.dart';
import '../common/core/themes/dimens.dart';
import '../common/core/themes/text_styles.dart';

class ResetSuccessfullyScreen extends StatelessWidget {
  const ResetSuccessfullyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface50,
      
      // APP BAR WITHOUT BACK BUTTON
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false, 
        title: Text(
          'Reset Password',
          style: TextStyles.title.copyWith(
            color: AppColors.primary500,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      
      body: SafeArea(
        child: Column(
          children: [
            // MAIN CONTENT
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceLg),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, 
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Icon Checkmark Success
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          Icons.check_circle_outline,
                          size: 60,
                          color: AppColors.tertiary500,
                        ),
                      ),
                    ),

                    const SizedBox(height: AppDimens.spaceXl),

                    Text(
                      'Password Reset\nSuccessfully',
                      textAlign: TextAlign.center,
                      style: TextStyles.display.copyWith(
                        color: AppColors.primary500,
                        height: 1.2,
                      ),
                    ),

                    const SizedBox(height: AppDimens.spaceMd),

                    Text(
                      'Your password has been updated. You can now log in with your credentials.',
                      textAlign: TextAlign.center,
                      style: TextStyles.bodyMedium.copyWith(color: AppColors.secondary400),
                    ),

                    const SizedBox(height: AppDimens.spaceXl),

                    // Back to Login Button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => const LoginScreen()),
                            (route) => false,
                          );
                        },
                        icon: const Icon(Icons.login, color: Colors.white),
                        label: Text(
                          'Back to Login',
                          style: TextStyles.title.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.tertiary500,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppDimens.boraMd),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // FREEZE FOOTER
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