import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Themes
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';

// Widgets
import 'tech_app_bar.dart';
import 'tech_text_field.dart';
import 'tech_primary_button.dart';
import 'profile_avatar.dart';

// ViewModel
import '../view_models/personal_info_viewmodel.dart';

class PersonalInfoView extends StatefulWidget {
  const PersonalInfoView({super.key});

  @override
  State<PersonalInfoView> createState() => _PersonalInfoViewState();
}

class _PersonalInfoViewState extends State<PersonalInfoView> {
  late final TextEditingController _nameController;
  late final TextEditingController _employeeIdController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: 'Hung dep zai');
    _employeeIdController = TextEditingController(text: 'TECH-1234');
    _emailController = TextEditingController(text: 'hungdepzai@zent.com');
    _phoneController = TextEditingController(text: '12355678');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _employeeIdController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<TechPersonalInfoViewModel>();

    return Scaffold(
      backgroundColor: AppColors.background500,

      appBar: const TechAppBar(title: 'Personal Info', showBackButton: true),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimens.spaceMd),
          child: Column(
            children: [
              ProfileAvatar(name: viewModel.fullName),
              const SizedBox(height: AppDimens.spaceSm),

              Text(
                'Hung dep zai',
                style: TextStyles.display.copyWith(
                  color: Colors.black,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 4.0),
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
              const SizedBox(height: AppDimens.spaceLg),

              TechTextField(
                label: 'Employee ID',
                hint: 'Enter your employee ID',
                controller: _employeeIdController,
                readOnly: true,
                prefixIcon: Icons.work_outline,
                suffixIcon: Icons.lock,
              ),

              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 4.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Contact admin to change your Employee ID',
                    style: TextStyles.bodyMedium.copyWith(
                      color: AppColors.secondary500,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: AppDimens.spaceMd),

              TechTextField(
                label: 'Email Address',
                hint: 'Enter your email address',
                controller: _emailController,
                prefixIcon: Icons.email_outlined,
              ),
              const SizedBox(height: AppDimens.spaceLg),

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
                  debugPrint('Đã bấm nút Save Changes!');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
