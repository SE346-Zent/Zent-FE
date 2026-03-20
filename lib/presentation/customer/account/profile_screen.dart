import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/ui/account_header.dart';
import 'package:zent_fe/presentation/common/core/ui/avatar.dart';
import 'package:zent_fe/presentation/common/core/ui/button.dart';
import 'package:zent_fe/presentation/common/core/ui/menu_item.dart';
import 'package:zent_fe/presentation/customer/account/viewmodels/customer_profile_viewmodel.dart';
import 'package:zent_fe/presentation/customer/account/widgets/profile_user_info.dart';
import 'package:zent_fe/di/injection_container.dart' as di;

class CustomerProfileScreen extends StatelessWidget {
  const CustomerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => di.sl<CustomerProfileViewModel>(),
      child: const _ProfileScreenContent(),
    );
  }
}

class _ProfileScreenContent extends StatelessWidget {
  const _ProfileScreenContent();

  void _onMenuItemTapped(BuildContext context, int index) {
    if (index == 0) {
      context.goNamed('customerPersonalInfo');
    } else {
      debugPrint("action triggered: tap on menu item $index");
    }
  }

  void _onSignOutPressed() {
    debugPrint("action triggered: sign out");
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CustomerProfileViewModel>();

    return Scaffold(
      backgroundColor: AppColors.background500,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 0,
            vertical: AppDimens.spaceMd,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const AccountHeader(
                title: 'Profile',
                showDivider: false,
                horizontalPadding: 0,
                verticalPadding: 0,
                showLeading: false,
              ),
              const SizedBox(height: AppDimens.spaceLg),
              Avatar(name: viewModel.userName, imageUrl: viewModel.avatarUrl),
              const SizedBox(height: AppDimens.spaceMd),
              ProfileUserInfo(
                name: viewModel.userName,
                email: viewModel.userEmail,
              ),
              const SizedBox(height: AppDimens.spaceXl),
              ...List.generate(viewModel.menuItems.length, (index) {
                final item = viewModel.menuItems[index];
                return Padding(
                  padding: const EdgeInsets.only(
                    bottom: AppDimens.spaceSm,
                    left: AppDimens.spaceMd,
                    right: AppDimens.spaceMd,
                  ),
                  child: MenuItem(
                    title: item['title'] as String,
                    subtitle: item['subtitle'] as String,
                    iconData: item['icon'] as IconData,
                    onTap: () => _onMenuItemTapped(context, index),
                  ),
                );
              }),
              const SizedBox(height: AppDimens.spaceXl),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.spaceMd,
                ),
                child: PrimaryActionButton(
                  label: 'Sign Out',
                  width: double.infinity,
                  icon: Icons.logout,
                  onPressed: _onSignOutPressed,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
