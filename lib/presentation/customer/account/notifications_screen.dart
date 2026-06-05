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
        child: viewModel.preferences.isEmpty && viewModel.isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
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
                      subtitle: 'Chat messages from technician and support',
                      value: viewModel.directMessage,
                      onChanged: viewModel.toggleDirectMessage,
                    ),
                    const SizedBox(height: AppDimens.spaceMd),

                    // Section: Work Order
                    if (viewModel.preferences.isNotEmpty) ...[
                      _buildSectionTitle('Work Order'),
                      ...viewModel.preferences.map((pref) {
                        final displayName =
                            pref.categorySlug == 'work_order_assigned'
                            ? 'Work Order Assignment'
                            : pref.categoryName;
                        return _buildSwitchRow(
                          title: displayName,
                          subtitle: _getSubtitleForSlug(pref.categorySlug),
                          value: viewModel.isEnabled(
                            pref.categoryId,
                            pref.osEnabled,
                          ),
                          onChanged: (val) =>
                              viewModel.toggleSetting(pref.categoryId, val),
                        );
                      }),
                      const SizedBox(height: AppDimens.spaceLg),
                    ],

                    // Info Box: Push Permissions
                    Container(
                      padding: const EdgeInsets.all(AppDimens.spaceSm),
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
                      isLoading: viewModel.isLoading,
                      onPressed: () => viewModel.saveSettings(context),
                    ),
                    const SizedBox(height: AppDimens.spaceLg),
                  ],
                ),
              ),
      ),
    );
  }

  String _getSubtitleForSlug(String slug) {
    switch (slug) {
      case 'work_order_assigned':
        return 'Receive notifications when a technician is assigned to your work order';
      case 'about_to_start':
        return 'Get reminded when your scheduled service is about to start';
      case 'work_order_rejection_form':
        return 'Notifications about rejected work orders';
      case 'add_new_part':
        return 'Receive alerts when new parts are requested or added';
      case 'work_order_escalation':
        return 'Alerts when a work order needs escalation';
      case 'chat_message':
        return 'Receive alerts for direct chat messages';
      default:
        return 'Receive notifications for this category';
    }
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
