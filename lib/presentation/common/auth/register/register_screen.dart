import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

// Core Theming & Assets
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/presentation/common/core/app_assets.dart';

// Shared Auth Components (reused from login)
import 'package:zent_fe/presentation/common/auth/login/widgets/auth_text_field.dart';
import 'package:zent_fe/presentation/common/auth/login/widgets/auth_primary_button.dart';
import 'package:zent_fe/presentation/common/auth/login/widgets/auth_footer_link.dart';
import 'package:zent_fe/presentation/common/auth/login/widgets/social_login_section.dart';

// ViewModel
import 'package:zent_fe/presentation/common/auth/register/view_models/register_view_model.dart';
import 'package:zent_fe/di/injection_container.dart' as di;

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => di.sl<RegisterViewModel>(),
      child: const _RegisterScreenContent(),
    );
  }
}

class _RegisterScreenContent extends StatelessWidget {
  const _RegisterScreenContent();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<RegisterViewModel>();

    // Automatically show error if it exists
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (viewModel.errorMessage != null && context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(viewModel.errorMessage!)));
      }
    });

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.background500,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.spaceLg,
              vertical: AppDimens.spaceMd,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppDimens.spaceMd),
                _buildHeader(),
                const SizedBox(height: AppDimens.spaceLg),
                _buildForm(context, viewModel),
                const SizedBox(height: AppDimens.spaceMd),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Logo row: BlackLogo 23x27 + "ZENT" Title primary-500
        Row(
          children: [
            Image.asset(
              AppAssets.blackLogo,
              width: 23,
              height: 27,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: AppDimens.spaceSm),
            Text(
              'ZENT',
              style: TextStyles.title.copyWith(
                letterSpacing: 1.5,
                color: AppColors.primary500,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimens.spaceLg),

        // "Register Now" — display + primary-500
        Text(
          'Register Now',
          style: TextStyles.display.copyWith(color: AppColors.primary500),
        ),

        // "Fill in form below..." — bodyLarge + secondary-500
        const SizedBox(height: AppDimens.spaceXs),
        Text(
          'Fill in form below to create an account',
          style: TextStyles.bodyLarge.copyWith(color: AppColors.secondary500),
        ),
      ],
    );
  }

  Widget _buildForm(BuildContext context, RegisterViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Full Name
        AuthTextField(
          label: 'Full Name',
          hintText: 'Nguyen Van A',
          controller: viewModel.fullNameController,
        ),
        const SizedBox(height: AppDimens.spaceMd),

        // Email Address
        AuthTextField(
          label: 'Email Addreess',
          hintText: 'name@gmail.com',
          keyboardType: TextInputType.emailAddress,
          controller: viewModel.emailController,
        ),
        const SizedBox(height: AppDimens.spaceMd),

        // Phone Number
        AuthTextField(
          label: 'Phone Number',
          hintText: '0123456',
          keyboardType: TextInputType.phone,
          controller: viewModel.phoneController,
        ),
        const SizedBox(height: AppDimens.spaceMd),

        // Password
        AuthTextField(
          label: 'Password',
          hintText: '0123456',
          isPassword: true,
          controller: viewModel.passwordController,
        ),
        const SizedBox(height: AppDimens.spaceXl),

        // Sign Up Button (same as login's Sign In)
        viewModel.isLoading
            ? const Center(child: CircularProgressIndicator())
            : AuthPrimaryButton(
                text: 'Sign Up',
                onPressed: () async {
                  final success = await viewModel.register();
                  if (success && context.mounted) {
                    // Navigate to verify OTP or home
                  }
                },
              ),

        const SizedBox(height: AppDimens.spaceLg),

        // "Or continue with" + Google button (same as login)
        const SocialLoginSection(),

        const SizedBox(height: AppDimens.spaceLg),

        // "Already have an account? Sign In" (same as login footer, text swapped)
        AuthFooterLink(
          text: 'Already have an account?',
          linkText: 'Sign In',
          onTap: () => context.pop(),
        ),
      ],
    );
  }
}
