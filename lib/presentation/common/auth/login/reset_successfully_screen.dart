import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Core Routing & Theming
import 'package:zent_fe/routing/routes.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';

// Shared Auth Components
import 'widgets/auth_app_bar.dart';
import 'widgets/zent_bottom_logo.dart';

// Feature-specific Widgets
import 'widgets/success_checkmark.dart';

class ResetSuccessfullyScreen extends StatelessWidget {
  const ResetSuccessfullyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface50,
      
      // Use our shared AppBar without leading back button
      appBar: const AuthAppBar(title: 'Reset Password'),
      
      body: SafeArea(
        child: Column(
          children: [
            // Main Content Area
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceLg),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, 
                  children: [
                    const SuccessCheckmark(),

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
                        onPressed: () => context.go(Routes.login), // Wipe stack and go to Login
                        icon: const Icon(Icons.login, color: Colors.white),
                        label: Text(
                          'Back to Login',
                          style: TextStyles.title.copyWith(
                            color: Colors.white, 
                            fontWeight: FontWeight.normal,
                          ),
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

            // Fixed Footer
            const ZentBottomLogo(),
          ],
        ),
      ),
    );
  }
}