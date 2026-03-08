import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../common/core/themes/colors.dart';
import '../../common/core/themes/dimens.dart';
import 'viewmodel/company_settings_viewmodel.dart';
import 'widgets/account_header.dart';
import 'widgets/company_avatar_block.dart';
import 'widgets/company_info_block.dart';
import 'widgets/company_input_form.dart';
import 'widgets/company_save_button.dart';

class CompanySettingsScreen extends StatelessWidget {
  const CompanySettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CompanySettingsViewModel>();

    return Scaffold(
      backgroundColor: AppColors.background500,
      body: SafeArea(
        child: Column(
          children: [
            const AccountHeader(title: 'Company Settings'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.spaceMd,
                  vertical: AppDimens.spaceLg,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CompanyAvatarBlock(
                      avatarUrl: viewModel.avatarUrl,
                      onEditTap: () => viewModel.editAvatar(),
                    ),
                    const SizedBox(height: AppDimens.spaceLg),
                    CompanyInfoBlock(info: viewModel.companyInfo),
                    const SizedBox(height: AppDimens.spaceXl),
                    CompanyInputForm(
                      companyName: viewModel.inputData.companyName,
                      taxId: viewModel.inputData.taxId,
                      primaryAddress: viewModel.inputData.primaryAddress,
                      contactPerson: viewModel.inputData.contactPerson,
                    ),
                    const SizedBox(height: 48.0), // Spacing before button
                  ],
                ),
              ),
            ),
            CompanySaveButton(
              onPressed: () =>
                  context.read<CompanySettingsViewModel>().updateCompanyInfo(),
            ),
          ],
        ),
      ),
    );
  }
}
