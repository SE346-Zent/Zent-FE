import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../presentation/common/core/themes/colors.dart';
import '../../../../presentation/common/core/themes/dimens.dart';
import '../../../../presentation/common/core/themes/text_styles.dart';
import '../../../../presentation/common/core/themes/boxshadow.dart';
import 'widgets/customer_text_field.dart';
import 'widgets/customer_dropdown_field.dart';
import 'widgets/appointment_mask.dart';
import 'viewmodels/request_service_viewmodel.dart';

class RequestServiceInfoScreen extends StatefulWidget {
  const RequestServiceInfoScreen({super.key});

  @override
  State<RequestServiceInfoScreen> createState() =>
      _RequestServiceInfoScreenState();
}

class _RequestServiceInfoScreenState extends State<RequestServiceInfoScreen> {
  String? selectedSymptom;
  final TextEditingController ticketCtrl = TextEditingController();
  final TextEditingController descCtrl = TextEditingController();
  final AppointmentMaskController appointmentCtrl = AppointmentMaskController();

  final FocusNode appointmentFocus = FocusNode();

  bool get isNextEnabled =>
      selectedSymptom != null &&
      appointmentCtrl.text.length == AppointmentInputFormatter.mask.length &&
      !appointmentCtrl.text.contains('-');

  @override
  void initState() {
    super.initState();
    final vm = context.read<RequestServiceViewModel>();
    selectedSymptom = vm.symptom?.isEmpty == true ? null : vm.symptom;
    ticketCtrl.text = vm.ticketRef ?? '';
    descCtrl.text = vm.description ?? '';
    appointmentCtrl.text = vm.appointmentDate ?? '';

    appointmentCtrl.addListener(() => setState(() {}));

    appointmentFocus.addListener(() {
      if (appointmentFocus.hasFocus) {
        if (appointmentCtrl.text.isEmpty) {
          appointmentCtrl.text = AppointmentInputFormatter.mask;
          Future.microtask(() {
            appointmentCtrl.selection = const TextSelection.collapsed(
              offset: 0,
            );
          });
        }
      } else {
        if (appointmentCtrl.text == AppointmentInputFormatter.mask) {
          appointmentCtrl.text = '';
        }
      }
    });
  }

  @override
  void dispose() {
    ticketCtrl.dispose();
    descCtrl.dispose();
    appointmentCtrl.dispose();
    appointmentFocus.dispose();
    super.dispose();
  }

  void _onNext(RequestServiceViewModel viewModel) {
    viewModel.saveInfo(
      symptomVal: selectedSymptom ?? '',
      ticketRefVal: ticketCtrl.text,
      descriptionVal: descCtrl.text,
      appointmentDateVal: appointmentCtrl.text,
    );
    viewModel.nextStep();
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
            'Step 2 of 5',
            style: TextStyles.bodyMedium.copyWith(color: AppColors.tertiary500),
          ),
          const SizedBox(height: AppDimens.spaceXs),
          Text(
            'Additional Info',
            style: TextStyles.display.copyWith(
              color: AppColors.primary500,
              fontSize: 32,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppDimens.spaceXs),
          Text(
            'Please provide a few more details to make sure your ticket is handled appropriately.',
            style: TextStyles.bodyLarge.copyWith(color: AppColors.secondary500),
          ),
          const SizedBox(height: AppDimens.spaceXl),

          CustomerDropdownField<String>(
            label: 'Symptom',
            hint: 'Select Category',
            value: selectedSymptom,
            items: [
              'Screen Broken',
              'Battery Issue',
              'Software Glitch',
              'Hardware Damage',
              'Other',
            ].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
            onChanged: (v) {
              setState(() {
                selectedSymptom = v;
              });
            },
            isRequired: true,
          ),

          CustomerTextField(
            label: 'Ticket Reference Number',
            hint: 'e.g WO-12345',
            controller: ticketCtrl,
          ),
          const SizedBox(height: AppDimens.spaceLg),

          CustomerTextField(
            label: 'Description',
            hint: 'Describe the problem with your device.',
            maxLines: 5,
            controller: descCtrl,
            isRequired: true,
          ),
          const SizedBox(height: AppDimens.spaceLg),

          CustomerTextField(
            label: 'Appointment',
            hint: 'Select a detailed appointment',
            suffixIcon: IconButton(
              icon: const Icon(
                Icons.calendar_month,
                color: AppColors.secondary100,
              ),
              onPressed: () async {
                await viewModel.pickDate(context);
                if (viewModel.appointmentDate != null) {
                  appointmentCtrl.text = viewModel.appointmentDate!;
                  appointmentCtrl.selection = TextSelection.collapsed(
                    offset: appointmentCtrl.text.length,
                  );
                }
              },
            ),
            controller: appointmentCtrl,
            focusNode: appointmentFocus,
            inputFormatters: [AppointmentInputFormatter()],
            keyboardType: TextInputType.number,
            isRequired: true,
          ),
          const SizedBox(height: AppDimens.spaceLg),
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
