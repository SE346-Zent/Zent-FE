import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/presentation/common/core/ui/zent_error_popup.dart';
import 'package:zent_fe/presentation/common/core/themes/boxshadow.dart';
import 'package:zent_fe/presentation/common/core/ui/app_network_image.dart';
import 'package:zent_fe/di/injection_container.dart' as di;

import 'widgets/admin_text_field.dart';
import 'viewmodels/detail_request_viewmodel.dart';
import 'package:zent_fe/presentation/common/core/ui/account_header.dart';

class DetailRequestScreen extends StatelessWidget {
  final String partId;
  const DetailRequestScreen({super.key, required this.partId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => di.sl<DetailRequestViewModel>()..init(partId),
      child: const _DetailRequestScreenContent(),
    );
  }
}

class _DetailRequestScreenContent extends StatelessWidget {
  const _DetailRequestScreenContent();

  void _showRejectDialog(
    BuildContext context,
    DetailRequestViewModel viewModel,
  ) {
    final reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(
            horizontal: AppDimens.spaceLg,
          ),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.boraMd),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppDimens.spaceLg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Reason for Rejection',
                  style: TextStyles.middle.copyWith(color: Colors.black),
                ),
                const SizedBox(height: AppDimens.spaceMd),
                TextField(
                  controller: reasonController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.background500,
                    hintText:
                        'Add detailed reason why this request should be rejected',
                    hintStyle: TextStyles.bodyMedium.copyWith(
                      color: AppColors.secondary300,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppDimens.boraSm),
                      borderSide: const BorderSide(
                        color: AppColors.secondary300,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppDimens.boraSm),
                      borderSide: const BorderSide(color: AppColors.primary500),
                    ),
                    contentPadding: const EdgeInsets.all(AppDimens.spaceMd),
                  ),
                ),
                const SizedBox(height: AppDimens.spaceLg),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    boxShadow: [BoxShadowStyles.glowing],
                    borderRadius: BorderRadius.circular(AppDimens.boraSm),
                  ),
                  child: ElevatedButton(
                    onPressed: () async {
                      final reason = reasonController.text.trim();
                      if (reason.isEmpty) {
                        ZentErrorPopup.show(
                          ctx,
                          'Please provide a reason for rejection',
                        );
                        return;
                      }
                      if (reason.length < 10) {
                        ZentErrorPopup.show(
                          ctx,
                          'Reason for rejection must be at least 10 characters long',
                        );
                        return;
                      }
                      Navigator.pop(ctx);
                      final success = await viewModel.denyPart(reason);
                      if (ctx.mounted) {
                        if (success) {
                          Navigator.of(ctx).pop(true);
                        } else {
                          ZentErrorPopup.show(
                            ctx,
                            'Failed to reject part request',
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error500,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppDimens.boraSm),
                      ),
                    ),
                    child: Text(
                      'Reject',
                      style: TextStyles.title.copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<DetailRequestViewModel>();

    return Scaffold(
      backgroundColor: AppColors.background500,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            const AccountHeader(
              title: 'Detail Request',
              subtitle: '',
              showDivider: true,
            ),
            if (viewModel.isLoadingDetail)
              const Expanded(
                child: Center(
                  child: CircularProgressIndicator(
                    color: AppColors.tertiary500,
                  ),
                ),
              )
            else
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppDimens.spaceMd),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppDimens.spaceSm),
                        decoration: BoxDecoration(
                          color: AppColors.tertiary50,
                          borderRadius: BorderRadius.circular(AppDimens.boraMd),
                          border: Border.all(
                            color: AppColors.tertiary500,
                            width: 1.0,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.info_outline,
                              color: AppColors.tertiary500,
                              size: 32,
                            ),
                            const SizedBox(width: AppDimens.spaceMd),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Review part details for inventory update',
                                    style: TextStyles.bodyLarge.copyWith(
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    'Enter the details of the part that was not found in the inventory system.',
                                    style: TextStyles.label.copyWith(
                                      color: AppColors.secondary300,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppDimens.spaceLg),
                      // Request Status
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Request Status',
                            style: TextStyles.title.copyWith(
                              color: AppColors.primary500,
                            ),
                          ),
                          if (!viewModel.isReviewed)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppDimens.spaceSm,
                                vertical: 4.0,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    (viewModel.status.toLowerCase() == 'pending'
                                            ? AppColors.warning500
                                            : (viewModel.status.toLowerCase() ==
                                                      'approved'
                                                  ? AppColors.success500
                                                  : AppColors.error500))
                                        .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(
                                  AppDimens.boraSm,
                                ),
                                border: Border.all(
                                  color:
                                      viewModel.status.toLowerCase() ==
                                          'pending'
                                      ? AppColors.warning500
                                      : (viewModel.status.toLowerCase() ==
                                                'approved'
                                            ? AppColors.success500
                                            : AppColors.error500),
                                  width: 1.0,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 8.0,
                                    height: 8.0,
                                    decoration: BoxDecoration(
                                      color:
                                          viewModel.status.toLowerCase() ==
                                              'pending'
                                          ? AppColors.warning500
                                          : (viewModel.status.toLowerCase() ==
                                                    'approved'
                                                ? AppColors.success500
                                                : AppColors.error500),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: AppDimens.spaceSm),
                                  Text(
                                    viewModel.status,
                                    style: TextStyles.label.copyWith(
                                      color:
                                          viewModel.status.toLowerCase() ==
                                              'pending'
                                          ? AppColors.warning500
                                          : (viewModel.status.toLowerCase() ==
                                                    'approved'
                                                ? AppColors.success500
                                                : AppColors.error500),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      if (viewModel.isReviewed) ...[
                        const SizedBox(height: 8.0),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(
                              AppDimens.boraSm,
                            ),
                            border: Border.all(
                              color: AppColors.secondary200,
                              width: 1.0,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                              AppDimens.boraSm,
                            ),
                            child: IntrinsicHeight(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Container(
                                    width: 6.0,
                                    color:
                                        viewModel.status.toLowerCase() ==
                                            'approved'
                                        ? AppColors.success500
                                        : AppColors.error500,
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: AppDimens.spaceMd,
                                        vertical: 10.0,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            viewModel.status.toLowerCase() ==
                                                    'approved'
                                                ? 'Approved By'
                                                : 'Rejected By',
                                            style: TextStyles.middle.copyWith(
                                              color:
                                                  viewModel.status
                                                          .toLowerCase() ==
                                                      'approved'
                                                  ? AppColors.success500
                                                  : AppColors.error500,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 6.0),
                                          if (viewModel.status.toLowerCase() ==
                                              'approved') ...[
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.person_outline,
                                                  color: AppColors.success300,
                                                  size: 16.0,
                                                ),
                                                const SizedBox(
                                                  width: AppDimens.spaceXs,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    viewModel.reviewedBy ??
                                                        'Admin',
                                                    style: TextStyles.bodyLarge
                                                        .copyWith(
                                                          color: AppColors
                                                              .primary500,
                                                        ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 4.0),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.access_time,
                                                  color: AppColors.success300,
                                                  size: 16.0,
                                                ),
                                                const SizedBox(
                                                  width: AppDimens.spaceXs,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    viewModel
                                                            .reviewedAtFormatted ??
                                                        'N/A',
                                                    style: TextStyles.bodyLarge
                                                        .copyWith(
                                                          color: AppColors
                                                              .primary500,
                                                        ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ] else ...[
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.person_outline,
                                                  color: AppColors.error300,
                                                  size: 16.0,
                                                ),
                                                const SizedBox(
                                                  width: AppDimens.spaceXs,
                                                ),
                                                Text(
                                                  viewModel.reviewedBy ??
                                                      'Admin',
                                                  style: TextStyles.bodyLarge
                                                      .copyWith(
                                                        color: AppColors
                                                            .primary500,
                                                      ),
                                                ),
                                                const SizedBox(
                                                  width: AppDimens.spaceXl,
                                                ),
                                                Icon(
                                                  Icons.access_time,
                                                  color: AppColors.error300,
                                                  size: 16.0,
                                                ),
                                                const SizedBox(
                                                  width: AppDimens.spaceXs,
                                                ),
                                                Text(
                                                  viewModel
                                                          .reviewedAtFormatted ??
                                                      'N/A',
                                                  style: TextStyles.bodyLarge
                                                      .copyWith(
                                                        color: AppColors
                                                            .primary500,
                                                      ),
                                                ),
                                              ],
                                            ),
                                            if (viewModel.denialReason !=
                                                    null &&
                                                viewModel
                                                    .denialReason!
                                                    .isNotEmpty) ...[
                                              const SizedBox(height: 6.0),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.assignment_outlined,
                                                    color: AppColors.error300,
                                                    size: 16.0,
                                                  ),
                                                  const SizedBox(
                                                    width: AppDimens.spaceXs,
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      viewModel.denialReason!,
                                                      style: TextStyles
                                                          .bodyLarge
                                                          .copyWith(
                                                            color: AppColors
                                                                .primary500,
                                                          ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ],
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: AppDimens.spaceMd),
                      AdminTextField(
                        label: 'Part Name',
                        hint: '',
                        controller: viewModel.partNameController,
                        readOnly: true,
                      ),
                      const SizedBox(height: AppDimens.spaceMd),
                      Text(
                        'Part Category',
                        style: TextStyles.title.copyWith(
                          color: AppColors.primary500,
                        ),
                      ),
                      const SizedBox(height: AppDimens.spaceXs),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimens.spaceSm,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.secondary50,
                          borderRadius: BorderRadius.circular(AppDimens.boraMd),
                          border: Border.all(
                            color: AppColors.secondary100,
                            width: 1.0,
                          ),
                          boxShadow: [BoxShadowStyles.subtle],
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: viewModel.selectedCategory,
                            isExpanded: true,
                            icon: const SizedBox.shrink(),
                            items: viewModel.categories.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyles.bodyLarge.copyWith(
                                    color: AppColors.secondary500,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: viewModel.setCategory,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppDimens.spaceMd),
                      Row(
                        children: [
                          Expanded(
                            child: AdminTextField(
                              label: 'MTM',
                              hint: '',
                              controller: viewModel.mtmController,
                              readOnly: true,
                            ),
                          ),
                          const SizedBox(width: AppDimens.spaceMd),
                          Expanded(
                            child: AdminTextField(
                              label: 'Serial Number',
                              hint: '',
                              controller: viewModel.serialNumberController,
                              readOnly: true,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppDimens.spaceMd),
                      AdminTextField(
                        label: 'Description / Notes',
                        hint: '',
                        controller: viewModel.descriptionController,
                        maxLines: 4,
                        readOnly: true,
                      ),
                      const SizedBox(height: AppDimens.spaceLg),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Part Photo',
                            style: TextStyles.title.copyWith(
                              color: AppColors.primary500,
                            ),
                          ),
                          Text(
                            'MAX: 5 PHOTOS',
                            style: TextStyles.label.copyWith(
                              color: AppColors.tertiary500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppDimens.spaceSm),
                      viewModel.photoUrls.isEmpty
                          ? Container(
                              alignment: Alignment.center,
                              height: 80.0,
                              decoration: BoxDecoration(
                                color: AppColors.secondary50,
                                borderRadius: BorderRadius.circular(
                                  AppDimens.boraSm,
                                ),
                              ),
                              child: Text(
                                'No photos uploaded',
                                style: TextStyles.bodyMedium.copyWith(
                                  color: AppColors.secondary300,
                                ),
                              ),
                            )
                          : SizedBox(
                              height: 80.0,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: viewModel.photoUrls.length,
                                separatorBuilder: (_, _) =>
                                    const SizedBox(width: AppDimens.spaceSm),
                                itemBuilder: (context, index) {
                                  final url = viewModel.photoUrls[index];
                                  return AppNetworkImage(
                                    url: url.startsWith('http') ? url : null,
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                    borderRadius: BorderRadius.circular(
                                      AppDimens.boraSm,
                                    ),
                                    errorWidget:
                                        !url.startsWith('http') &&
                                            url.isNotEmpty
                                        ? Image.asset(
                                            url,
                                            width: 80,
                                            height: 80,
                                            fit: BoxFit.cover,
                                          )
                                        : null,
                                  );
                                },
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            // Hide approve/reject buttons if part is already approved
            if (!viewModel.isApproved && !viewModel.isLoadingDetail)
              Container(
                padding: const EdgeInsets.all(AppDimens.spaceMd),
                color: AppColors.background500,
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.tertiary50,
                          borderRadius: BorderRadius.circular(AppDimens.boraMd),
                          boxShadow: [BoxShadowStyles.subtle],
                        ),
                        child: TextButton(
                          onPressed: viewModel.isProcessing
                              ? null
                              : () => _showRejectDialog(context, viewModel),
                          child: viewModel.isProcessing
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  'Reject',
                                  style: TextStyles.title.copyWith(
                                    color: AppColors.tertiary500,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppDimens.spaceMd),
                    Expanded(
                      flex: 2,
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.tertiary500,
                          borderRadius: BorderRadius.circular(AppDimens.boraMd),
                          boxShadow: [BoxShadowStyles.glowing],
                        ),
                        child: TextButton(
                          onPressed: viewModel.isProcessing
                              ? null
                              : () async {
                                  final success = await viewModel.acceptPart();
                                  if (context.mounted) {
                                    if (success) {
                                      Navigator.of(context).pop(true);
                                    } else {
                                      ZentErrorPopup.show(
                                        context,
                                        'Failed to approve part request',
                                      );
                                    }
                                  }
                                },
                          child: viewModel.isProcessing
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  'Approve',
                                  style: TextStyles.title.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
