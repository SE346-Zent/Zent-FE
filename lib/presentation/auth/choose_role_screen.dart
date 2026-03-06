import 'package:flutter/material.dart';
import 'widgets/auth_header.dart';
import 'widgets/auth_primary_button.dart';
import 'widgets/role_card.dart';
import '../common/core/themes/colors.dart';
import '../common/core/themes/dimens.dart';

class ChooseRoleScreen extends StatefulWidget {
  const ChooseRoleScreen({super.key});

  @override
  State<ChooseRoleScreen> createState() => _ChooseRoleScreenState();
}

class _ChooseRoleScreenState extends State<ChooseRoleScreen> {
  int selectedRole = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background500,
      body: SafeArea(
        child: Column( 
          children: [
            // 1. Rollable content
            Expanded(
              child: SingleChildScrollView( 
                padding: const EdgeInsets.all(AppDimens.spaceLg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: AppDimens.spaceXl),
                    
                    // Header
                    const AuthHeader(
                      title: 'Choose Your Role',
                      subtitle: 'Please select your designated role below to access the appropriate features.',
                      showLogo: true,
                      isCenter: false,
                    ),
                    
                    const SizedBox(height: AppDimens.spaceXl),

                    // Card 1: Technicians
                    RoleCard(
                      title: 'Technicians',
                      description: 'Access your daily job assignment and manage your field operations efficiently.',
                      placeholderIcon: Icons.build_circle,
                      isSelected: selectedRole == 1,
                      onTap: () => setState(() => selectedRole = 1),
                    ),

                    const SizedBox(height: AppDimens.spaceMd),

                    // Card 2: Admins
                    RoleCard(
                      title: 'Admins',
                      description: 'Oversee all active operations, manage technician schedules to ensure maximum productivity.',
                      placeholderIcon: Icons.admin_panel_settings,
                      isSelected: selectedRole == 0,
                      onTap: () => setState(() => selectedRole = 0),
                    ),
                  ],
                ),
              ),
            ),

            // 2. Fixed "Continue" button at the bottom
            Padding(
              padding: const EdgeInsets.all(AppDimens.spaceLg),
              child: AuthPrimaryButton(
                text: 'Continue',
                onPressed: () {
                  print("Role đã chọn: ${selectedRole == 0 ? 'Admin' : 'Technician'}");
                  // Xử lý chuyển trang ở đây sau này
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}