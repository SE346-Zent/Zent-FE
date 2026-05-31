import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../presentation/common/core/themes/colors.dart';
import '../../../../presentation/common/core/themes/dimens.dart';
import '../../../../presentation/common/core/themes/text_styles.dart';
import '../../../../presentation/common/core/themes/boxshadow.dart';
import 'widgets/customer_text_field.dart';
import 'widgets/customer_dropdown_field.dart';
import 'viewmodels/request_service_viewmodel.dart';

class RequestServiceContactScreen extends StatefulWidget {
  const RequestServiceContactScreen({super.key});

  @override
  State<RequestServiceContactScreen> createState() =>
      _RequestServiceContactScreenState();
}

class _RequestServiceContactScreenState
    extends State<RequestServiceContactScreen> {
  final TextEditingController firstNameCtrl = TextEditingController();
  final TextEditingController lastNameCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController phoneCtrl = TextEditingController();
  final TextEditingController addressCtrl = TextEditingController();
  final TextEditingController buildingCtrl = TextEditingController();

  bool get isNextEnabled {
    final vm = context.read<RequestServiceViewModel>();
    return firstNameCtrl.text.isNotEmpty &&
        lastNameCtrl.text.isNotEmpty &&
        vm.country != null &&
        vm.ward != null &&
        vm.city != null &&
        addressCtrl.text.isNotEmpty;
  }

  @override
  void initState() {
    super.initState();
    final vm = context.read<RequestServiceViewModel>();
    vm.initContactInfo();

    firstNameCtrl.text = vm.firstName ?? '';
    lastNameCtrl.text = vm.lastName ?? '';
    emailCtrl.text = vm.email ?? '';
    phoneCtrl.text = vm.phone ?? '';
    addressCtrl.text = vm.address ?? '';
    buildingCtrl.text = vm.building ?? '';

    firstNameCtrl.addListener(_onTextChanged);
    lastNameCtrl.addListener(_onTextChanged);
    emailCtrl.addListener(_onTextChanged);
    addressCtrl.addListener(_onTextChanged);
  }

  void _onTextChanged() => setState(() {});

  @override
  void dispose() {
    firstNameCtrl.dispose();
    lastNameCtrl.dispose();
    emailCtrl.dispose();
    phoneCtrl.dispose();
    addressCtrl.dispose();
    buildingCtrl.dispose();
    super.dispose();
  }

  void _onNext(RequestServiceViewModel viewModel) {
    viewModel.saveContactInfo(
      firstNameVal: firstNameCtrl.text,
      lastNameVal: lastNameCtrl.text,
      emailVal: emailCtrl.text,
      phoneVal: phoneCtrl.text,
      countryVal: viewModel.country,
      wardVal: viewModel.ward,
      cityVal: viewModel.city,
      addressVal: addressCtrl.text,
      buildingVal: buildingCtrl.text,
    );
    viewModel.nextStep(); // We assume step 4 will exist
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<RequestServiceViewModel>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimens.spaceMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step Indicator
          Text(
            'Step 3 of 5',
            style: TextStyles.bodyMedium.copyWith(color: AppColors.tertiary500),
          ),
          const SizedBox(height: AppDimens.spaceXs),
          Text(
            'Contact Details',
            style: TextStyles.display.copyWith(
              color: AppColors.primary500,
              fontSize: 32,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppDimens.spaceXs),
          Text(
            'Please provide your contact information and machine location.',
            style: TextStyles.bodyLarge.copyWith(color: AppColors.secondary500),
          ),
          const SizedBox(height: AppDimens.spaceMd),

          Text(
            'Enter Contact Info',
            style: TextStyles.headline.copyWith(
              color: AppColors.primary500,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppDimens.spaceMd),

          Row(
            children: [
              Expanded(
                child: CustomerTextField(
                  label: 'First Name',
                  hint: 'e.g Hung',
                  controller: firstNameCtrl,
                  isRequired: true,
                ),
              ),
              const SizedBox(width: AppDimens.spaceLg),
              Expanded(
                child: CustomerTextField(
                  label: 'Last Name',
                  hint: 'e.g dep zai',
                  controller: lastNameCtrl,
                  isRequired: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimens.spaceMd),

          CustomerTextField(
            label: 'Email',
            hint: 'e.g example@gmail.com',
            controller: emailCtrl,
          ),
          const SizedBox(height: AppDimens.spaceMd),

          CustomerTextField(
            label: 'Mobile Phone Number',
            hint: 'e.g 0123456789',
            controller: phoneCtrl,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: AppDimens.spaceXl),

          Text(
            'Select Address For Machine Location',
            style: TextStyles.headline.copyWith(
              color: AppColors.primary500,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppDimens.spaceMd),

          CustomerDropdownField<String>(
            label: 'Country/Region',
            value: viewModel.country,
            items: viewModel.countries
                .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                .toList(),
            onChanged: (v) {
              if (v != null) {
                viewModel.saveContactInfo(
                  countryVal: v,
                  wardVal: viewModel.ward,
                  cityVal: viewModel.city,
                );
              }
            },
            isRequired: true,
          ),
          const SizedBox(height: AppDimens.spaceMd),

          CustomerDropdownField<String>(
            label: 'Ward',
            value: viewModel.ward,
            items: viewModel.wards
                .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                .toList(),
            onChanged: (v) {
              if (v != null) {
                viewModel.updateWard(v);
              }
            },
            isRequired: true,
          ),
          const SizedBox(height: AppDimens.spaceMd),

          CustomerDropdownField<String>(
            label: 'City',
            value: viewModel.city,
            items: viewModel.availableCities
                .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                .toList(),
            onChanged: (v) {
              if (v != null) {
                viewModel.updateCity(v);
              }
            },
            isRequired: true,
          ),
          const SizedBox(height: AppDimens.spaceMd),

          CustomerTextField(
            label: 'Address',
            hint: 'e.g. 100 đường Điện Biên Phủ',
            controller: addressCtrl,
            isRequired: true,
          ),
          const SizedBox(height: AppDimens.spaceMd),

          CustomerTextField(
            label: 'Building/Floor/Room',
            hint: 'e.g. Block A',
            controller: buildingCtrl,
          ),
          const SizedBox(height: AppDimens.spaceMd),
          _buildBottomBar(viewModel),
        ],
      ),
    );
  }

  Widget _buildBottomBar(RequestServiceViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.only(top: AppDimens.spaceMd),
      child: SafeArea(
        top: false,
        child: Row(
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
                  onPressed: () => viewModel.previousStep(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimens.boraSm),
                    ),
                  ),
                  child: Text(
                    'Back',
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
                  color: isNextEnabled
                      ? AppColors.tertiary500
                      : AppColors.secondary100,
                  borderRadius: BorderRadius.circular(AppDimens.boraSm),
                  boxShadow: isNextEnabled ? [BoxShadowStyles.glowing] : null,
                ),
                child: ElevatedButton(
                  onPressed: isNextEnabled ? () => _onNext(viewModel) : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimens.boraSm),
                    ),
                  ),
                  child: Text(
                    'Next',
                    style: TextStyles.title.copyWith(
                      color: isNextEnabled
                          ? AppColors.surface50
                          : AppColors.secondary400,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
