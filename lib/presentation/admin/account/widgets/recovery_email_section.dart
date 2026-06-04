import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'admin_text_field.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/presentation/admin/account/viewmodels/security_settings_viewmodel.dart';

/// Admin recovery email section – 2-step flow:
/// 1. User enters recovery email + current password → sends OTP
/// 2. User enters 6-digit OTP → confirms
class RecoveryEmailSection extends StatefulWidget {
  const RecoveryEmailSection({super.key});

  @override
  State<RecoveryEmailSection> createState() => _RecoveryEmailSectionState();
}

class _RecoveryEmailSectionState extends State<RecoveryEmailSection> {
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _otpCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _otpCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SecuritySettingsViewModel>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Row(
            children: [
              const Icon(
                Icons.mark_email_read_outlined,
                color: AppColors.tertiary500,
                size: 24.0,
              ),
              const SizedBox(width: AppDimens.spaceSm),
              Text(
                'Recovery Email',
                style: TextStyles.title.copyWith(color: AppColors.primary500),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(AppDimens.spaceMd),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppDimens.boraMd),
            border: Border.all(color: AppColors.secondary100),
          ),
          child: _buildContent(context, viewModel),
        ),
      ],
    );
  }

  Widget _buildContent(
    BuildContext context,
    SecuritySettingsViewModel viewModel,
  ) {
    if (viewModel.recoveryStep == RecoveryEmailStep.done) {
      return Row(
        children: [
          const Icon(Icons.check_circle, color: AppColors.tertiary500),
          const SizedBox(width: AppDimens.spaceSm),
          Text(
            'Recovery email verified!',
            style: TextStyles.bodyLarge.copyWith(color: AppColors.tertiary500),
          ),
          const Spacer(),
          TextButton(
            onPressed: viewModel.resetRecoveryFlow,
            child: const Text('Change'),
          ),
        ],
      );
    }

    if (viewModel.recoveryStep == RecoveryEmailStep.awaitingOtp) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Enter the 6-digit OTP sent to your recovery email.',
            style: TextStyles.bodyMedium.copyWith(
              color: AppColors.secondary400,
            ),
          ),
          const SizedBox(height: AppDimens.spaceMd),
          AdminTextField(
            controller: _otpCtrl,
            hint: '123456',
            keyboardType: TextInputType.number,
          ),
          if (viewModel.recoveryError != null) ...[
            const SizedBox(height: AppDimens.spaceSm),
            Text(
              viewModel.recoveryError!,
              style: TextStyles.label.copyWith(color: Colors.red),
            ),
          ],
          const SizedBox(height: AppDimens.spaceMd),
          Row(
            children: [
              TextButton(
                onPressed: viewModel.isRecoveryLoading
                    ? null
                    : viewModel.resetRecoveryFlow,
                child: const Text('Back'),
              ),
              const Spacer(),
              FilledButton(
                onPressed: viewModel.isRecoveryLoading
                    ? null
                    : () => viewModel.verifyRecoveryOtp(
                        context: context,
                        otpCode: _otpCtrl.text.trim(),
                      ),
                child: viewModel.isRecoveryLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Verify OTP'),
              ),
            ],
          ),
        ],
      );
    }

    // idle
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Update recovery email address',
          style: TextStyles.label.copyWith(color: AppColors.secondary400),
        ),
        const SizedBox(height: AppDimens.spaceXs),
        AdminTextField(
          controller: _emailCtrl,
          hint: 'name@gmail.com',
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: AppDimens.spaceMd),
        Text(
          'Confirm with your current password',
          style: TextStyles.label.copyWith(color: AppColors.secondary400),
        ),
        const SizedBox(height: AppDimens.spaceXs),
        AdminTextField(
          controller: _passwordCtrl,
          hint: '••••••••',
          obscureText: true,
        ),
        if (viewModel.recoveryError != null) ...[
          const SizedBox(height: AppDimens.spaceSm),
          Text(
            viewModel.recoveryError!,
            style: TextStyles.label.copyWith(color: Colors.red),
          ),
        ],
        const SizedBox(height: AppDimens.spaceMd),
        Align(
          alignment: Alignment.centerRight,
          child: FilledButton(
            onPressed: viewModel.isRecoveryLoading
                ? null
                : () => viewModel.requestRecoveryEmailOtp(
                    context: context,
                    recoveryEmail: _emailCtrl.text.trim(),
                    password: _passwordCtrl.text,
                  ),
            child: viewModel.isRecoveryLoading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text('Set Recovery Email'),
          ),
        ),
      ],
    );
  }
}
