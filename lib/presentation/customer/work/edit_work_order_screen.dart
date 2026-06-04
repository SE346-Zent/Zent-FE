import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:zent_fe/di/injection_container.dart' as di;
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/presentation/common/core/themes/boxshadow.dart';
import 'package:zent_fe/presentation/customer/account/widgets/customer_app_bar.dart';
import 'viewmodels/edit_work_order_viewmodel.dart';
import 'widgets/customer_text_field.dart';
import 'widgets/customer_dropdown_field.dart';
import 'widgets/appointment_mask.dart';

class EditWorkOrderScreen extends StatefulWidget {
  final String workOrderId;
  final String workOrderNumber;

  const EditWorkOrderScreen({
    super.key,
    required this.workOrderId,
    required this.workOrderNumber,
  });

  @override
  State<EditWorkOrderScreen> createState() => _EditWorkOrderScreenState();
}

class _EditWorkOrderScreenState extends State<EditWorkOrderScreen> {
  late final EditWorkOrderViewModel _viewModel;

  bool _isAddressExpanded = true;
  bool _isAppointmentExpanded = true;

  final TextEditingController addressCtrl = TextEditingController();
  final TextEditingController buildingCtrl = TextEditingController();
  final AppointmentMaskController appointmentCtrl = AppointmentMaskController();

  @override
  void initState() {
    super.initState();
    _viewModel = di.sl<EditWorkOrderViewModel>(
      param1: [widget.workOrderId, widget.workOrderNumber],
    );

    addressCtrl.addListener(() {
      _viewModel.address = addressCtrl.text;
    });
    buildingCtrl.addListener(() {
      _viewModel.building = buildingCtrl.text;
    });
    appointmentCtrl.addListener(() {
      _viewModel.appointmentDate = appointmentCtrl.text;
    });

    _viewModel.loadDetails().then((_) {
      if (mounted) {
        addressCtrl.text = _viewModel.address ?? '';
        buildingCtrl.text = _viewModel.building ?? '';
        appointmentCtrl.text = _viewModel.appointmentDate ?? '';
      }
    });
  }

  @override
  void dispose() {
    addressCtrl.dispose();
    buildingCtrl.dispose();
    appointmentCtrl.dispose();
    super.dispose();
  }

