import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/presentation/common/core/ui/zent_error_popup.dart';
import 'package:zent_fe/presentation/common/auth/auth_view_model.dart';
import 'package:zent_fe/domain/entities/enums/user_roles.dart';
import 'package:zent_fe/routing/route_names.dart';
import 'package:geolocator/geolocator.dart';
import 'package:zent_fe/domain/usecases/auth/logout_usecase.dart';
import 'package:zent_fe/di/injection_container.dart';
import '../view_models/login_view_model.dart';
import 'social_login_button.dart'; // Import child widget

class SocialLoginSection extends StatelessWidget {
  const SocialLoginSection({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<LoginViewModel>();

    return Column(
      children: [
        // Divider Section
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

        // Google Button
        viewModel.isGoogleLoading
            ? const Center(child: CircularProgressIndicator())
            : SocialLoginButton(
                onPressed: () async {
                  final user = await viewModel.loginWithGoogle();
                  if (user != null && context.mounted) {
                    if (user.role == UserRoles.admin ||
                        user.role == UserRoles.superAdmin ||
                        user.role == UserRoles.technician) {
                      final permission = await Geolocator.checkPermission();
                      if (permission == LocationPermission.denied) {
                        await Geolocator.requestPermission();
                      }
                      final currentPermission = await Geolocator.checkPermission();
                      if (currentPermission == LocationPermission.denied ||
                          currentPermission == LocationPermission.deniedForever) {
                        await sl<LogoutUseCase>().execute();
                        if (context.mounted) {
                          context.read<AuthViewModel>().clearUser();
                          ZentErrorPopup.show(
                            context,
                            'Location permission is required for Admin and Technician roles.',
                          );
                        }
                        return;
                      }
                    }

                    if (!context.mounted) return;

                    context.read<AuthViewModel>().setLoggedInUser(user);
                    switch (user.role) {
                      case UserRoles.admin:
                        context.goNamed(RouteNames.adminDashboard);
                        break;
                      case UserRoles.technician:
                        context.goNamed(RouteNames.techHome);
                        break;
                      case UserRoles.customer:
                        context.goNamed(RouteNames.customerServices);
                        break;
                      default:
                        break;
                    }
                  } else if (viewModel.errorMessage != null &&
                      context.mounted) {
                    ZentErrorPopup.show(context, viewModel.errorMessage!);
                  }
                },
              ),
      ],
    );
  }
}
