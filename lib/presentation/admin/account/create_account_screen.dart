import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/presentation/common/core/themes/boxshadow.dart';
import 'package:zent_fe/presentation/common/auth/login/widgets/zent_bottom_logo.dart';
import 'package:zent_fe/di/injection_container.dart' as di;

import 'widgets/admin_text_field.dart';
import 'viewmodel/create_account_viewmodel.dart';

class CreateAccountScreen extends StatelessWidget {
  final String role;
  const CreateAccountScreen({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => di.sl<CreateAccountViewModel>()..initRole(role),
      child: const _CreateAccountScreenContent(),
    );
  }
}

class _CreateAccountScreenContent extends StatelessWidget {
  const _CreateAccountScreenContent();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CreateAccountViewModel>();
    final isTech = viewModel.basicRole == 'Technicians';
    final titleText = isTech ? 'Create Technician' : 'Create Admin';
    final infoTitle = isTech ? 'Technician Information' : 'Admin Information';
    final accountTypeTarget = isTech ? 'technician' : 'admin';

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.background500,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.primary500),
            onPressed: () => context.pop(),
          ),
          title: Text(
            titleText,
            style: TextStyles.headline.copyWith(color: AppColors.primary500),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimens.spaceLg,
                    vertical: 16.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        infoTitle,
                        style: TextStyles.title.copyWith(
                          color: AppColors.primary500,
                        ),
                      ),
                      const SizedBox(height: AppDimens.spaceSm),
                      RichText(
                        text: TextSpan(
                          style: TextStyles.bodyMedium.copyWith(
                            color: AppColors.secondary500,
                          ),
                          children: [
                            TextSpan(
                              text:
                                  'Fill in the details below to add a new $accountTypeTarget to the ',
                            ),
                            TextSpan(
                              text: 'Zent',
                              style: TextStyles.bodyMedium.copyWith(
                                color: AppColors.tertiary500,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const TextSpan(text: ' network.'),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppDimens.spaceXl),
                      AdminTextField(
                        label: 'Full Name',
                        hint: 'hung dep zai',
                        controller: viewModel.fullNameController,
                      ),
                      const SizedBox(height: AppDimens.spaceLg),
                      AdminTextField(
                        label: 'Email Address',
                        hint: 'name@gmail.com',
                        controller: viewModel.emailController,
                      ),
                      const SizedBox(height: AppDimens.spaceLg),
                      AdminTextField(
                        label: 'Phone Number',
                        hint: '01234567',
                        controller: viewModel.phoneController,
                      ),
                      if (isTech) ...[
                        const SizedBox(height: AppDimens.spaceLg),
                        Padding(
                          padding: const EdgeInsets.only(
                            bottom: AppDimens.spaceXs,
                            left: AppDimens.spaceXs,
                          ),
                          child: Text(
                            'Specific Role',
                            style: TextStyles.title.copyWith(
                              color: AppColors.primary500,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppDimens.spaceSm,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surface100,
                            borderRadius: BorderRadius.circular(
                              AppDimens.boraMd,
                            ),
                            border: Border.all(
                              color: AppColors.secondary100,
                              width: 1.0,
                            ),
                            boxShadow: [BoxShadowStyles.subtle],
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: viewModel.selectedSpecificRole,
                              isExpanded: true,
                              hint: Text(
                                'Select a role',
                                style: TextStyles.bodyLarge.copyWith(
                                  color: AppColors.secondary200,
                                ),
                              ),
                              icon: const Icon(
                                Icons.keyboard_arrow_down,
                                color: AppColors.secondary400,
                              ),
                              items: viewModel.technicalRoles.map((
                                String value,
                              ) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: TextStyles.bodyLarge.copyWith(
                                      color: AppColors.primary500,
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: viewModel.setSpecificRole,
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 48.0),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.tertiary500,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [BoxShadowStyles.subtle],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(8),
                            onTap: () {
                              context.pop();
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 16.0,
                              ),
                              child: Center(
                                child: Text(
                                  titleText,
                                  style: TextStyles.title.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppDimens.spaceXl),
                    ],
                  ),
                ),
              ),
              const ZentBottomLogo(),
            ],
          ),
        ),
      ),
    );
  }
}
