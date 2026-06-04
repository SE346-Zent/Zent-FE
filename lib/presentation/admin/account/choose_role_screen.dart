import 'package:flutter/material.dart';
import 'package:zent_fe/presentation/common/core/utils/tap_debounce.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/presentation/common/core/themes/boxshadow.dart';
import 'package:zent_fe/routing/route_names.dart';
import 'package:zent_fe/di/injection_container.dart' as di;
import 'viewmodels/choose_role_viewmodel.dart';
import 'package:zent_fe/presentation/common/core/ui/account_header.dart';

class ChooseRoleScreen extends StatelessWidget {
  const ChooseRoleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => di.sl<ChooseRoleViewModel>(),
      child: const _ChooseRoleScreenContent(),
    );
  }
}

class _ChooseRoleScreenContent extends StatelessWidget {
  const _ChooseRoleScreenContent();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ChooseRoleViewModel>();

    return Scaffold(
      backgroundColor: AppColors.background500,
      body: SafeArea(
        child: Column(
          children: [
            const AccountHeader(title: 'Create Account', showDivider: true),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppDimens.spaceMd),
                    Text(
                      'Choose Role',
                      style: TextStyles.display.copyWith(
                        color: AppColors.primary500,
                      ),
                    ),
                    const SizedBox(height: AppDimens.spaceSm),
                    Text(
                      'Choose a role to create a new account',
                      style: TextStyles.bodyMedium.copyWith(
                        color: AppColors.secondary500,
                      ),
                    ),
                    if (viewModel.isLoading)
                      const Expanded(
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary500,
                          ),
                        ),
                      )
                    else ...[
                      const SizedBox(height: 48),
                      _buildRoleCard(
                        title: 'Technicians',
                        description:
                            'Access your daily job assignments, and manage your field operations efficiently',
                        icon: Icons.build_outlined,
                        isSelected: viewModel.selectedRole == 'Technicians',
                        onTap: () => viewModel.selectRole('Technicians'),
                      ),
                      if (viewModel.canCreateAdmin) ...[
                        const SizedBox(height: AppDimens.spaceLg),
                        _buildRoleCard(
                          title: 'Admins',
                          description:
                              'Oversee all active operations, manage technician schedules to ensure maximum productivity.',
                          icon: Icons.settings_outlined,
                          isSelected: viewModel.selectedRole == 'Admins',
                          onTap: () => viewModel.selectRole('Admins'),
                        ),
                      ],
                      const Spacer(),
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: AppColors.tertiary500,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [BoxShadowStyles.glowing],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: ThrottledInkWell(
                            borderRadius: BorderRadius.circular(8),
                            onTap: () {
                              context.pushNamed(
                                RouteNames.adminCreateAccount,
                                extra: {'role': viewModel.selectedRole},
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 12.0,
                              ),
                              child: Center(
                                child: Text(
                                  'Continue',
                                  style: TextStyles.title.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleCard({
    required String title,
    required String description,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final borderColor = isSelected
        ? AppColors.tertiary500
        : AppColors.surface800;
    final contentColor = isSelected
        ? AppColors.tertiary500
        : AppColors.primary500;

    return Padding(
      // Match the spacing from the screen edges
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: ThrottledGestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
          decoration: BoxDecoration(
            color: AppColors.surface100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor, width: 2),
          ),
          child: Column(
            children: [
              Icon(icon, size: 40, color: contentColor),
              const SizedBox(height: 12),
              Text(
                title,
                style: TextStyles.title.copyWith(color: contentColor),
              ),
              const SizedBox(height: AppDimens.spaceSm),
              Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyles.label.copyWith(color: AppColors.secondary500),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
