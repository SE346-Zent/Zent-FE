import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Core Dependency Injection
import 'package:zent_fe/di/injection_container.dart';

// Core Theming
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';

// Shared Tech Components
import 'widgets/tech_app_bar.dart';
import 'widgets/tech_text_field.dart';
import 'widgets/tech_primary_button.dart';

// Feature-specific Widgets
import 'widgets/profile_avatar.dart';

// ViewModel
import 'viewmodels/personal_info_viewmodel.dart';

class TechPersonalInfoScreen extends StatelessWidget {
  const TechPersonalInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => sl<TechPersonalInfoViewModel>(),
      child: const _TechPersonalInfoView(),
    );
  }
}

class _TechPersonalInfoView extends StatefulWidget {
  const _TechPersonalInfoView();

  @override
  State<_TechPersonalInfoView> createState() => _TechPersonalInfoViewState();
}

class _TechPersonalInfoViewState extends State<_TechPersonalInfoView> {
  late final TextEditingController _nameController;
  late final TextEditingController _employeeIdController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    final vm = context.read<TechPersonalInfoViewModel>();
    _nameController = TextEditingController(text: vm.fullName);
    _employeeIdController = TextEditingController(text: vm.employeeId);
    _emailController = TextEditingController(text: vm.email);
    _phoneController = TextEditingController(text: vm.phoneNumber);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _employeeIdController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _syncControllersFromViewModel() {
    final vm = context.read<TechPersonalInfoViewModel>();
    _setIfChanged(_nameController, vm.fullName);
    _setIfChanged(_employeeIdController, vm.employeeId);
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
    final viewModel = context.watch<TechPersonalInfoViewModel>();

    // Sync controllers with async viewmodel data
    _syncControllersFromViewModel();

    return Scaffold(
      backgroundColor: AppColors.background500,

      appBar: const TechAppBar(title: 'Personal Info', showBackButton: true),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimens.spaceMd),
          child: Column(
            children: [
              ProfileAvatar(name: viewModel.fullName),
              const SizedBox(height: AppDimens.spaceMd),

              Text(
                viewModel.fullName,
                style: TextStyles.display.copyWith(
                  color: Colors.black,
                  fontSize: 24,
                ),
              ),
              Text(
                'Senior electrician',
                style: TextStyles.bodyMedium.copyWith(
                  color: AppColors.secondary500,
                ),
              ),

              const SizedBox(height: AppDimens.spaceXl),

              TechTextField(
                label: 'Full name',
                hint: 'Enter your name',
                controller: _nameController,
                prefixIcon: Icons.person_outline,
              ),
              const SizedBox(height: AppDimens.spaceSm),

              TechTextField(
                label: 'Employee ID',
                hint: 'Enter your employee ID',
                controller: _employeeIdController,
                readOnly: true,
                prefixIcon: Icons.work_outline,
                suffixIcon: Icons.lock,
              ),

              const SizedBox(height: AppDimens.spaceSm),

              TechTextField(
                label: 'Email Address',
                hint: 'Enter your email address',
                controller: _emailController,
                prefixIcon: Icons.email_outlined,
              ),
              const SizedBox(height: AppDimens.spaceSm),

              TechTextField(
                label: 'Phone number',
                hint: 'Enter your phone number',
                controller: _phoneController,
                prefixIcon: Icons.phone_outlined,
              ),
              const SizedBox(height: AppDimens.spaceXl),

              TechPrimaryButton(
                text: 'Save Changes',
                icon: Icons.topic_outlined,
                onPressed: () {
                  context.read<TechPersonalInfoViewModel>().saveChanges(
                    context,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
