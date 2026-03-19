import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';

import 'tech_app_bar.dart';
import 'tech_custom_switch.dart';
import '../view_models/notifications_viewmodel.dart';

class TechNotificationsView extends StatelessWidget {
  const TechNotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<TechNotificationsViewModel>();

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: const TechAppBar(
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
              const SizedBox(height: 8.0),
              Text(
                'Manage how you receive updates about jobs, inventory and messages.',
                style: TextStyles.bodyMedium.copyWith(
                  color: AppColors.secondary300,
                ),
              ),
              const SizedBox(height: AppDimens.spaceXl),

              // Section: Job Alerts
              _buildSectionTitle('Job Alerts'),
              _buildSwitchRow(
                title: 'New Job Assignments',
                subtitle: 'Get notified when you are assigned a job',
                value: viewModel.newJobAssignments,
                onChanged: (val) => viewModel.toggleSetting('newJob', val),
              ),
              _buildSwitchRow(
                title: 'Urgent dispatches',
                subtitle: 'High priority emergency service calls',
                value: viewModel.urgentDispatches,
                onChanged: (val) => viewModel.toggleSetting('urgent', val),
              ),
              const SizedBox(height: AppDimens.spaceMd),

              // Section: Inventory & Resources
              _buildSectionTitle('Inventory & Resources'),
              _buildSwitchRow(
                title: 'Equipment Maintenance',
                subtitle: 'Reminders for tool servicing',
                value: viewModel.equipmentMaintenance,
                onChanged: (val) => viewModel.toggleSetting('equipment', val),
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
              _buildSwitchRow(
                title: 'Customer Feedback',
                subtitle: 'Reviews and ratings from completed jobs',
                value: viewModel.customerFeedback,
                onChanged: (val) => viewModel.toggleSetting('feedback', val),
              ),
              const SizedBox(height: AppDimens.spaceXl),

              // Info Box: Push Permissions
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: AppColors.tertiary50,
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(color: AppColors.tertiary500),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: AppColors.tertiary500,
                    ),
                    const SizedBox(width: 12.0),
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
                          const SizedBox(height: 4.0),
                          Text(
                            'To receive these alerts, ensure notifications are enabled in your device settings',
                            style: TextStyles.bodyMedium.copyWith(
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
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
      padding: const EdgeInsets.only(bottom: 24.0),
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
          const SizedBox(width: 16.0),
          TechCustomSwitch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}
