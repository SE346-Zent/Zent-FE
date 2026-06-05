import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/presentation/common/core/ui/zent_success_popup.dart';
import 'package:zent_fe/presentation/common/core/ui/zent_error_popup.dart';
import 'package:zent_fe/di/injection_container.dart' as di;
import 'package:zent_fe/routing/route_names.dart';
import 'package:zent_fe/domain/entities/reject_form.dart';
import 'viewmodels/rejected_work_orders_viewmodel.dart';
import 'widgets/rejected_work_order_card.dart';

class RejectedWorkOrdersScreen extends StatelessWidget {
  const RejectedWorkOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          di.sl<RejectedWorkOrdersViewModel>()..loadRejectedWorkOrders(),
      child: const _RejectedWorkOrdersContent(),
    );
  }
}

class _RejectedWorkOrdersContent extends StatelessWidget {
  const _RejectedWorkOrdersContent();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<RejectedWorkOrdersViewModel>();

    return Scaffold(
      backgroundColor: AppColors.background500,
      appBar: AppBar(
        backgroundColor: AppColors.background500,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Rejected Work Orders',
          style: TextStyles.headline.copyWith(color: AppColors.primary500),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: AppColors.secondary50, height: 1.0),
        ),
      ),
      body: viewModel.isLoading && viewModel.rejectForms.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: viewModel.loadRejectedWorkOrders,
              child: viewModel.rejectForms.isEmpty
                  ? LayoutBuilder(
                      builder: (context, constraints) {
                        return SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: constraints.maxHeight,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.assignment_turned_in_outlined,
                                  size: 64,
                                  color: AppColors.secondary300,
                                ),
                                const SizedBox(height: AppDimens.spaceMd),
                                Center(
                                  child: Text(
                                    'No rejected work orders',
                                    style: TextStyles.bodyLarge.copyWith(
                                      color: AppColors.secondary400,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(AppDimens.spaceLg),
                      itemCount: viewModel.rejectForms.length,
                      itemBuilder: (context, index) {
                        final form = viewModel.rejectForms[index];
                        return RejectedWorkOrderCard(
                          rejectForm: form,
                          onApprove: () =>
                              _handleApprove(context, viewModel, form),
                          onDeny: () =>
                              _handleDeny(context, viewModel, form.workOrderId),
                          onDetailTap: () async {
                            final refresh = await context.pushNamed<bool>(
                              RouteNames.adminRejectionDetail,
                              pathParameters: {'id': form.id},
                            );
                            if (refresh == true && context.mounted) {
                              ZentSuccessPopup.show(
                                context,
                                'Rejection request resolved successfully!',
                              );
                              viewModel.loadRejectedWorkOrders();
                            }
                          },
                        );
                      },
                    ),
            ),
    );
  }

  Future<void> _handleApprove(
    BuildContext context,
    RejectedWorkOrdersViewModel viewModel,
    RejectForm form,
  ) async {
    final error = await viewModel.approveRejection(form);
    if (!context.mounted) return;
    if (error != null) {
      ZentErrorPopup.show(context, 'Error: $error');
    } else {
      ZentSuccessPopup.show(
        context,
        'Approved work order rejection successfully!',
      );
    }
  }

  Future<void> _handleDeny(
    BuildContext context,
    RejectedWorkOrdersViewModel viewModel,
    String workOrderId,
  ) async {
    final error = await viewModel.denyRejection(workOrderId);
    if (!context.mounted) return;
    if (error != null) {
      ZentErrorPopup.show(context, 'Error: $error');
    } else {
      ZentSuccessPopup.show(
        context,
        'Denied work order rejection successfully!',
      );
    }
  }
}
