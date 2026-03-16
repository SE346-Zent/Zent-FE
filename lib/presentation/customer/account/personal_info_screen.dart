import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zent_fe/presentation/admin/account/widgets/save_changes_button.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/ui/account_header.dart';
import 'package:zent_fe/presentation/common/core/ui/avatar.dart';
import 'package:zent_fe/presentation/common/core/ui/input_field.dart';
import 'package:zent_fe/presentation/customer/account/viewmodels/personal_info_viewmodel.dart';
import 'package:zent_fe/presentation/customer/account/widgets/profile_user_info.dart';

class CustomerPersonalInfoScreen extends StatelessWidget {
  const CustomerPersonalInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PersonalInfoViewModel(),
      child: const _PersonalInfoScreenContent(),
    );
  }
}

class _PersonalInfoScreenContent extends StatelessWidget {
  const _PersonalInfoScreenContent();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<PersonalInfoViewModel>();

    return Scaffold(
      backgroundColor: AppColors.background500,
      body: SafeArea(
        child: Column(
          children: [
            const AccountHeader(
              title: 'Personal Info',
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.spaceMd,
                  vertical: AppDimens.spaceMd,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Avatar(name: viewModel.fullName),
                    const SizedBox(height: AppDimens.spaceMd),
                    ProfileUserInfo(
                      name: viewModel.fullName,
                      role: 'Senior electrician', // Could also be fetched from another viewModel if needed
                    ),
                    const SizedBox(height: AppDimens.spaceXl),
                    
                    InputField(
                      label: 'Full Name',
                      initialValue: viewModel.fullName,
                      leadingIcon: Icons.person_outline,
                      onChanged: (val) => context.read<PersonalInfoViewModel>().updateFullName(val),
                    ),
                    const SizedBox(height: AppDimens.spaceMd),
                    
                    InputField(
                      label: 'Employee ID',
                      initialValue: viewModel.employeeId,
                      leadingIcon: Icons.work_outline,
                      isReadOnly: true,
                    ),
                    const SizedBox(height: AppDimens.spaceMd),

                    InputField(
                      label: 'Email Address',
                      initialValue: viewModel.emailAddress,
                      leadingIcon: Icons.mail_outline,
                      onChanged: (val) => context.read<PersonalInfoViewModel>().updateEmail(val),
                    ),
                    const SizedBox(height: AppDimens.spaceMd),

                    InputField(
                      label: 'Phone Number',
                      initialValue: viewModel.phoneNumber,
                      leadingIcon: Icons.phone_outlined,
                      onChanged: (val) => context.read<PersonalInfoViewModel>().updatePhone(val),
                    ),
                    const SizedBox(height: AppDimens.spaceXl),

                    SaveChangesButton(
                      onPressed: () {
                        context.read<PersonalInfoViewModel>().saveChanges();
                        debugPrint("action triggered: save personal info changes");
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
