import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/presentation/common/core/themes/boxshadow.dart';
import 'package:zent_fe/presentation/common/core/ui/button.dart';
import 'package:zent_fe/di/injection_container.dart' as di;
import 'viewmodels/admin_rejection_detail_viewmodel.dart';

class AdminRejectionDetailScreen extends StatelessWidget {
  final String workOrderId;

  const AdminRejectionDetailScreen({super.key, required this.workOrderId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          di.sl<AdminRejectionDetailViewModel>()..loadDetails(workOrderId),
      child: Consumer<AdminRejectionDetailViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading && viewModel.workOrder == null) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          final wo = viewModel.workOrder;
          if (wo == null) {
            return Scaffold(
              appBar: AppBar(),
              body: const Center(child: Text("Work Order not found")),
            );
          }

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
                'Rejection Request',
                style: TextStyles.headline.copyWith(
                  color: AppColors.primary500,
                ),
              ),
              centerTitle: true,
            ),
            body: Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.all(AppDimens.spaceLg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSection(
                        title: 'Work Order Details',
                        child: Column(
                          children: [
                            _buildInfoRow('ID', '#${wo.id}'),
                            _buildInfoRow('Device', wo.title),
                            _buildInfoRow('Customer', wo.customerName),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppDimens.spaceLg),
                      _buildSection(
                        title: 'Technician Info',
                        child: Column(
                          children: [
                            _buildInfoRow('Name', wo.technicianName ?? 'N/A'),
                            _buildInfoRow(
                              'Submitted At',
                              wo.updatedAt.toString(),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppDimens.spaceLg),
                      _buildSection(
                        title: 'Rejection Details',
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Reason:',
                              style: TextStyles.label.copyWith(
                                color: AppColors.secondary500,
                              ),
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              wo.refusalReason,
                              style: TextStyles.title.copyWith(
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: AppDimens.spaceMd),
                            Text(
                              'Explanation:',
                              style: TextStyles.label.copyWith(
                                color: AppColors.secondary500,
                              ),
                            ),
                            const SizedBox(height: 4.0),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(AppDimens.spaceMd),
                              decoration: BoxDecoration(
                                color: AppColors.surface100,
                                borderRadius: BorderRadius.circular(
                                  AppDimens.boraSm,
                                ),
                              ),
                              child: Text(
                                wo.refusalNote,
                                style: TextStyles.bodyLarge.copyWith(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppDimens.spaceXl),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () =>
                                  _handleAction(context, viewModel, 'denied'),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                side: const BorderSide(color: Colors.red),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    AppDimens.boraSm,
                                  ),
                                ),
                              ),
                              child: Text(
                                'Deny',
                                style: TextStyles.title.copyWith(
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: AppDimens.spaceMd),
                          Expanded(
                            child: PrimaryActionButton(
                              label: 'Approve',
                              onPressed: () =>
                                  _handleAction(context, viewModel, 'approved'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
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

  Widget _buildSection({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimens.spaceMd),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimens.boraMd),
        boxShadow: [BoxShadowStyles.raised],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyles.middle.copyWith(color: AppColors.tertiary500),
          ),
          const Divider(height: AppDimens.spaceLg),
          child,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyles.bodyLarge.copyWith(color: AppColors.secondary500),
          ),
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
      ),
    );
  }

  Future<void> _handleAction(
    BuildContext context,
    AdminRejectionDetailViewModel viewModel,
    String action,
  ) async {
    final error = await viewModel.handleAction(action);

    if (context.mounted) {
      if (error == null) {
        final message = action == 'approved'
            ? 'Rejection approved. Work order reset to Pending.'
            : 'Rejection denied. Customer notified and Work order updated.';

        debugPrint('Action Success: $message');
        context.pop();
      } else {
        debugPrint('Action Error: $error');
      }
    }
  }
}
