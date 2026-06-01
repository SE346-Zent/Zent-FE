import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zent_fe/di/injection_container.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/presentation/common/core/themes/boxshadow.dart';
import 'package:go_router/go_router.dart';
import '../account/widgets/customer_app_bar.dart';
import 'widgets/customer_text_field.dart';
import 'widgets/customer_dropdown_field.dart';
import 'viewmodels/device_registration_viewmodel.dart';
import 'package:zent_fe/presentation/common/core/ui/zent_error_popup.dart';

class DeviceRegistrationScreen extends StatelessWidget {
  const DeviceRegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => sl<DeviceRegistrationViewModel>(),
      child: const _DeviceRegistrationView(),
    );
  }
}

class _DeviceRegistrationView extends StatelessWidget {
  const _DeviceRegistrationView();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<DeviceRegistrationViewModel>();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.surface100,
        appBar: const CustomerAppBar(
          title: 'Device Registration',
          showBackButton: true,
          showBottomDivider: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimens.spaceMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- STEP 1 ---
              Text(
                '1/ Select a Device',
                style: TextStyles.headline.copyWith(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppDimens.spaceMd),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        boxShadow: [BoxShadowStyles.subtle],
                        borderRadius: BorderRadius.circular(AppDimens.boraSm),
                      ),
                      child: TextField(
                        controller: viewModel.serialController,
                        decoration: InputDecoration(
                          hintText: 'Enter Serial Number',
                          hintStyle: TextStyles.bodyMedium.copyWith(
                            color: AppColors.secondary400,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              AppDimens.boraSm,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppDimens.spaceMd),
                  Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.tertiary500,
                      borderRadius: BorderRadius.circular(AppDimens.boraSm),
                      boxShadow: [BoxShadowStyles.glowing],
                    ),
                    child: ElevatedButton(
                      onPressed: viewModel.isCheckingWarranty
                          ? null
                          : viewModel.submitDevice,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppDimens.boraSm),
                        ),
                      ),
                      child: viewModel.isCheckingWarranty
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              'Submit',
                              style: TextStyles.title.copyWith(
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
              if (viewModel.warrantyMessage != null) ...[
                const SizedBox(height: AppDimens.spaceSm),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimens.spaceXs,
                  ),
                  child: Text(
                    viewModel.warrantyMessage!,
                    style: TextStyles.bodyMedium.copyWith(
                      color: viewModel.warrantyMessage == 'Expired'
                          ? AppColors.warning500
                          : (viewModel.isStep2Enabled
                                ? AppColors.success500
                                : AppColors.error500),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: AppDimens.spaceXl),

              InkWell(
                onTap: viewModel.toggleStep2,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '2/ Contact Information',
                      style: TextStyles.headline.copyWith(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: viewModel.isStep2Enabled
                            ? Colors.black
                            : AppColors.secondary300,
                      ),
                    ),
                    Icon(
                      viewModel.isStep2Expanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: viewModel.isStep2Enabled
                          ? Colors.black
                          : AppColors.secondary300,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppDimens.spaceMd),

              AnimatedCrossFade(
                firstChild: const SizedBox(width: double.infinity, height: 0),
                secondChild: _buildStep2Form(viewModel, context),
                crossFadeState: viewModel.isStep2Expanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 300),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStep2Form(
    DeviceRegistrationViewModel viewModel,
    BuildContext context,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Device Location',
          style: TextStyles.title.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: AppDimens.spaceMd),

        CustomerTextField(
          label: 'Country/Region',
          hint: '',
          controller: viewModel.countryCtrl,
          isRequired: true,
          readOnly: true,
        ),
        const SizedBox(height: AppDimens.spaceMd),
        CustomerDropdownField<String>(
          label: 'Province',
          value: viewModel.stateVal,
          items: viewModel.states
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: viewModel.onStateChanged,
          isRequired: true,
        ),
        const SizedBox(height: AppDimens.spaceMd),
        CustomerDropdownField<String>(
          label: 'Ward',
          value: viewModel.cityVal,
          items: viewModel.cities
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: viewModel.onCityChanged,
          isRequired: true,
        ),
        const SizedBox(height: AppDimens.spaceMd),
        CustomerTextField(
          label: 'Address',
          hint: 'e.g. 100 đường Điện Biên Phủ',
          controller: viewModel.addressCtrl,
          isRequired: true,
        ),
        const SizedBox(height: AppDimens.spaceLg),

        Text(
          'Contact Information',
          style: TextStyles.title.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: AppDimens.spaceMd),
        Row(
          children: [
            Expanded(
              child: CustomerTextField(
                label: 'First Name',
                hint: 'e.g Hung',
                controller: viewModel.firstNameCtrl,
                isRequired: true,
              ),
            ),
            const SizedBox(width: AppDimens.spaceMd),
            Expanded(
              child: CustomerTextField(
                label: 'Last Name',
                hint: 'e.g dep zai',
                controller: viewModel.lastNameCtrl,
                isRequired: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimens.spaceMd),
        CustomerTextField(
          label: 'Email',
          hint: 'e.g example@gmail.com',
          controller: viewModel.emailCtrl,
          isRequired: true,
        ),
        const SizedBox(height: AppDimens.spaceMd),
        CustomerTextField(
          label: 'Mobile Phone Number',
          hint: 'e.g 0123456789',
          controller: viewModel.phoneCtrl,
          isRequired: true,
        ),
        const SizedBox(height: AppDimens.spaceLg),

        Text(
          'Email Confirmation',
          style: TextStyles.title.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: AppDimens.spaceXs),
        Row(
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: Checkbox(
                value: viewModel.sendConfirmationEmail,
                onChanged: viewModel.toggleCheckbox,
                activeColor: AppColors.tertiary500,
              ),
            ),
            const SizedBox(width: AppDimens.spaceSm),
            Text(
              'Send registration confirmation to device owner',
              style: TextStyles.label,
            ),
          ],
        ),
        const SizedBox(height: AppDimens.spaceXl),

        // Bottom Buttons
        Row(
          children: [
            Expanded(
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.surface600,
                  borderRadius: BorderRadius.circular(AppDimens.boraSm),
                  boxShadow: [BoxShadowStyles.subtle],
                ),
                child: ElevatedButton(
                  onPressed: () => context.pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimens.boraSm),
                    ),
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyles.title.copyWith(
                      color: AppColors.secondary500,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppDimens.spaceMd),
            Expanded(
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.tertiary500,
                  borderRadius: BorderRadius.circular(AppDimens.boraSm),
                  boxShadow: [BoxShadowStyles.glowing],
                ),
                child: ElevatedButton(
                  onPressed: () async {
                    final success = await viewModel.submitRegistration();
                    if (success && context.mounted) {
                      context.pop(true);
                    } else if (context.mounted && viewModel.errorMessage != null) {
                      ZentErrorPopup.show(context, viewModel.errorMessage!);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimens.boraSm),
                    ),
                  ),
                  child: viewModel.isRegistering
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          'Register',
                          style: TextStyles.title.copyWith(color: Colors.white),
                        ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
