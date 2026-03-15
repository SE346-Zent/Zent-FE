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
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            Container(height: 1.0, width: double.infinity, color: Colors.black),
            const AuthAppBar(
              title: 'Reset Password',
              showBackButton: false,
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: constraints.maxHeight),
                      child: IntrinsicHeight(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceLg),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center, 
                            children: [
                              const Spacer(), 
                              const SuccessCheckmark(),
                              const SizedBox(height: AppDimens.spaceXl),
                              Text(
                                'Password Reset\nSuccessfully',
                                textAlign: TextAlign.center,
                                style: TextStyles.display.copyWith(color: AppColors.primary500, height: 1.2),
                              ),
                              const SizedBox(height: AppDimens.spaceMd),
                              Text(
                                'Your password has been updated. You can now log in with your credentials.',
                                textAlign: TextAlign.center,
                                style: TextStyles.bodyMedium.copyWith(color: AppColors.secondary500),
                              ),
                              const SizedBox(height: AppDimens.spaceXl),
                              Container(
                                width: double.infinity,
                                height: 52,
                                decoration: BoxDecoration(
                                  color: AppColors.tertiary500,
                                  borderRadius: BorderRadius.circular(AppDimens.boraMd),
                                  boxShadow: [
                                    BoxShadow(color: Colors.black.withValues(alpha: 0.25), blurRadius: 2.0, offset: const Offset(0, 2)),
                                  ],
                                ),
                                child: ElevatedButton.icon(
                                  onPressed: () => context.go(Routes.login),
                                  icon: const Icon(Icons.login, color: Colors.white),
                                  label: Text('Back to Login', style: TextStyles.title.copyWith(color: Colors.white, fontWeight: FontWeight.normal)),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimens.boraMd)),
                                  ),
                                ),
                              ),
                              const Spacer(),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: AppDimens.spaceLg),
                                child: ZentBottomLogo(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}