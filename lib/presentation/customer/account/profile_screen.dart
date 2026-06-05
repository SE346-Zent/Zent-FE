import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
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
    } else if (index == 1) {
      context.goNamed('customerSecuritySettings');
    } else if (index == 2) {
      context.goNamed('customerNotifications');
    } else {
      debugPrint("action triggered: tap on menu item $index");
    }
  }

  void _onSignOutPressed(
    BuildContext context,
    CustomerProfileViewModel viewModel,
  ) {
    viewModel.logout(context);
  }

  void _showCloseAccountConfirmation(
    BuildContext context,
    CustomerProfileViewModel viewModel,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Center(
          child: Text(
            'Close Account',
            style: TextStyles.headline.copyWith(
              color: AppColors.error500,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Are you sure you want to close your account?',
              textAlign: TextAlign.center,
              style: TextStyles.bodyLarge.copyWith(
                color: AppColors.primary500,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppDimens.spaceMd),
            Container(
              padding: const EdgeInsets.all(AppDimens.spaceMd),
              decoration: BoxDecoration(
                color: AppColors.error50,
                border: Border.all(color: AppColors.error500, width: 1.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: AppColors.error500,
                  ),
                  const SizedBox(width: AppDimens.spaceSm),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyles.bodyMedium.copyWith(
                          color: AppColors.primary500,
                          fontWeight: FontWeight.w500,
                        ),
                        children: [
                          const TextSpan(
                            text:
                                'This action is permanent and cannot be undone. All of your personal data, settings, and history will be ',
                          ),
                          TextSpan(
                            text: 'permanently erased.',
                            style: TextStyles.bodyMedium.copyWith(
                              color: AppColors.error500,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actionsPadding: const EdgeInsets.all(AppDimens.spaceMd),
        actions: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.secondary200),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () => Navigator.pop(ctx),
                  child: Text(
                    'No',
                    style: TextStyles.bodyLarge.copyWith(
                      color: AppColors.primary500,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppDimens.spaceMd),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary500,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () {
                    Navigator.pop(ctx);
                    viewModel.closeAccount(context);
                  },
                  child: Text(
                    'Yes',
                    style: TextStyles.bodyLarge.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
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
              AccountHeader(
                title: 'Profile',
                showDivider: false,
                horizontalPadding: 0,
                verticalPadding: 0,
                showLeading: false,
                trailing: PopupMenuButton<String>(
                  icon: const Icon(
                    Icons.more_horiz,
                    color: AppColors.primary500,
                  ),
                  onSelected: (val) {
                    if (val == 'close') {
                      _showCloseAccountConfirmation(context, viewModel);
                    }
                  },
                  offset: const Offset(-10, 30),
                  elevation: 0,
                  color: Colors.transparent,
                  shadowColor: Colors.transparent,
                  surfaceTintColor: Colors.transparent,
                  constraints: const BoxConstraints(
                    maxWidth: 162,
                    minWidth: 162,
                  ),
                  padding: EdgeInsets.zero,
                  itemBuilder: (ctx) => [
                    PopupMenuItem<String>(
                      value: 'close',
                      height: 28,
                      padding: EdgeInsets.zero,
                      child: Container(
                        width: 162.0,
                        height: 28.0,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.error50,
                          borderRadius: BorderRadius.circular(AppDimens.boraSm),
                        ),
                        child: Text(
                          'Close Account',
                          style: TextStyles.label.copyWith(
                            color: AppColors.error500,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppDimens.spaceLg),
              Avatar(
                name: viewModel.userName,
                imageUrl: viewModel.avatarUrl,
                onTap: () => viewModel.updateAvatar(context),
              ),
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
                  onPressed: () => _onSignOutPressed(context, viewModel),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
