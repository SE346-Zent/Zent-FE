import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/ui/account_header.dart';
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

class _CompleteWorkOrderContent extends StatelessWidget {
  const _CompleteWorkOrderContent();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CompleteWorkOrderViewModel>();

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
                      "${viewModel.workOrderNum.isNotEmpty ? viewModel.workOrderNum : viewModel.workOrderId} • 12h30 AM",
                  showDivider: true,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    physics: viewModel.currentStep == 4
                        ? const NeverScrollableScrollPhysics()
                        : null,
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
                        const SizedBox(height: AppDimens.spaceLg),
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
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Vui lòng chụp ít nhất 1 ảnh trước tháo (Pre-disassembly)!',
              ),
              backgroundColor: Colors.redAccent,
            ),
          );
          return;
        }
      }

      if (viewModel.currentStep == 1) {
        if (viewModel.duringPhotos.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Vui lòng chụp ít nhất 1 ảnh đang tháo (Disassembled)!',
              ),
              backgroundColor: Colors.redAccent,
            ),
          );
          return;
        }
      }

      if (viewModel.currentStep == 2) {
        if (viewModel.postPhotos.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Vui lòng chụp ít nhất 1 ảnh hoàn thiện (Post-assembly)!',
              ),
              backgroundColor: Colors.redAccent,
            ),
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