  Widget _buildSectionHeader({
    required String title,
    required bool isExpanded,
    required VoidCallback onTap,
    IconData? icon,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, color: AppColors.tertiary500, size: 24),
                  const SizedBox(width: AppDimens.spaceSm),
                ],
                Text(
                  title,
                  style: TextStyles.headline.copyWith(
                    color: AppColors.primary500,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            AnimatedRotation(
              turns: isExpanded ? 0.0 : 0.5,
              duration: const Duration(milliseconds: 200),
              child: const Icon(
                Icons.keyboard_arrow_down,
                color: AppColors.secondary500,
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Scaffold(
        backgroundColor: AppColors.background500,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight + 1.0),
          child: Consumer<EditWorkOrderViewModel>(
            builder: (context, vm, child) {
              return CustomerAppBar(
                title: "Edit Work Order",
                subtitle: vm.workOrder?.workOrderNum,
                showBackButton: true,
                showBottomDivider: true,
              );
            },
          ),
        ),
        body: SafeArea(
          child: Consumer<EditWorkOrderViewModel>(
            builder: (context, vm, child) {
              if (vm.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.tertiary500,
                  ),
                );
              }

              if (vm.errorMessage != null && vm.workOrder == null) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(AppDimens.spaceLg),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline_rounded,
                          color: Colors.redAccent,
                          size: 48,
                        ),
                        const SizedBox(height: AppDimens.spaceMd),
                        Text(
                          vm.errorMessage!,
                          textAlign: TextAlign.center,
                          style: TextStyles.bodyLarge.copyWith(
                            color: AppColors.secondary500,
                          ),
                        ),
                        const SizedBox(height: AppDimens.spaceLg),
                        ElevatedButton(
                          onPressed: () => vm.loadDetails(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary500,
                          ),
                          child: const Text(
                            "Retry",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(AppDimens.spaceMd),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [

                          // 2. Change Address Section
                          _buildSectionHeader(
                            title: "Change Address",
                            isExpanded: _isAddressExpanded,
                            onTap: () => setState(
                              () => _isAddressExpanded = !_isAddressExpanded,
                            ),
                          ),
                          AnimatedSize(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            child: _isAddressExpanded
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: AppDimens.spaceMd,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(
                                          height: AppDimens.spaceSm,
                                        ),
                                        CustomerDropdownField<String>(
                                          label: 'Ward',
                                          value: vm.city,
                                          items:
                                              {
                                                    if (vm.city != null)
                                                      vm.city!,
                                                    ...vm.wards,
                                                  }
                                                  .map(
                                                    (c) => DropdownMenuItem(
                                                      value: c,
                                                      child: Text(c),
                                                    ),
                                                  )
                                                  .toList(),
                                          onChanged: (v) {
                                            if (v != null) {
                                              vm.updateCity(v);
                                            }
                                          },
                                          isRequired: true,
                                          isSearchable: true,
                                        ),
                                        const SizedBox(
                                          height: AppDimens.spaceMd,
                                        ),
                                        CustomerTextField(
                                          label: 'Address',
                                          hint: 'e.g. 100 đường Điện Biên Phủ',
                                          controller: addressCtrl,
                                          isRequired: true,
                                        ),
                                        const SizedBox(
                                          height: AppDimens.spaceMd,
                                        ),
                                        CustomerTextField(
                                          label: 'Building/Floor/Room',
                                          hint: 'e.g. Block A',
                                          controller: buildingCtrl,
                                        ),
                                      ],
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ),

                          // 3. Change Appointment Section
                          _buildSectionHeader(
                            title: "Change Appointment",
                            isExpanded: _isAppointmentExpanded,
                            onTap: () => setState(
                              () => _isAppointmentExpanded =
                                  !_isAppointmentExpanded,
                            ),
                          ),
                          AnimatedSize(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            child: _isAppointmentExpanded
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: AppDimens.spaceMd,
                                    ),
                                    child: CustomerTextField(
                                      label: 'Appointment',
                                      hint: 'Select a detailed appointment',
                                      readOnly: true,
                                      onTap: () async {
                                        await vm.pickDate(context);
                                        if (vm.appointmentDate != null) {
                                          appointmentCtrl.text =
                                              vm.appointmentDate!;
                                        }
                                      },
                                      suffixIcon: IconButton(
                                        icon: const Icon(
                                          Icons.calendar_month,
                                          color: AppColors.secondary100,
                                        ),
                                        onPressed: () async {
                                          await vm.pickDate(context);
                                          if (vm.appointmentDate != null) {
                                            appointmentCtrl.text =
                                                vm.appointmentDate!;
                                          }
                                        },
                                      ),
                                      controller: appointmentCtrl,
                                      isRequired: true,
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Bottom Save Button
                  if (vm.errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimens.spaceMd,
                      ),
                      child: Text(
                        vm.errorMessage!,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  Container(
                    padding: const EdgeInsets.all(AppDimens.spaceMd),
                    child: Container(
                      width: double.infinity,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.tertiary500,
                        borderRadius: BorderRadius.circular(AppDimens.boraSm),
                        boxShadow: [BoxShadowStyles.glowing],
                      ),
                      child: ElevatedButton(
                        onPressed: vm.isSaving
                            ? null
                            : () async {
                                final success = await vm.saveChanges(context);
                                if (success && context.mounted) {
                                  context.pop(true);
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppDimens.boraSm,
                            ),
                          ),
                        ),
                        child: vm.isSaving
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                'Save Changes',
                                style: TextStyles.title.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
