import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/presentation/common/core/ui/account_header.dart';
import 'package:zent_fe/presentation/common/core/ui/zent_error_popup.dart';
import 'package:zent_fe/di/injection_container.dart' as di;

import 'viewmodels/complete_work_order_viewmodel.dart';
import 'widgets/step_indicator.dart';
import 'widgets/step_navigation_buttons.dart';
import 'widgets/machine_info_section.dart';
import 'widgets/diagnostic_section.dart';
import 'widgets/part_tracking_section.dart';
import 'widgets/single_phase_evidence_photos.dart';
import 'widgets/customer_signature_step.dart';

class CompleteWorkOrderScreen extends StatelessWidget {
  final String workOrderId;

  const CompleteWorkOrderScreen({super.key, required this.workOrderId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => di.sl<CompleteWorkOrderViewModel>(param1: workOrderId),
      child: const _CompleteWorkOrderContent(),
    );
  }
}

class _CompleteWorkOrderContent extends StatefulWidget {
  const _CompleteWorkOrderContent();

  @override
  State<_CompleteWorkOrderContent> createState() =>
      _CompleteWorkOrderContentState();
}

class _CompleteWorkOrderContentState extends State<_CompleteWorkOrderContent> {
  bool _isDiagnosticOpen = false;
  int _lastStep = 0;

