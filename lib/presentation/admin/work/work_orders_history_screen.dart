import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:zent_fe/di/injection_container.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/presentation/common/core/themes/boxshadow.dart';
import 'package:zent_fe/domain/entities/work_order.dart';
import 'package:zent_fe/domain/entities/enums/user_roles.dart';
import 'package:zent_fe/domain/entities/enums/work_order_status.dart';
import 'package:zent_fe/routing/route_names.dart';
import 'viewmodels/work_orders_history_viewmodel.dart';
import 'package:intl/intl.dart';

class WorkOrdersHistoryScreen extends StatefulWidget {
  const WorkOrdersHistoryScreen({super.key});

  @override
  State<WorkOrdersHistoryScreen> createState() =>
      _WorkOrdersHistoryScreenState();
}

class _WorkOrdersHistoryScreenState extends State<WorkOrdersHistoryScreen> {
  late final WorkOrdersHistoryViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = sl<WorkOrdersHistoryViewModel>();
    _viewModel.loadWorkOrders();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Scaffold(
        backgroundColor: AppColors.background500,
        appBar: AppBar(
          backgroundColor: AppColors.surface100,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: AppColors.primary500,
              size: 20,
            ),
            onPressed: () => Navigator.maybePop(context),
          ),
          title: Text(
            'Work Orders History',
            style: TextStyles.title.copyWith(
              color: AppColors.primary500,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(1.0),
            child: Divider(height: 1.0, color: AppColors.secondary50),
          ),
        ),
        body: Consumer<WorkOrdersHistoryViewModel>(
          builder: (context, vm, child) {
            if (vm.isLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.tertiary500),
              );
            }

