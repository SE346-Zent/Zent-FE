import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/ui/account_header.dart';
import 'package:zent_fe/presentation/customer/account/viewmodels/personal_info_viewmodel.dart';
import 'package:zent_fe/presentation/customer/account/widgets/personal_info_avatar_group.dart';
import 'package:zent_fe/presentation/customer/account/widgets/personal_info_fields.dart';
import 'package:zent_fe/presentation/customer/account/widgets/personal_info_save_button.dart';
import 'package:zent_fe/di/injection_container.dart' as di;

class CustomerPersonalInfoScreen extends StatelessWidget {
  const CustomerPersonalInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => di.sl<PersonalInfoViewModel>(),
      child: const _PersonalInfoScreenContent(),
    );
  }
}

class _PersonalInfoScreenContent extends StatelessWidget {
  const _PersonalInfoScreenContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background500,
      body: SafeArea(
        child: Column(
          children: [
            const AccountHeader(title: 'Personal Info', showDivider: true),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 0,
                  vertical: AppDimens.spaceMd,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Consumer<PersonalInfoViewModel>(
                      builder: (context, viewModel, _) =>
                          PersonalInfoAvatarGroup(
                            fullName: viewModel.fullName,
                            email: viewModel.emailAddress,
                          ),
                    ),
                    const SizedBox(height: AppDimens.spaceXl),
                    const PersonalInfoFields(),
                    const SizedBox(height: AppDimens.spaceXl),
                    const PersonalInfoSaveButton(),
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
