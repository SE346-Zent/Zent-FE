import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/presentation/common/core/ui/zent_error_popup.dart';
import 'package:zent_fe/presentation/common/core/themes/boxshadow.dart';
import 'package:zent_fe/di/injection_container.dart' as di;
import 'viewmodels/rejection_detail_viewmodel.dart';

class RejectionDetailScreen extends StatelessWidget {
  final String workOrderId;

  const RejectionDetailScreen({super.key, required this.workOrderId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          di.sl<RejectionDetailViewModel>()..loadDetails(workOrderId),
      child: const _RejectionDetailContent(),
    );
  }
}

class _RejectionDetailContent extends StatelessWidget {
  const _RejectionDetailContent();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<RejectionDetailViewModel>();
    final wo = viewModel.workOrder;

    return Scaffold(
      backgroundColor: AppColors.background500,
      appBar: AppBar(
        backgroundColor: AppColors.background500,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: Column(
          children: [
            Text(
              'Rejection Detail',
              style: TextStyles.headline.copyWith(color: AppColors.primary500),
            ),
            if (wo != null)
              Text(
                '#${wo.id}',
                style: TextStyles.bodyMedium.copyWith(
                  color: AppColors.secondary400,
                ),
              ),
          ],
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: AppColors.secondary50, height: 1.0),
        ),
      ),
      body: viewModel.isLoading && wo == null
          ? const Center(child: CircularProgressIndicator())
          : wo == null
          ? const Center(child: Text('Work order not found'))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(AppDimens.spaceLg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppDimens.spaceLg),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppDimens.boraSm),
                      boxShadow: [BoxShadowStyles.raised],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.cancel_outlined,
                              color: AppColors.tertiary500,
                              size: 17,
                            ),
                            const SizedBox(width: 8.0),
                            Text(
                              'Reason',
                              style: TextStyles.middle.copyWith(
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        Padding(
                          padding: const EdgeInsets.only(left: 25.0),
                          child: Text(
                            wo.refusalReason,
                            style: TextStyles.bodyLarge.copyWith(
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppDimens.spaceLg),
                        Row(
                          children: [
                            const Icon(
                              Icons.description_outlined,
                              color: AppColors.tertiary500,
                              size: 17,
                            ),
                            const SizedBox(width: 8.0),
                            Text(
                              'Explanation',
                              style: TextStyles.middle.copyWith(
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        Padding(
                          padding: const EdgeInsets.only(left: 25.0),
                          child: Text(
                            '"${wo.refusalNote}"',
                            style: TextStyles.bodyLarge.copyWith(
                              color: AppColors.secondary500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppDimens.spaceXl),
                  Text(
                    'Evidence Photos',
                    style: TextStyles.title.copyWith(color: Colors.black),
                  ),
                  const SizedBox(height: AppDimens.spaceMd),
                  if (wo.rejectionPhotos.isEmpty)
                    Text(
                      'No evidence photos provided.',
                      style: TextStyles.bodyMedium.copyWith(
                        color: AppColors.secondary400,
                      ),
                    )
                  else
                    Wrap(
                      spacing: AppDimens.spaceMd,
                      runSpacing: AppDimens.spaceMd,
                      children: wo.rejectionPhotos.map((url) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(AppDimens.boraSm),
                          child: Image.network(
                            url,
                            width: 90,
                            height: 90,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                                  width: 90,
                                  height: 90,
                                  color: AppColors.secondary100,
                                  child: const Icon(Icons.image_not_supported),
                                ),
                          ),
                        );
                      }).toList(),
                    ),
                ],
              ),
            ),
      bottomNavigationBar: wo == null
          ? null
          : Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.spaceLg,
                vertical: AppDimens.spaceMd,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: viewModel.isLoading
                            ? null
                            : () async {
                                final error = await viewModel.denyRejection();
                                if (context.mounted) {
                                  if (error != null) {
                                    ZentErrorPopup.show(context, error);
                                  } else {
                                    context.pop();
                                  }
                                }
                              },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: AppColors.tertiary500,
                            borderRadius: BorderRadius.circular(
                              AppDimens.boraSm,
                            ),
                            boxShadow: [BoxShadowStyles.glowing],
                          ),
                          alignment: Alignment.center,
                          child: viewModel.isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  'Deny',
                                  style: TextStyles.middle.copyWith(
                                    color: Colors.white,
                                    fontSize: 19,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppDimens.spaceMd),
                    Expanded(
                      child: GestureDetector(
                        onTap: viewModel.isLoading
                            ? null
                            : () async {
                                final error = await viewModel
                                    .approveRejection();
                                if (context.mounted) {
                                  if (error != null) {
                                    ZentErrorPopup.show(context, error);
                                  } else {
                                    context.pop();
                                  }
                                }
                              },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: AppColors.surface600,
                            borderRadius: BorderRadius.circular(
                              AppDimens.boraSm,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: viewModel.isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: AppColors.primary500,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  'Approve',
                                  style: TextStyles.middle.copyWith(
                                    color: AppColors.primary500,
                                    fontSize: 19,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