            return SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: AppDimens.spaceMd),
                  // Search Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimens.spaceMd,
                    ),
                    child: _buildSearchBar(vm),
                  ),
                  const SizedBox(height: AppDimens.spaceSm),

                  // Filter Tabs (only for Admin and Tech)
                  if (vm.filters.isNotEmpty) ...[
                    _buildFilterTabs(vm),
                    const SizedBox(height: AppDimens.spaceSm),
                  ],

                  // Work Order List
                  Expanded(
                    child: vm.displayOrders.isEmpty
                        ? _buildEmptyState()
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppDimens.spaceMd,
                              vertical: AppDimens.spaceSm,
                            ),
                            itemCount: vm.displayOrders.length,
                            itemBuilder: (context, index) {
                              final wo = vm.displayOrders[index];
                              return _buildWorkOrderCard(context, vm, wo);
                            },
                          ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Search Bar
  // ──────────────────────────────────────────────────────────────────────────
  Widget _buildSearchBar(WorkOrdersHistoryViewModel vm) {
    return Container(
      height: 44.0,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimens.boraSm),
        border: Border.all(color: AppColors.secondary200, width: 1.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Icon(
              Icons.search,
              color: AppColors.secondary300,
              size: 20.0,
            ),
          ),
          Expanded(
            child: TextField(
              onChanged: vm.setSearchQuery,
              style: TextStyles.bodyLarge.copyWith(
                height: 1.2,
                color: AppColors.secondary500,
              ),
              decoration: InputDecoration(
                isDense: true,
                hintText: 'Search work orders by work order number',
                hintStyle: TextStyles.bodyLarge.copyWith(
                  color: AppColors.secondary200,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 8.5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Filter Tabs
  // ──────────────────────────────────────────────────────────────────────────
  Widget _buildFilterTabs(WorkOrdersHistoryViewModel vm) {
    return SizedBox(
      height: 40.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceMd),
        itemCount: vm.filters.length,
        itemBuilder: (context, index) {
          final isSelected = vm.selectedFilterIndex == index;
          return GestureDetector(
            onTap: () => vm.setFilterIndex(index),
            child: Container(
              margin: const EdgeInsets.only(right: AppDimens.spaceSm),
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.spaceMd,
              ),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.tertiary500 : Colors.white,
                borderRadius: BorderRadius.circular(20.0),
                border: isSelected
                    ? null
                    : Border.all(color: AppColors.secondary100),
              ),
              child: Text(
                vm.filters[index],
                style: TextStyles.bodyLarge.copyWith(
                  color: isSelected ? Colors.white : AppColors.secondary500,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Work Order Card
  // ──────────────────────────────────────────────────────────────────────────
  Widget _buildWorkOrderCard(
    BuildContext context,
    WorkOrdersHistoryViewModel vm,
    WorkOrder wo,
  ) {
    final isCustomer = vm.currentUser?.role == UserRoles.customer;

    return Container(
      width: 364.0,
      height: 135.0,
      margin: const EdgeInsets.only(bottom: AppDimens.spaceSm),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimens.boraSm),
        border: Border.all(color: Colors.black, width: 1.0),
        boxShadow: [BoxShadowStyles.raised],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppDimens.boraSm),
          onTap: () {
            context.pushNamed(
              RouteNames.adminDetailedHistory,
              pathParameters: {'workOrderId': wo.id},
            );
          },
          child: Padding(
            padding: const EdgeInsets.only(
              top: 12.0,
              bottom: 8.0,
              left: 12.0,
              right: 12.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Top Row: WO Number & Status/Triple Dot
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '#${wo.workOrderNum}',
                      style: TextStyles.middle.copyWith(
                        fontSize: 18.0,
                        color: AppColors.tertiary500,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (isCustomer)
                      _buildCustomerPopupMenu(context, wo)
                    else
                      _buildStatusLabel(wo),
                  ],
                ),

                // Middle: Product Name (title)
                Text(
                  wo.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyles.headline.copyWith(
                    fontSize: 24.0,
                    color: AppColors.primary500,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                // Bottom: 3 Info Rows (Name, Address, Last Updated)
                Column(
                  children: [
                    // Row 1: Name
                    Row(
                      children: [
                        const Icon(
                          Icons.person_outline,
                          size: 14.0,
                          color: AppColors.secondary400,
                        ),
                        const SizedBox(width: 4.0),
                        Expanded(
                          child: Text(
                            isCustomer
                                ? (wo.technicianName ?? 'Unassigned')
                                : wo.customerName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyles.label.copyWith(
                              color: AppColors.secondary400,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2.0),
                    // Row 2: Address
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 14.0,
                          color: AppColors.secondary400,
                        ),
                        const SizedBox(width: 4.0),
                        Expanded(
                          child: Text(
                            wo.addressString,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyles.label.copyWith(
                              color: AppColors.secondary400,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2.0),
                    // Row 3: Last Updated
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          size: 14.0,
                          color: AppColors.secondary400,
                        ),
                        const SizedBox(width: 4.0),
                        Expanded(
                          child: Text(
                            DateFormat(
                              'dd MMM yyyy, HH:mm',
                            ).format(wo.updatedAt.toLocal()),
                            style: TextStyles.label.copyWith(
                              color: AppColors.secondary400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Status Label (Admin / Tech)
  // ──────────────────────────────────────────────────────────────────────────
  Widget _buildStatusLabel(WorkOrder wo) {
    String label = "";
    Color color = AppColors.tertiary500;

    switch (wo.status) {
      case WorkOrderStatus.pending:
        if (wo.technicianId.isEmpty) {
          label = "Unassigned";
          color = AppColors.error300;
        } else {
          label = "Assigned";
          color = AppColors.tertiary500;
        }
        break;
      case WorkOrderStatus.inProg:
        label = "InProg";
        color = AppColors.tertiary500;
        break;
      case WorkOrderStatus.complete:
        label = "Completed";
        color = AppColors.success500;
        break;
      case WorkOrderStatus.rejectInReview:
        label = "Reject_Rev";
        color = AppColors.error400;
        break;
      case WorkOrderStatus.rejected:
        label = "Rejected";
        color = AppColors.error500;
        break;
    }

    return Text(
      label,
      style: TextStyles.label.copyWith(
        color: color,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Customer Triple-Dot Popup Menu
  // ──────────────────────────────────────────────────────────────────────────
  Widget _buildCustomerPopupMenu(BuildContext context, WorkOrder wo) {
    return PopupMenuButton<String>(
      constraints: const BoxConstraints(minWidth: 181.0, maxWidth: 181.0),
      padding: EdgeInsets.zero,
      offset: const Offset(0, 36),
      elevation: 8,
      color: Colors.white,
      shadowColor: BoxShadowStyles.overlay.color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.boraSm),
      ),
      child: const Icon(
        Icons.more_horiz,
        color: AppColors.secondary400,
        size: 24.0,
      ),
      itemBuilder: (context) => [
        PopupMenuItem<String>(
          enabled: false,
          padding: EdgeInsets.zero,
          child: Container(
            width: double.infinity,
            height: 88,
            padding: const EdgeInsets.only(
              left: 10.0,
              right: 2.0,
              top: 2.0,
              bottom: 2.0,
            ),
            child: Column(
              children: [
                // Survey Button
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    _showSurveyDialog(context, wo);
                  },
                  child: Container(
                    width: double.infinity,
                    height: 38,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppDimens.boraXs),
                      boxShadow: [BoxShadowStyles.subtle],
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "Survey",
                      style: TextStyles.label.copyWith(
                        color: AppColors.primary500,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8.0),
                // Complaint Button
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    _showComplaintDialog(context, wo);
                  },
                  child: Container(
                    width: double.infinity,
                    height: 38,
                    decoration: BoxDecoration(
                      color: AppColors.error50,
                      borderRadius: BorderRadius.circular(AppDimens.boraXs),
                      boxShadow: [BoxShadowStyles.subtle],
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "Complaint",
                      style: TextStyles.label.copyWith(
                        color: AppColors.error500,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Customer Survey / Complaint Popup Screens
  // ──────────────────────────────────────────────────────────────────────────
  void _showSurveyDialog(BuildContext context, WorkOrder wo) {
    int rating = 5;
    final notesController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.boraSm),
          ),
          title: Text(
            'Work Order Survey',
            style: TextStyles.title.copyWith(
              color: AppColors.primary500,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'How would you rate our repair service?',
                style: TextStyles.bodyLarge,
              ),
              const SizedBox(height: AppDimens.spaceSm),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  final score = index + 1;
                  return IconButton(
                    icon: Icon(
                      score <= rating ? Icons.star : Icons.star_border,
                      color: AppColors.warning500,
                      size: 32,
                    ),
                    onPressed: () => setState(() => rating = score),
                  );
                }),
              ),
              const SizedBox(height: AppDimens.spaceMd),
              TextField(
                controller: notesController,
                maxLines: 3,
                style: TextStyles.bodyLarge,
                decoration: InputDecoration(
                  hintText: 'Share your feedback details...',
                  hintStyle: TextStyle(color: AppColors.secondary200),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDimens.boraSm),
                    borderSide: const BorderSide(color: AppColors.secondary200),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(color: AppColors.secondary400),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary500,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimens.boraSm),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Survey submitted successfully! Thank you.'),
                    backgroundColor: AppColors.success500,
                  ),
                );
              },
              child: const Text(
                'Submit',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showComplaintDialog(BuildContext context, WorkOrder wo) {
    final complaintController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.boraSm),
        ),
        title: Text(
          'Submit Complaint',
          style: TextStyles.title.copyWith(
            color: AppColors.error500,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Please describe your issue below:',
              style: TextStyles.bodyLarge,
            ),
            const SizedBox(height: AppDimens.spaceSm),
            TextField(
              controller: complaintController,
              maxLines: 4,
              style: TextStyles.bodyLarge,
              decoration: InputDecoration(
                hintText: 'Enter your complaint details here...',
                hintStyle: TextStyle(color: AppColors.secondary200),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimens.boraSm),
                  borderSide: const BorderSide(color: AppColors.error200),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: AppColors.secondary400),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error500,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimens.boraSm),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Complaint submitted successfully. We will review it shortly.',
                  ),
                  backgroundColor: AppColors.error500,
                ),
              );
            },
            child: const Text('Submit', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history_toggle_off,
            size: 64.0,
            color: AppColors.secondary200.withValues(alpha: 0.8),
          ),
          const SizedBox(height: AppDimens.spaceSm),
          Text(
            'No History Work Orders Found',
            style: TextStyles.middle.copyWith(
              color: AppColors.secondary400,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
