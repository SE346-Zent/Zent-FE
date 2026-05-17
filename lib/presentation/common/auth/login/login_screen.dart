import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:zent_fe/routing/route_names.dart';
import 'package:zent_fe/presentation/common/auth/auth_view_model.dart';
import 'package:zent_fe/domain/entities/enums/user_roles.dart';

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
import 'package:zent_fe/di/injection_container.dart' as di;

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => di.sl<LoginViewModel>(),
      child: const _LoginScreenContent(),
    );
  }
}

class _LoginScreenContent extends StatelessWidget {
  const _LoginScreenContent();

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final viewModel = context.watch<LoginViewModel>();

    // Automatically show error if it exists

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
                                final user = await viewModel.login();
                                if (user != null && context.mounted) {
                                  context.read<AuthViewModel>().setLoggedInUser(
                                    user,
                                  );
                                  switch (user.role) {
                                    case UserRoles.admin:
                                      context.goNamed(
                                        RouteNames.adminDashboard,
                                      );
                                      break;
                                    case UserRoles.technician:
                                      context.goNamed(RouteNames.techHome);
                                      break;
                                    case UserRoles.customer:
                                      context.goNamed(
                                        RouteNames.customerServices,
                                      );
                                      break;
                                    default:
                                      break;
                                  }
                                }
                              },
                            ),

                      const SizedBox(height: AppDimens.spaceLg),
                      const SocialLoginSection(),
                      const SizedBox(height: AppDimens.spaceLg),
                      AuthFooterLink(
                        text: "Don't have an account?",
                        linkText: 'Sign Up',
                        onTap: () => context.goNamed(RouteNames.signUp),
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