  TextEditingController _getStepController(
    CompleteWorkOrderViewModel viewModel,
  ) {
    if (viewModel.currentStep == 0) {
      return viewModel.diagnosticNote1Controller;
    } else if (viewModel.currentStep == 1) {
      return viewModel.diagnosticNote2Controller;
    } else {
      return viewModel.diagnosticNote3Controller;
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CompleteWorkOrderViewModel>();

    // Collapse diagnostic notes automatically when switching steps
    if (viewModel.currentStep != _lastStep) {
      _isDiagnosticOpen = false;
      _lastStep = viewModel.currentStep;
    }

    // Show verification error popup if any
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (viewModel.photoUploadError != null) {
        final err = viewModel.photoUploadError;
        viewModel.clearPhotoUploadError();
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Verification Failed'),
            content: Text(
              'The captured image failed EXIF & Geofencing verification:\n\n$err\n\nPlease capture the image while physically present at the work order site.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background500,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                AccountHeader(
                  title: "Complete Work Order",
                  subtitle:
                      "${viewModel.workOrderNum.isNotEmpty ? viewModel.workOrderNum : viewModel.workOrderId} • ${viewModel.appointmentFormatted}",
                  showDivider: true,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(AppDimens.spaceMd),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        StepIndicator(
                          currentStep: viewModel.currentStep,
                          totalSteps: CompleteWorkOrderViewModel.totalSteps,
                        ),
                        const SizedBox(height: AppDimens.spaceMd),
                        _buildStepContent(viewModel),
                        if (viewModel.currentStep == 4)
                          const SizedBox(height: 120),
                      ],
                    ),
                  ),
                ),
                StepNavigationButtons(
                  currentStep: viewModel.currentStep,
                  totalSteps: CompleteWorkOrderViewModel.totalSteps,
                  onBackPressed: () => _onBackPressed(context, viewModel),
                  onNextPressed: () => _onNextPressed(context, viewModel),
                ),
              ],
            ),
            // Floating diagnostic drawer tab/drawer overlay on Step 1, 2, and 3
            if (viewModel.currentStep < 3)
              _isDiagnosticOpen
                  ? Positioned(
                      right: 16,
                      top: MediaQuery.of(context).size.height * 0.20,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: 320,
                            height: 350,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppColors.tertiary300,
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.08),
                                  blurRadius: 12,
                                  offset: const Offset(-4, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Diagnostic notes',
                                  style: TextStyles.title.copyWith(
                                    color: AppColors.primary500,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: AppColors.secondary100,
                                      ),
                                    ),
                                    child: TextField(
                                      controller: _getStepController(viewModel),
                                      maxLines: null,
                                      expands: true,
                                      enabled: !viewModel.isReadOnly,
                                      textAlignVertical: TextAlignVertical.top,
                                      style: TextStyles.bodyMedium.copyWith(
                                        color: viewModel.isReadOnly
                                            ? AppColors.secondary300
                                            : AppColors.primary500,
                                      ),
                                      decoration: InputDecoration(
                                        hintText:
                                            'Describe how it was used or any specific details...',
                                        hintStyle: TextStyles.bodyMedium
                                            .copyWith(
                                              color: AppColors.secondary100,
                                            ),
                                        border: InputBorder.none,
                                        contentPadding: const EdgeInsets.all(
                                          12,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            left: -24,
                            bottom: 16,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isDiagnosticOpen = false;
                                });
                              },
                              child: SizedBox(
                                width: 48,
                                height: 48,
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Container(
                                      width: 48,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: AppColors.tertiary300,
                                          width: 1.5,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left: 24,
                                      top: 1,
                                      bottom: 1,
                                      right: -2,
                                      child: Container(color: Colors.white),
                                    ),
                                    const Center(
                                      child: Icon(
                                        Icons.chevron_right,
                                        color: AppColors.tertiary300,
                                        size: 24,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Positioned(
                      right: 0,
                      top: MediaQuery.of(context).size.height * 0.20,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _isDiagnosticOpen = true;
                          });
                        },
                        child: Container(
                          width: 32,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border(
                              left: BorderSide(
                                color: AppColors.tertiary300,
                                width: 1.5,
                              ),
                              top: BorderSide(
                                color: AppColors.tertiary300,
                                width: 1.5,
                              ),
                              bottom: BorderSide(
                                color: AppColors.tertiary300,
                                width: 1.5,
                              ),
                            ),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(24),
                              bottomLeft: Radius.circular(24),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.08),
                                blurRadius: 6,
                                offset: const Offset(-2, 2),
                              ),
                            ],
                          ),
                          child: const Align(
                            alignment: Alignment(-0.2, 0.0),
                            child: Icon(
                              Icons.chevron_left,
                              color: AppColors.tertiary300,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
            if (viewModel.isPhotoUploading || viewModel.isLoading)
              Container(
                color: Colors.black38,
                child: Center(
                  child: Card(
                    margin: const EdgeInsets.all(32),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.primary500,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            viewModel.isPhotoUploading
                                ? "Verifying EXIF & GPS Location..."
                                : "Submitting Completion Report...",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
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

  Widget _buildStepContent(CompleteWorkOrderViewModel viewModel) {
    switch (viewModel.currentStep) {
      case 0:
        return _buildStep1(viewModel);
      case 1:
        return _buildStep2(viewModel);
      case 2:
        return _buildStep3(viewModel);
      case 3:
        return _buildStep4(viewModel);
      case 4:
        return _buildStep5(viewModel);
      default:
        return const SizedBox.shrink();
    }
  }

  /// Step 1: Machine Information + Evidence photos (Pre-disassembly only)
  Widget _buildStep1(CompleteWorkOrderViewModel viewModel) {
    return Column(
      children: [
        MachineInfoSection(viewModel: viewModel),
        const SizedBox(height: AppDimens.spaceLg),
        SinglePhaseEvidencePhotos(
          phaseLabel: "Pre-disassembly (Ảnh trước tháo)",
          photos: viewModel.prePhotos,
          phaseKey: 'pre',
          maxPhotosNote: "Max photos for each phase: 5 photos",
          maxPhotosPosition: MaxPhotosPosition.below,
          onPhotoAdded: (path) => viewModel.addPhoto(path, 'pre'),
          onPhotoRemoved: (index) => viewModel.removePhoto(index, 'pre'),
          isReadOnly: viewModel.isReadOnly,
        ),
      ],
    );
  }

  /// Step 2: Part Uninstalled + Evidence photos (Disassembled - inline max)
  Widget _buildStep2(CompleteWorkOrderViewModel viewModel) {
    return Column(
      children: [
        PartTrackingSection(
          viewModel: viewModel,
          mode: PartTrackingMode.uninstalledOnly,
        ),
        const SizedBox(height: AppDimens.spaceLg),
        SinglePhaseEvidencePhotos(
          phaseLabel: "Disassembled (Ảnh đang tháo)",
          photos: viewModel.duringPhotos,
          phaseKey: 'during',
          maxPhotosNote: "Max photos: 5",
          maxPhotosPosition: MaxPhotosPosition.inline,
          onPhotoAdded: (path) => viewModel.addPhoto(path, 'during'),
          onPhotoRemoved: (index) => viewModel.removePhoto(index, 'during'),
          isReadOnly: viewModel.isReadOnly,
        ),
      ],
    );
  }

  /// Step 3: Part Installed + Evidence photos (shares duringPhotos with step 2)
  Widget _buildStep3(CompleteWorkOrderViewModel viewModel) {
    return Column(
      children: [
        PartTrackingSection(
          viewModel: viewModel,
          mode: PartTrackingMode.installedOnly,
        ),
        const SizedBox(height: AppDimens.spaceLg),
        SinglePhaseEvidencePhotos(
          phaseLabel: "Post-assembly (Ảnh hoàn thiện)",
          photos: viewModel.postPhotos,
          phaseKey: 'post',
          maxPhotosNote: "Max photos: 5",
          maxPhotosPosition: MaxPhotosPosition.inline,
          onPhotoAdded: (path) => viewModel.addPhoto(path, 'post'),
          onPhotoRemoved: (index) => viewModel.removePhoto(index, 'post'),
          isReadOnly: viewModel.isReadOnly,
        ),
      ],
    );
  }

  /// Step 4: Diagnostic Section (Checklist completed on Detailed Work screen)
  Widget _buildStep4(CompleteWorkOrderViewModel viewModel) {
    return DiagnosticSection(viewModel: viewModel);
  }

  /// Step 5: Customer Signature
  Widget _buildStep5(CompleteWorkOrderViewModel viewModel) {
    return CustomerSignatureStep(
      workOrderId: viewModel.workOrderNum.isNotEmpty
          ? viewModel.workOrderNum
          : viewModel.workOrderId,
      date: viewModel.currentDate,
      technicianName: viewModel.technicianName,
      initialPoints: viewModel.signaturePoints,
      onSignatureUpdated: viewModel.signaturePointsUpdated,
      isReadOnly: viewModel.isReadOnly,
    );
  }

  void _onBackPressed(
    BuildContext context,
    CompleteWorkOrderViewModel viewModel,
  ) {
    if (viewModel.currentStep == 0) {
      // At step 1, back exits the completion form (same as header back)
      context.pop();
    } else {
      viewModel.backStepPressed();
    }
  }

  void _onNextPressed(
    BuildContext context,
    CompleteWorkOrderViewModel viewModel,
  ) {
    if (!viewModel.isReadOnly) {
      if (viewModel.currentStep == 0) {
        if (viewModel.prePhotos.isEmpty) {
          ZentErrorPopup.show(
            context,
            'Vui lòng chụp ít nhất 1 ảnh trước tháo (Pre-disassembly)!',
          );
          return;
        }
      }

      if (viewModel.currentStep == 1) {
        if (viewModel.duringPhotos.isEmpty) {
          ZentErrorPopup.show(
            context,
            'Vui lòng chụp ít nhất 1 ảnh đang tháo (Disassembled)!',
          );
          return;
        }
      }

      if (viewModel.currentStep == 2) {
        if (viewModel.postPhotos.isEmpty) {
          ZentErrorPopup.show(
            context,
            'Vui lòng chụp ít nhất 1 ảnh hoàn thiện (Post-assembly)!',
          );
          return;
        }
      }
    }

    if (viewModel.currentStep == CompleteWorkOrderViewModel.totalSteps - 1) {
      viewModel.submitPressed(context);
    } else {
      viewModel.nextStepPressed();
    }
  }
}
