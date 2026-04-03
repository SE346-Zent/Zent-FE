import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zent_fe/di/injection_container.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/presentation/common/core/themes/boxshadow.dart';
import 'widgets/customer_text_field.dart';
import 'widgets/customer_dropdown_field.dart';
import 'viewmodels/request_service_viewmodel.dart';
import 'viewmodels/products_viewmodel.dart';

class RequestServiceReviewScreen extends StatefulWidget {
  const RequestServiceReviewScreen({super.key});

  @override
  State<RequestServiceReviewScreen> createState() =>
      _RequestServiceReviewScreenState();
}

class _RequestServiceReviewScreenState
    extends State<RequestServiceReviewScreen> {
  // Additional Info Controllers
  final TextEditingController symptomCtrl = TextEditingController();
  final TextEditingController ticketRefCtrl = TextEditingController();
  final TextEditingController descCtrl = TextEditingController();
  final TextEditingController appointmentCtrl = TextEditingController();

  // Contact Info Controllers
  final TextEditingController firstNameCtrl = TextEditingController();
  final TextEditingController lastNameCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController phoneCtrl = TextEditingController();

  // Address Info Controllers
  final TextEditingController addressCtrl = TextEditingController();
  final TextEditingController buildingCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    final vm = context.read<RequestServiceViewModel>();

    // Init values
    symptomCtrl.text = vm.symptom ?? '';
    ticketRefCtrl.text = vm.ticketRef ?? '';
    descCtrl.text = vm.description ?? '';
    appointmentCtrl.text = vm.appointmentDate ?? '';

    firstNameCtrl.text = vm.firstName ?? '';
    lastNameCtrl.text = vm.lastName ?? '';
    emailCtrl.text = vm.email ?? '';
    phoneCtrl.text = vm.phone ?? '';

    addressCtrl.text = vm.address ?? '';
    buildingCtrl.text = vm.building ?? '';
  }

  @override
  void dispose() {
    symptomCtrl.dispose();
    ticketRefCtrl.dispose();
    descCtrl.dispose();
    appointmentCtrl.dispose();
    firstNameCtrl.dispose();
    lastNameCtrl.dispose();
    emailCtrl.dispose();
    phoneCtrl.dispose();
    addressCtrl.dispose();
    buildingCtrl.dispose();
    super.dispose();
  }

  void _onToggleAdditionalInfo(RequestServiceViewModel vm) {
    if (vm.isEditingAdditionalInfo) {
      // Saving
      vm.saveInfo(
        symptomVal: symptomCtrl.text.isEmpty ? null : symptomCtrl.text,
        ticketRefVal: ticketRefCtrl.text.isEmpty ? null : ticketRefCtrl.text,
        descriptionVal: descCtrl.text.isEmpty ? null : descCtrl.text,
        appointmentDateVal: appointmentCtrl.text.isEmpty
            ? null
            : appointmentCtrl.text,
      );
    }
    vm.toggleEditSection('Additional Info');
  }

  void _onToggleContactInfo(RequestServiceViewModel vm) {
    if (vm.isEditingContact) {
      // Saving
      vm.saveContactInfo(
        firstNameVal: firstNameCtrl.text,
        lastNameVal: lastNameCtrl.text,
        emailVal: emailCtrl.text,
        phoneVal: phoneCtrl.text,
        countryVal: vm.country,
        stateVal: vm.state,
        cityVal: vm.city,
        addressVal: vm.address,
        buildingVal: vm.building,
      );
    }
    vm.toggleEditSection('Contact Info');
  }

  void _onToggleAddressInfo(RequestServiceViewModel vm) {
    if (vm.isEditingAddress) {
      // Saving (uses saveContactInfo but only updating address part is fine, keeping contact info same)
      vm.saveContactInfo(
        firstNameVal: vm.firstName,
        lastNameVal: vm.lastName,
        emailVal: vm.email,
        phoneVal: vm.phone,
        countryVal: vm.country,
        stateVal: vm.state,
        cityVal: vm.city,
        addressVal: addressCtrl.text,
        buildingVal: buildingCtrl.text,
      );
    }
    vm.toggleEditSection('Address');
  }

  void _onSubmit(RequestServiceViewModel vm) {
    vm.submitTicket(context);
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<RequestServiceViewModel>();
    final productsVM = sl<ProductsViewModel>();

    // Find the product
    final product = productsVM.products.firstWhere(
      (p) => p.serialNumber == viewModel.selectedSerialNumber,
      orElse: () => productsVM.products.first,
    );

    // Any currently editing section disables submit
    final bool isAnyEditing =
        viewModel.isEditingAdditionalInfo ||
        viewModel.isEditingContact ||
        viewModel.isEditingAddress;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimens.spaceMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step Indicator
          Text(
            'Step 4 of 5',
            style: TextStyles.bodyMedium.copyWith(color: AppColors.tertiary500),
          ),
          const SizedBox(height: AppDimens.spaceXs),
          Text(
            'Review Submission',
            style: TextStyles.display.copyWith(
              color: AppColors.primary500,
              fontSize: 32,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppDimens.spaceXs),
          Text(
            'Please review your ticket before submitting.',
            style: TextStyles.bodyLarge.copyWith(color: AppColors.secondary500),
          ),
          const SizedBox(height: AppDimens.spaceMd),

          // Product Card
          IntrinsicHeight(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surface200,
                borderRadius: BorderRadius.circular(AppDimens.boraMd),
                border: Border.all(color: AppColors.secondary100, width: 1),
                boxShadow: [BoxShadowStyles.subtle],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: 6,
                    decoration: const BoxDecoration(
                      color: AppColors.tertiary500,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(AppDimens.boraMd),
                        bottomLeft: Radius.circular(AppDimens.boraMd),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(AppDimens.spaceMd),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.serialNumber,
                            style: TextStyles.headline.copyWith(
                              color: AppColors.tertiary500,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            product.name,
                            style: TextStyles.bodyLarge.copyWith(
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Machine Type: abc12345',
                            style: TextStyles.bodyLarge.copyWith(
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 2),
                          RichText(
                            text: TextSpan(
                              text: 'Warranty Status: ',
                              style: TextStyles.bodyLarge.copyWith(
                                color: Colors.black,
                              ),
                              children: [
                                TextSpan(
                                  text: 'In warranty',
                                  style: TextStyles.bodyLarge.copyWith(
                                    color: AppColors.success500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppDimens.spaceMd),

          // Additional Info Section
          _buildSectionHeader(
            title: 'Additional Info',
            isEditing: viewModel.isEditingAdditionalInfo,
            onToggle: () => _onToggleAdditionalInfo(viewModel),
          ),
          _buildSectionContainer(
            isEditing: viewModel.isEditingAdditionalInfo,
            child: Column(
              children: [
                CustomerTextField(
                  label: 'Symptom',
                  hint: 'Select Category',
                  controller: symptomCtrl,
                  isRequired: true,
                  readOnly: !viewModel.isEditingAdditionalInfo,
                ),
                const SizedBox(height: AppDimens.spaceMd),
                CustomerTextField(
                  label: 'Ticket Reference Number',
                  hint: '',
                  controller: ticketRefCtrl,
                  readOnly: !viewModel.isEditingAdditionalInfo,
                ),
                const SizedBox(height: AppDimens.spaceMd),
                CustomerTextField(
                  label: 'Description',
                  hint: '',
                  controller: descCtrl,
                  readOnly: !viewModel.isEditingAdditionalInfo,
                  maxLines: 3,
                ),
                const SizedBox(height: AppDimens.spaceMd),
                CustomerTextField(
                  label: 'Appointment',
                  hint: 'Select a detailed appointment',
                  controller: appointmentCtrl,
                  isRequired: true,
                  readOnly: !viewModel.isEditingAdditionalInfo,
                  suffixIcon: IconButton(
                    icon: const Icon(
                      Icons.calendar_today,
                      color: AppColors.secondary500,
                    ),
                    onPressed: viewModel.isEditingAdditionalInfo
                        ? () {
                            viewModel.pickDate(context).then((_) {
                              appointmentCtrl.text =
                                  viewModel.appointmentDate ?? '';
                            });
                          }
                        : null,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimens.spaceXl),

          // Contact Info Section
          _buildSectionHeader(
            title: 'Contact Info',
            isEditing: viewModel.isEditingContact,
            onToggle: () => _onToggleContactInfo(viewModel),
          ),
          _buildSectionContainer(
            isEditing: viewModel.isEditingContact,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: CustomerTextField(
                        label: 'First Name',
                        hint: 'e.g Hung',
                        controller: firstNameCtrl,
                        isRequired: true,
                        readOnly: !viewModel.isEditingContact,
                      ),
                    ),
                    const SizedBox(width: AppDimens.spaceMd),
                    Expanded(
                      child: CustomerTextField(
                        label: 'Last Name',
                        hint: 'e.g dep zai',
                        controller: lastNameCtrl,
                        isRequired: true,
                        readOnly: !viewModel.isEditingContact,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimens.spaceMd),
                CustomerTextField(
                  label: 'Email',
                  hint: 'e.g example@gmail.com',
                  controller: emailCtrl,
                  readOnly: !viewModel.isEditingContact,
                ),
                const SizedBox(height: AppDimens.spaceMd),
                CustomerTextField(
                  label: 'Mobile Phone Number',
                  hint: 'e.g 0123456789',
                  controller: phoneCtrl,
                  keyboardType: TextInputType.phone,
                  readOnly: !viewModel.isEditingContact,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimens.spaceXl),

          // Address Info Section
          _buildSectionHeader(
            title: 'Select Address For Machine Location',
            isEditing: viewModel.isEditingAddress,
            onToggle: () => _onToggleAddressInfo(viewModel),
          ),
          _buildSectionContainer(
            isEditing: viewModel.isEditingAddress,
            child: Column(
              children: [
                CustomerDropdownField<String>(
                  label: 'Country/Region',
                  value: viewModel.country,
                  items: viewModel.countries
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (v) {
                    if (v != null) {
                      viewModel.country = v;
                      setState(() {});
                    }
                  },
                  isRequired: true,
                  readOnly: !viewModel.isEditingAddress,
                ),
                const SizedBox(height: AppDimens.spaceMd),
                CustomerDropdownField<String>(
                  label: 'State',
                  value: viewModel.state,
                  items: viewModel.states
                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
                  onChanged: (v) {
                    if (v != null) {
                      viewModel.updateState(v);
                    }
                  },
                  isRequired: true,
                  readOnly: !viewModel.isEditingAddress,
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
                  readOnly: !viewModel.isEditingAddress,
                ),
                const SizedBox(height: AppDimens.spaceMd),
                CustomerTextField(
                  label: 'Address',
                  hint: 'e.g. 100 đường Điện Biên Phủ',
                  controller: addressCtrl,
                  isRequired: true,
                  readOnly: !viewModel.isEditingAddress,
                ),
                const SizedBox(height: AppDimens.spaceMd),
                CustomerTextField(
                  label: 'Building/Floor/Room',
                  hint: 'e.g. Block A',
                  controller: buildingCtrl,
                  readOnly: !viewModel.isEditingAddress,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimens.spaceXl),
          _buildBottomBar(viewModel, !isAnyEditing),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required bool isEditing,
    required VoidCallback onToggle,
  }) {
    return Padding(
      padding: const EdgeInsets.only(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyles.headline.copyWith(
                color: AppColors.primary500,
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          IconButton(
            onPressed: onToggle,
            icon: Icon(
              isEditing ? Icons.check_circle_outline : Icons.edit_outlined,
              color: isEditing ? AppColors.success500 : AppColors.tertiary500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionContainer({
    required bool isEditing,
    required Widget child,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(vertical: AppDimens.spaceXs),
      child: child,
    );
  }

  Widget _buildBottomBar(RequestServiceViewModel viewModel, bool canSubmit) {
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
                  color: canSubmit
                      ? AppColors.tertiary500
                      : AppColors.secondary100,
                  borderRadius: BorderRadius.circular(AppDimens.boraSm),
                  boxShadow: canSubmit ? [BoxShadowStyles.glowing] : null,
                ),
                child: ElevatedButton(
                  onPressed: canSubmit ? () => _onSubmit(viewModel) : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimens.boraSm),
                    ),
                  ),
                  child: Text(
                    'Submit',
                    style: TextStyles.title.copyWith(
                      color: canSubmit
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
