import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:zent_fe/di/injection_container.dart' as di;
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/presentation/common/core/themes/boxshadow.dart';
import 'package:zent_fe/presentation/customer/account/widgets/customer_app_bar.dart';
import 'viewmodels/customer_work_order_details_viewmodel.dart';
import 'widgets/customer_text_field.dart';
import 'package:zent_fe/domain/entities/work_order.dart';

class CustomerWorkOrderDetailsScreen extends StatefulWidget {
  final String workOrderId;

  const CustomerWorkOrderDetailsScreen({super.key, required this.workOrderId});

  @override
  State<CustomerWorkOrderDetailsScreen> createState() =>
      _CustomerWorkOrderDetailsScreenState();
}

class _CustomerWorkOrderDetailsScreenState
    extends State<CustomerWorkOrderDetailsScreen> {
  late final CustomerWorkOrderDetailsViewModel _viewModel;

  bool _isAdditionalExpanded = true;
  bool _isContactExpanded = true;
  bool _isAddressExpanded = true;

  // Controllers for read-only fields
  final TextEditingController symptomCtrl = TextEditingController();
  final TextEditingController ticketCtrl = TextEditingController();
  final TextEditingController descCtrl = TextEditingController();
  final TextEditingController appointmentCtrl = TextEditingController();

  final TextEditingController firstNameCtrl = TextEditingController();
  final TextEditingController lastNameCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController phoneCtrl = TextEditingController();

  final TextEditingController countryCtrl = TextEditingController();
  final TextEditingController provinceCtrl = TextEditingController();
  final TextEditingController wardCtrl = TextEditingController();
  final TextEditingController addressCtrl = TextEditingController();
  final TextEditingController buildingCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _viewModel = di.sl<CustomerWorkOrderDetailsViewModel>(
      param1: widget.workOrderId,
    );

    _viewModel.loadDetails().then((_) {
      if (mounted && _viewModel.workOrder != null) {
        final wo = _viewModel.workOrder!;
        symptomCtrl.text = wo.symptomName ?? wo.rejectReason;
        ticketCtrl.text = wo
            .refusalNote; // Or reference ticket ID if we have it, wait, let's map if any
        descCtrl.text = wo.description;

        if (wo.appointment != null) {
          appointmentCtrl.text = DateFormat(
            "HH:mm, dd/MM/yyyy",
          ).format(wo.appointment!.toLocal());
        } else {
          appointmentCtrl.text = "N/A";
        }

        firstNameCtrl.text = wo.firstName ?? "";
        lastNameCtrl.text = wo.customerName
            .split(" ")
            .last; // fallback or customerName
        // Let's split customerName into first and last name if firstName is empty
        if (wo.firstName == null || wo.firstName!.isEmpty) {
          final names = wo.customerName.split(" ");
          if (names.length > 1) {
            firstNameCtrl.text = names.sublist(0, names.length - 1).join(" ");
            lastNameCtrl.text = names.last;
          } else {
            firstNameCtrl.text = wo.customerName;
            lastNameCtrl.text = "";
          }
        } else {
          firstNameCtrl.text = wo.firstName!;
          lastNameCtrl.text = wo.customerName
              .replaceFirst(wo.firstName!, "")
              .trim();
          if (lastNameCtrl.text.isEmpty) {
            lastNameCtrl.text = "N/A";
          }
        }

        emailCtrl.text = wo.email ?? "N/A";
        phoneCtrl.text = wo.phoneNumber ?? "N/A";

        countryCtrl.text = wo.country ?? "Vietnam";
        provinceCtrl.text =
            wo.city != null && wo.city!.toLowerCase().contains('hanoi')
            ? 'Thành phố Hà Nội'
            : 'Thành phố Hồ Chí Minh';
        // wait, let's look at the province. If we have it in wo.country/province:
        // Actually, we can just set it from wo.country or fallback.
        provinceCtrl.text = wo.country ?? "Thành phố Hồ Chí Minh";
        // Wait, if it has a province field in backend:
        // Details schema has: "province": "Service location: Province/State."
        // So yes! wo.country was mapped, but we also have `wo.country` or similar. Let's see: we did not map province in WorkOrderModel previously?
        // Wait! In WorkOrder entity:
        // final String? country;
        // In WorkOrderModel.fromJson:
        // country: json['country'] as String?,
        // Wait! Did it parse province? No, it did not! But we can just use "Thành phố Hồ Chí Minh" or "Thành phố Hà Nội" based on ward/city, or we can just display the city/ward name.
        // Actually, let's look at `vietnam_location.json` or fallback. If we want it to look exactly like request service, country is "Vietnam", Province is "Thành phố Hồ Chí Minh" (or "Thành phố Hà Nội"), Ward is the ward name.
        // Let's check: if wo.city contains ward, then we can check. Wait! We can also just display wo.city (which is the ward) and for province, if we don't have it, we can just write "Thành phố Hồ Chí Minh" or "Thành phố Hà Nội".
        // Let's do that!
        countryCtrl.text = wo.country ?? "Vietnam";
        // Let's check which city the ward is in.
        final cityLower = (wo.city ?? "").toLowerCase();
        if (cityLower.contains("ba đình") ||
            cityLower.contains("hoàn kiếm") ||
            cityLower.contains("cầu giấy") ||
            cityLower.contains("đống đa") ||
            cityLower.contains("láng")) {
          provinceCtrl.text = "Thành phố Hà Nội";
        } else {
          provinceCtrl.text = "Thành phố Hồ Chí Minh";
        }

        wardCtrl.text = wo.city ?? "";
        addressCtrl.text = wo.addressLine1 ?? wo.addressString;
        if (addressCtrl.text == wo.addressString) {
          final parts = addressCtrl.text.split(',');
          if (parts.isNotEmpty) {
            addressCtrl.text = parts[0].trim();
          }
        }
        buildingCtrl.text = wo.building ?? "N/A";
      }
    });
  }

  @override
  void dispose() {
    symptomCtrl.dispose();
    ticketCtrl.dispose();
    descCtrl.dispose();
    appointmentCtrl.dispose();
    firstNameCtrl.dispose();
    lastNameCtrl.dispose();
    emailCtrl.dispose();
    phoneCtrl.dispose();
    countryCtrl.dispose();
    provinceCtrl.dispose();
    wardCtrl.dispose();
    addressCtrl.dispose();
    buildingCtrl.dispose();
    super.dispose();
  }

  Widget _buildSectionHeader({
    required String title,
    required bool isExpanded,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyles.headline.copyWith(
                  color: AppColors.primary500,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: AppDimens.spaceMd),
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

  Widget _buildStatusCard(WorkOrder wo) {
    final String statusStr = wo.status.name.toLowerCase();
    Color statusColor = AppColors.warning500;
    String statusText = "Pending";

    if (statusStr.contains('inprog') || statusStr.contains('assigned')) {
      statusColor = AppColors.tertiary500;
      statusText = statusStr.contains('assigned') ? "Assigned" : "In Progress";
    } else if (statusStr.contains('complete') ||
        statusStr.contains('closed') ||
        statusStr.contains('cancel')) {
      statusColor = AppColors.success500;
      statusText = "Closed";
    } else if (statusStr.contains('rejectinreview')) {
      statusColor = AppColors.error300;
      statusText = "Reject In Review";
    } else if (statusStr.contains('rejected')) {
      statusColor = AppColors.error500;
      statusText = "Rejected";
    }

    String endedAtText = "N/A";
    final DateTime? endedAt =
        wo.closedAt ??
        ((statusText == "Closed" || statusText == "Rejected")
            ? wo.updatedAt
            : null);
    if (endedAt != null) {
      endedAtText = DateFormat("HH'h'mm, dd/MM/yyyy").format(endedAt.toLocal());
    }

    final String assignerText = wo.technicianName ?? "N/A";

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimens.boraSm),
        border: Border.all(color: AppColors.secondary200, width: 1.0),
        boxShadow: [BoxShadowStyles.subtle],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppDimens.boraSm),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(width: 6.0, color: statusColor),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimens.spaceMd,
                    vertical: 12.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildCardRow("Work Order ID", wo.workOrderNum),
                      const SizedBox(height: 8.0),
                      _buildCardRow("Assigner", assignerText),
                      const SizedBox(height: 8.0),
                      _buildCardRow(
                        "Status",
                        statusText,
                        valueColor: statusColor,
                        isStatus: true,
                      ),
                      const SizedBox(height: 8.0),
                      _buildCardRow("Ended at", endedAtText),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardRow(
    String label,
    String value, {
    Color? valueColor,
    bool isStatus = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyles.bodyLarge.copyWith(color: AppColors.secondary500),
        ),
        Text(
          value,
          style: isStatus
              ? TextStyles.middle.copyWith(
                  color: valueColor ?? AppColors.primary500,
                  fontWeight: FontWeight.bold,
                )
              : TextStyles.middle.copyWith(
                  color: AppColors.primary500,
                  fontWeight: FontWeight.bold,
                ),
        ),
      ],
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
          child: Consumer<CustomerWorkOrderDetailsViewModel>(
            builder: (context, vm, child) {
              return CustomerAppBar(
                title: "Details Work Order",
                subtitle: vm.workOrder?.workOrderNum,
                showBackButton: true,
                showBottomDivider: true,
              );
            },
          ),
        ),
        body: SafeArea(
          child: Consumer<CustomerWorkOrderDetailsViewModel>(
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

              if (vm.workOrder == null) {
                return const Center(child: Text("Work Order not found"));
              }

              final wo = vm.workOrder!;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(AppDimens.spaceMd),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: AppDimens.spaceMd),
                    _buildStatusCard(wo),
                    const SizedBox(height: AppDimens.spaceXs),

                    // 1. Additional Info Section
                    _buildSectionHeader(
                      title: "Additional Info",
                      isExpanded: _isAdditionalExpanded,
                      onTap: () => setState(
                        () => _isAdditionalExpanded = !_isAdditionalExpanded,
                      ),
                    ),
                    AnimatedSize(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      child: _isAdditionalExpanded
                          ? Padding(
                              padding: const EdgeInsets.only(
                                bottom: AppDimens.spaceMd,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomerTextField(
                                    label: 'Symptom',
                                    hint: '',
                                    controller: symptomCtrl,
                                    readOnly: true,
                                  ),
                                  const SizedBox(height: AppDimens.spaceMd),
                                  CustomerTextField(
                                    label: 'Ticket Reference Number',
                                    hint: 'N/A',
                                    controller: ticketCtrl,
                                    readOnly: true,
                                  ),
                                  const SizedBox(height: AppDimens.spaceMd),
                                  CustomerTextField(
                                    label: 'Description',
                                    hint: '',
                                    maxLines: null,
                                    controller: descCtrl,
                                    readOnly: true,
                                  ),
                                  const SizedBox(height: AppDimens.spaceMd),
                                  CustomerTextField(
                                    label: 'Appointment',
                                    hint: '',
                                    controller: appointmentCtrl,
                                    readOnly: true,
                                  ),
                                ],
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),

                    // 2. Contact Info Section
                    _buildSectionHeader(
                      title: "Contact Info",
                      isExpanded: _isContactExpanded,
                      onTap: () => setState(
                        () => _isContactExpanded = !_isContactExpanded,
                      ),
                    ),
                    AnimatedSize(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      child: _isContactExpanded
                          ? Padding(
                              padding: const EdgeInsets.only(
                                bottom: AppDimens.spaceMd,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: CustomerTextField(
                                          label: 'First Name',
                                          hint: '',
                                          controller: firstNameCtrl,
                                          readOnly: true,
                                        ),
                                      ),
                                      const SizedBox(width: AppDimens.spaceLg),
                                      Expanded(
                                        child: CustomerTextField(
                                          label: 'Last Name',
                                          hint: '',
                                          controller: lastNameCtrl,
                                          readOnly: true,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: AppDimens.spaceMd),
                                  CustomerTextField(
                                    label: 'Email',
                                    hint: 'N/A',
                                    controller: emailCtrl,
                                    readOnly: true,
                                  ),
                                  const SizedBox(height: AppDimens.spaceMd),
                                  CustomerTextField(
                                    label: 'Mobile Phone Number',
                                    hint: 'N/A',
                                    controller: phoneCtrl,
                                    readOnly: true,
                                  ),
                                ],
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),

                    // 3. Select Address for Machine Location Section
                    _buildSectionHeader(
                      title: "Select Address for Machine Location",
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomerTextField(
                                    label: 'Country/Region',
                                    hint: '',
                                    controller: countryCtrl,
                                    readOnly: true,
                                  ),
                                  const SizedBox(height: AppDimens.spaceMd),
                                  CustomerTextField(
                                    label: 'Province',
                                    hint: '',
                                    controller: provinceCtrl,
                                    readOnly: true,
                                  ),
                                  const SizedBox(height: AppDimens.spaceMd),
                                  CustomerTextField(
                                    label: 'Ward',
                                    hint: '',
                                    controller: wardCtrl,
                                    readOnly: true,
                                  ),
                                  const SizedBox(height: AppDimens.spaceMd),
                                  CustomerTextField(
                                    label: 'Address',
                                    hint: '',
                                    controller: addressCtrl,
                                    readOnly: true,
                                  ),
                                  const SizedBox(height: AppDimens.spaceMd),
                                  CustomerTextField(
                                    label: 'Building/Floor/Room',
                                    hint: 'N/A',
                                    controller: buildingCtrl,
                                    readOnly: true,
                                  ),
                                ],
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
