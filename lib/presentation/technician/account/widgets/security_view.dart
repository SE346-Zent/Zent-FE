import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:zent_fe/presentation/common/core/themes/boxshadow.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';

import 'tech_app_bar.dart';
import 'tech_text_field.dart';
import 'tech_primary_button.dart';
import '../viewmodels/security_viewmodel.dart';

class TechSecurityView extends StatefulWidget {
  const TechSecurityView({super.key});

  @override
  State<TechSecurityView> createState() => _TechSecurityViewState();
}

class _TechSecurityViewState extends State<TechSecurityView> {
  late final ScrollController _historyScrollController;

  @override
  void initState() {
    super.initState();
    _historyScrollController = ScrollController();
  }

  @override
  void dispose() {
    _historyScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<TechSecurityViewModel>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const TechAppBar(
        title: 'Security Settings',
        showBackButton: true,
        showBottomDivider: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimens.spaceMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // CHANGE PASSWORD
              _buildSectionTitle(Icons.lock_outline, 'Change Password'),
              _buildGroupWrapper(
                child: Column(
                  children: [
                    TechTextField(
                      label: 'Current Password',
                      hint: '••••••••',
                      suffixIcon: Icons.visibility_off_outlined,
                      labelStyle: TextStyles.bodyLarge.copyWith(
                        color: AppColors.primary500,
                      ),
                    ),
                    SizedBox(height: AppDimens.spaceMd),
                    TechTextField(
                      label: 'New Password',
                      hint: '••••••••',
                      suffixIcon: Icons.visibility_off_outlined,
                      labelStyle: TextStyles.bodyLarge.copyWith(
                        color: AppColors.primary500,
                      ),
                    ),
                    SizedBox(height: AppDimens.spaceMd),
                    TechTextField(
                      label: 'Confirm New Password',
                      hint: '••••••••',
                      suffixIcon: Icons.visibility_off_outlined,
                      labelStyle: TextStyles.bodyLarge.copyWith(
                        color: AppColors.primary500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppDimens.spaceXl),

              // RECOVERY EMAIL
              _buildSectionTitle(Icons.mail_outline, 'Recovery Email'),
              _buildGroupWrapper(
                child: TechTextField(
                  label: 'Update recovery email address',
                  hint: 'name@gmail.com',
                  labelStyle: TextStyles.bodyMedium.copyWith(
                    color: AppColors.secondary300,
                  ),
                ),
              ),
              const SizedBox(height: AppDimens.spaceXl),

              // LOGIN HISTORY
              _buildSectionTitle(Icons.history, 'Login History'),
              _buildGroupWrapper(
                padding: EdgeInsets.zero,
                child: SizedBox(
                  height: 220.0,
                  child: Scrollbar(
                    controller: _historyScrollController,
                    thumbVisibility: true,
                    radius: const Radius.circular(4.0),
                    child: ListView.separated(
                      controller: _historyScrollController,
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      itemCount: viewModel.loginHistory.length,
                      separatorBuilder: (_, _) => const Divider(
                        height: 1.0,
                        color: AppColors.surface600,
                      ),
                      itemBuilder: (context, index) {
                        final item = viewModel.loginHistory[index];
                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 4.0,
                          ),
                          title: Text(
                            item.deviceName,
                            style: TextStyles.bodyLarge.copyWith(
                              color: AppColors.primary500,
                            ),
                          ),
                          subtitle: Text(
                            item.location ?? 'Unknown',
                            style: TextStyles.label.copyWith(
                              color: AppColors.secondary300,
                            ),
                          ),
                          trailing: Text(
                            '${item.createdAt.day}/${item.createdAt.month}/${item.createdAt.year}',
                            style: TextStyles.label.copyWith(
                              color: AppColors.secondary500,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppDimens.spaceXl),

              // SAVE BUTTON
              TechPrimaryButton(
                text: 'Save Changes',
                icon: Icons.save_outlined,
                onPressed: () => viewModel.saveChanges(context),
              ),
              const SizedBox(height: AppDimens.spaceLg),
            ],
          ),
        ),
      ),
    );
  }

  // Icon + Text
  Widget _buildSectionTitle(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Icon(icon, color: AppColors.tertiary500, size: 24.0),
          const SizedBox(width: 8.0),
          Text(
            title,
            style: TextStyles.title.copyWith(color: AppColors.primary500),
          ),
        ],
      ),
    );
  }

  // border secondary100
  Widget _buildGroupWrapper({
    required Widget child,
    EdgeInsetsGeometry? padding,
  }) {
    return Container(
      padding: padding ?? const EdgeInsets.all(AppDimens.spaceMd),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: AppColors.secondary100, width: 1.5),
        boxShadow: [BoxShadowStyles.subtle],
      ),
      child: child,
    );
  }
}
