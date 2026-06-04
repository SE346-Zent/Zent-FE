import 'package:flutter/material.dart';
import 'package:zent_fe/presentation/common/core/utils/tap_debounce.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/ui/account_header.dart';
import 'widgets/change_password_section.dart';
import 'widgets/recovery_email_section.dart';
import 'widgets/login_history_section.dart';
import 'package:zent_fe/presentation/admin/account/widgets/active_sessions_section.dart';
import 'package:provider/provider.dart';
import 'viewmodels/security_settings_viewmodel.dart';
import 'package:zent_fe/di/injection_container.dart' as di;

class SecuritySettingsScreen extends StatelessWidget {
  const SecuritySettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => di.sl<SecuritySettingsViewModel>(),
      child: const _SecuritySettingsScreenContent(),
    );
  }
}

class _SecuritySettingsScreenContent extends StatelessWidget {
  const _SecuritySettingsScreenContent();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SecuritySettingsViewModel>();

    return ThrottledGestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.background500,
        body: SafeArea(
          child: Column(
            children: [
              const AccountHeader(
                title: 'Security Settings',
                showDivider: true,
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppDimens.spaceMd),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const ChangePasswordSection(),
                      const SizedBox(height: AppDimens.spaceXl),
                      const RecoveryEmailSection(),
                      const SizedBox(height: AppDimens.spaceXl),
                      ActiveSessionsSection(
                        sessions: viewModel.activeSessions,
                        isLoading: viewModel.isLoadingSessions,
                        onRevoke: viewModel.revokeSession,
                        onRevokeAllOthers: viewModel.revokeAllOtherSessions,
                      ),
                      const SizedBox(height: AppDimens.spaceXl),
                      LoginHistorySection(
                        history: viewModel.loginHistory,
                        isLoading: viewModel.isLoadingHistory,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
