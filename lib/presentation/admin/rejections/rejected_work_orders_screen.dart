import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/di/injection_container.dart' as di;
import 'package:zent_fe/routing/route_names.dart';
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
      body: viewModel.isLoading && viewModel.workOrders.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: viewModel.loadRejectedWorkOrders,
              child: ListView.builder(
                padding: const EdgeInsets.all(AppDimens.spaceLg),
                itemCount: viewModel.workOrders.length,
                itemBuilder: (context, index) {
                  final wo = viewModel.workOrders[index];
                  return RejectedWorkOrderCard(
                    workOrder: wo,
                    onApprove: () => _handleApprove(context, viewModel, wo),
                    onDeny: () => _handleDeny(context, viewModel, wo.id),
                    onDetailTap: () => context.goNamed(
                      RouteNames.adminRejectionDetail,
                      pathParameters: {'id': wo.id},
                    ),
                  );
                },
              ),
            ),
    );
  }

  void _handleApprove(
    BuildContext context,
    RejectedWorkOrdersViewModel viewModel,
    dynamic wo,
  ) {
    viewModel.approveRejection(wo).then((error) {
      if (error != null && context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $error')));
      }
    });
  }

  void _handleDeny(
    BuildContext context,
    RejectedWorkOrdersViewModel viewModel,
    String id,
  ) {
    viewModel.denyRejection(id).then((error) {
      if (error != null && context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $error')));
      }
    });
  }
}
