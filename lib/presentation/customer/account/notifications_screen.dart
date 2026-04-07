import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Core Dependency Injection
import 'package:zent_fe/di/injection_container.dart';

// Core Theming
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';

// Shared Customer Components
import 'widgets/customer_app_bar.dart';
import 'widgets/customer_custom_switch.dart';
import 'widgets/customer_primary_button.dart';

// ViewModel
import 'viewmodels/notifications_viewmodel.dart';

class CustomerNotificationsScreen extends StatelessWidget {
  const CustomerNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => sl<CustomerNotificationsViewModel>(),
      child: const _CustomerNotificationsView(),
    );
  }
}

class _CustomerNotificationsView extends StatelessWidget {
  const _CustomerNotificationsView();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CustomerNotificationsViewModel>();

    return Scaffold(
      backgroundColor: AppColors.background500,
      appBar: const CustomerAppBar(
        title: 'Settings',
        showBackButton: true,
        showBottomDivider: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimens.spaceMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'NOTIFICATIONS',
                style: TextStyles.display.copyWith(
                  color: AppColors.primary500,
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: AppDimens.spaceSm),
              Text(
                'Manage how you receive updates about my notifications.',
                style: TextStyles.bodyLarge.copyWith(
                  color: AppColors.secondary500,
                ),
              ),
              const SizedBox(height: AppDimens.spaceMd),

              // Section: Communication
              _buildSectionTitle('Communication'),
              _buildSwitchRow(
                title: 'Direct message',
                subtitle: 'Chat messages from admin',
                value: viewModel.directMessage,
                onChanged: (val) => viewModel.toggleSetting('directMsg', val),
              ),

              // Section: Work Order
              _buildSectionTitle('Work Order'),
              _buildSwitchRow(
                title: 'Tracking',
                subtitle: 'Follows the active work orders',
                value: viewModel.tracking,
                onChanged: (val) => viewModel.toggleSetting('tracking', val),
              ),
              _buildSwitchRow(
                title: 'Appointment reminders',
                subtitle: 'Follows the active work orders',
                value: viewModel.appointmentReminders,
                onChanged: (val) =>
                    viewModel.toggleSetting('appointmentReminders', val),
              ),
              _buildSwitchRow(
                title: 'Invoice',
                subtitle: 'Receive digital receipts reminders',
                value: viewModel.invoice,
                onChanged: (val) => viewModel.toggleSetting('invoice', val),
              ),
              const SizedBox(height: AppDimens.spaceLg),

              // Info Box: Push Permissions
              Container(
                padding: const EdgeInsets.all(AppDimens.spaceMd),
                decoration: BoxDecoration(
                  color: AppColors.tertiary50,
                  borderRadius: BorderRadius.circular(AppDimens.boraMd),
                  border: Border.all(color: AppColors.tertiary500),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: AppColors.tertiary500,
                    ),
                    const SizedBox(width: AppDimens.spaceSm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Push Permissions',
                            style: TextStyles.bodyLarge.copyWith(
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: AppDimens.spaceXs),
                          Text(
                            'To receive these alerts, ensure notifications are enabled in your device settings',
                            style: TextStyles.label.copyWith(
                              color: AppColors.secondary300,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppDimens.spaceXl),

              // Save Button
              CustomerPrimaryButton(
                text: 'Save Settings',
                icon: Icons.save_outlined,
                onPressed: () => viewModel.saveSettings(context),
              ),
              const SizedBox(height: AppDimens.spaceLg),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimens.spaceMd),
      child: Text(
        title,
        style: TextStyles.title.copyWith(color: AppColors.primary500),
      ),
    );
  }

  Widget _buildSwitchRow({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimens.spaceLg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyles.bodyLarge.copyWith(
                    color: AppColors.primary500,
                    height: 1.2,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyles.bodyMedium.copyWith(
                    color: AppColors.secondary300,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppDimens.spaceMd),
          CustomerCustomSwitch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}
