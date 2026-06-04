import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zent_fe/di/injection_container.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/presentation/common/core/ui/account_header.dart';
import 'package:zent_fe/presentation/common/core/ui/user_avatar.dart';
import 'widgets/admin_text_field.dart';
import 'widgets/save_changes_button.dart';
import 'viewmodels/personal_info_viewmodel.dart';

class AdminPersonalInfoScreen extends StatelessWidget {
  const AdminPersonalInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => sl<AdminPersonalInfoViewModel>(),
      child: const _AdminPersonalInfoView(),
    );
  }
}

class _AdminPersonalInfoView extends StatefulWidget {
  const _AdminPersonalInfoView();

  @override
  State<_AdminPersonalInfoView> createState() => _AdminPersonalInfoViewState();
}

class _AdminPersonalInfoViewState extends State<_AdminPersonalInfoView> {
  late final TextEditingController _nameController;
  late final TextEditingController _adminIdController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    final vm = context.read<AdminPersonalInfoViewModel>();
    _nameController = TextEditingController(text: vm.fullName);
    _adminIdController = TextEditingController(text: vm.adminId);
    _emailController = TextEditingController(text: vm.email);
    _phoneController = TextEditingController(text: vm.phoneNumber);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _adminIdController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _syncControllersFromViewModel() {
    final vm = context.read<AdminPersonalInfoViewModel>();
    _setIfChanged(_nameController, vm.fullName);
    _setIfChanged(_adminIdController, vm.adminId);
    _setIfChanged(_emailController, vm.email);
    _setIfChanged(_phoneController, vm.phoneNumber);
  }

  void _setIfChanged(TextEditingController ctrl, String newValue) {
    if (ctrl.text != newValue) {
      ctrl.text = newValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AdminPersonalInfoViewModel>();

    // Sync controllers with async viewmodel data
    _syncControllersFromViewModel();

    return Scaffold(
      backgroundColor: AppColors.background500,
      body: SafeArea(
        child: Column(
          children: [
            const AccountHeader(title: 'Personal Info', showDivider: true),
            Expanded(
              child: viewModel.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(AppDimens.spaceMd),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          UserAvatar(
                            name: viewModel.fullName,
                            avatarUrl: viewModel.avatarUrl,
                            size: 80,
                          ),
                          const SizedBox(height: AppDimens.spaceMd),
                          Text(
                            viewModel.fullName,
                            style: TextStyles.display.copyWith(
                              color: Colors.black,
                              fontSize: 24,
                            ),
                          ),
                          Text(
                            'Administrator',
                            style: TextStyles.bodyMedium.copyWith(
                              color: AppColors.secondary500,
                            ),
                          ),
                          const SizedBox(height: AppDimens.spaceXl),
                          AdminTextField(
                            label: 'Full Name',
                            hint: 'Enter your name',
                            controller: _nameController,
                            prefixIcon: Icons.person_outline,
                          ),
                          const SizedBox(height: AppDimens.spaceSm),
                          AdminTextField(
                            label: 'Admin ID',
                            hint: 'Enter your admin ID',
                            controller: _adminIdController,
                            readOnly: true,
                            prefixIcon: Icons.work_outline,
                            suffixIcon: Icons.lock,
                          ),
                          const SizedBox(height: AppDimens.spaceSm),
                          AdminTextField(
                            label: 'Email Address',
                            hint: 'Enter your email address',
                            controller: _emailController,
                            prefixIcon: Icons.email_outlined,
                          ),
                          const SizedBox(height: AppDimens.spaceSm),
                          AdminTextField(
                            label: 'Phone Number',
                            hint: 'Enter your phone number',
                            controller: _phoneController,
                            prefixIcon: Icons.phone_outlined,
                          ),
                          const SizedBox(height: AppDimens.spaceXl),
                          SaveChangesButton(
                            onPressed: () async {
                              viewModel.fullName = _nameController.text.trim();
                              viewModel.email = _emailController.text.trim();
                              viewModel.phoneNumber = _phoneController.text
                                  .trim();

                              final success = await viewModel.saveChanges(
                                context,
                              );
                              if (success && context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Profile updated successfully',
                                    ),
                                    backgroundColor: AppColors.success500,
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
