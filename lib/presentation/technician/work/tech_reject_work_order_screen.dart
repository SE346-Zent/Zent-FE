import 'package:flutter/material.dart';
import 'package:zent_fe/presentation/common/core/utils/tap_debounce.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/presentation/common/core/themes/boxshadow.dart';
import 'package:zent_fe/presentation/common/core/ui/button.dart';
import 'package:zent_fe/di/injection_container.dart' as di;
import 'viewmodels/tech_reject_work_order_viewmodel.dart';
import 'widgets/part_photo_upload.dart';
import 'package:zent_fe/presentation/common/core/ui/zent_success_popup.dart';

class TechRejectWorkOrderScreen extends StatefulWidget {
  final String workOrderId;

  const TechRejectWorkOrderScreen({super.key, required this.workOrderId});

  @override
  State<TechRejectWorkOrderScreen> createState() =>
      _TechRejectWorkOrderScreenState();
}

class _TechRejectWorkOrderScreenState extends State<TechRejectWorkOrderScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          di.sl<TechRejectWorkOrderViewModel>()..initData(widget.workOrderId),
      child: Consumer<TechRejectWorkOrderViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            backgroundColor: AppColors.background500,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => context.pop(),
              ),
              title: Text(
                'Reject Work Order',
                style: TextStyles.headline.copyWith(
                  color: AppColors.primary500,
                ),
              ),
              centerTitle: true,
            ),
            body: Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(AppDimens.spaceLg),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (viewModel.workOrder != null)
                              _buildAssignmentCard(viewModel),

                            const SizedBox(height: AppDimens.spaceLg),

                            Text(
                              'Select Reason',
                              style: TextStyles.title.copyWith(
                                color: AppColors.primary500,
                              ),
                            ),
                            const SizedBox(height: AppDimens.spaceMd),

                            ...viewModel.rejectReasons.map((reason) {
                              final isSelected =
                                  viewModel.selectedReasonId == reason['id'];
                              return _buildReasonCard(
                                title: reason['title']!,
                                isSelected: isSelected,
                                onTap: () =>
                                    viewModel.selectReason(reason['id']!),
                              );
                            }),

                            const SizedBox(height: AppDimens.spaceLg),

                            Text(
                              'Additional Explanation',
                              style: TextStyles.title.copyWith(
                                color: AppColors.primary500,
                              ),
                            ),
                            const SizedBox(height: AppDimens.spaceMd),

                            TextField(
                              controller: viewModel.notesController,
                              maxLines: 4,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                hintText:
                                    'Add any relevant details about this rejection',
                                hintStyle: TextStyles.bodyMedium.copyWith(
                                  color: AppColors.secondary300,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    AppDimens.boraSm,
                                  ),
                                  borderSide: const BorderSide(
                                    color: AppColors.secondary200,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    AppDimens.boraSm,
                                  ),
                                  borderSide: const BorderSide(
                                    color: AppColors.tertiary500,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: AppDimens.spaceLg),
                            PartPhotoUpload(
                              title: 'Evidence Photos',
                              hintText: 'Tap to capture evidence photos',
                              photos: viewModel.evidenceImageUrls,
                              onPhotoAdded: viewModel.addPhotoFromPath,
                              onPhotoRemoved: viewModel.removePhoto,
                            ),
                            const SizedBox(height: AppDimens.spaceXl),
                          ],
                        ),
                      ),
                    ),
                    _buildBottomButton(context),
                  ],
                ),
                if (viewModel.isLoading)
                  Container(
                    color: Colors.black26,
                    child: const Center(child: CircularProgressIndicator()),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAssignmentCard(TechRejectWorkOrderViewModel viewModel) {
    final wo = viewModel.workOrder;
    if (wo == null) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimens.boraSm),
        boxShadow: [BoxShadowStyles.raised],
      ),
      clipBehavior: Clip.hardEdge,
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(width: 4.0, color: AppColors.tertiary500),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppDimens.spaceMd),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Assignment',
                      style: TextStyles.title.copyWith(
                        color: AppColors.tertiary500,
                      ),
                    ),
                    const SizedBox(height: AppDimens.spaceSm),
                    _buildInfoRow('Work Order ID', wo.id),
                    const SizedBox(height: 4.0),
                    _buildInfoRow('Customer', wo.customerName),
                    const SizedBox(height: 4.0),
                    _buildInfoRow('Product', wo.title),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyles.bodyLarge.copyWith(color: AppColors.secondary500),
        ),
        const SizedBox(width: AppDimens.spaceMd),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyles.middle.copyWith(color: Colors.black),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildReasonCard({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return ThrottledGestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppDimens.boraSm),
          border: Border.all(
            color: isSelected ? AppColors.tertiary500 : AppColors.secondary100,
            width: 1.0,
          ),
          boxShadow: [BoxShadowStyles.raised],
        ),
        child: Row(
          children: [
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: isSelected
                  ? AppColors.tertiary500
                  : AppColors.secondary400,
              size: 20,
            ),
            const SizedBox(width: AppDimens.spaceMd),
            Expanded(
              child: Text(
                title,
                style: TextStyles.middle.copyWith(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButton(BuildContext context) {
    final viewModel = context.watch<TechRejectWorkOrderViewModel>();
    return Container(
      padding: const EdgeInsets.all(AppDimens.spaceLg),
      color: Colors.white,
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: PrimaryActionButton(
            label: 'Confirm Rejection',
            onPressed: viewModel.isLoading
                ? null
                : () {
                    if (viewModel.selectedReasonId == null) {
                      debugPrint('Validation: Please select a reason');
                      return;
                    }
                    // Handle async logic without making the closure itself async if the type is strict
                    viewModel.submitRejection().then((error) {
                      if (context.mounted) {
                        if (error == null) {
                          ZentSuccessPopup.show(
                            context,
                            'Work order rejected successfully!',
                          );
                          Navigator.pop(context, true);
                        } else {
                          debugPrint('Rejection Error: $error');
                        }
                      }
                    });
                  },
          ),
        ),
      ),
    );
  }
}
