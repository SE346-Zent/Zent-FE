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
          onTap: isCustomer
              ? null
              : () {
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
      constraints: const BoxConstraints(minWidth: 140.0, maxWidth: 140.0),
      padding: EdgeInsets.zero,
      offset: const Offset(0, 10),
      elevation: 0,
      color: Colors.transparent,
      shadowColor: Colors.transparent,
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
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
                _showRatingDialog(context, wo);
              },
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppDimens.boraXs),
                  border: Border.all(color: AppColors.secondary200, width: 1.0),
                ),
                alignment: Alignment.center,
                child: Text(
                  "Rate",
                  style: TextStyles.label.copyWith(
                    color: AppColors.primary500,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Customer Rating Popup Screen
  // ──────────────────────────────────────────────────────────────────────────
  void _showRatingDialog(BuildContext context, WorkOrder wo) {
    int rating = 5;
    final commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Dialog(
          backgroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 24.0,
            vertical: 24.0,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.boraSm),
          ),
          child: Container(
            width: 340,
            padding: const EdgeInsets.all(AppDimens.spaceLg),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppDimens.boraSm),
              boxShadow: [BoxShadowStyles.overlay],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Rating this work order',
                    style: TextStyles.title.copyWith(
                      color: AppColors.primary500,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: AppDimens.spaceLg),
                Text(
                  'Rating',
                  style: TextStyles.bodyLarge.copyWith(
                    color: AppColors.primary500,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppDimens.spaceSm),
                Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        final score = index + 1;
                        final isFilled = score <= rating;
                        return GestureDetector(
                          onTap: () => setState(() => rating = score),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 3.0),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Outer smooth black border backing the star peak
                                const Icon(
                                  Icons.star_rounded,
                                  color: Colors.black87,
                                  size: 38,
                                ),
                                // Inner filled star (gold if filled, clean white if empty)
                                Icon(
                                  Icons.star_rounded,
                                  color: isFilled
                                      ? const Color(0xFFFBBC05)
                                      : Colors.white,
                                  size: 34,
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
                const SizedBox(height: AppDimens.spaceLg),
                Text(
                  'Comment',
                  style: TextStyles.bodyLarge.copyWith(
                    color: AppColors.primary500,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppDimens.spaceSm),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface50,
                    borderRadius: BorderRadius.circular(AppDimens.boraSm),
                    border: Border.all(
                      color: AppColors.secondary200,
                      width: 1.0,
                    ),
                  ),
                  child: TextField(
                    controller: commentController,
                    maxLines: 4,
                    style: TextStyles.bodyMedium.copyWith(
                      color: AppColors.secondary500,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(AppDimens.spaceSm),
                      hintText: 'Share your feeling about this work order',
                      hintStyle: TextStyles.bodyMedium.copyWith(
                        color: AppColors.secondary200,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppDimens.spaceLg),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Cancel',
                        style: TextStyles.bodyMedium.copyWith(
                          color: AppColors.secondary400,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppDimens.spaceSm),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary500,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppDimens.boraSm),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimens.spaceMd,
                          vertical: 10,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Rating submitted successfully! Thank you.',
                            ),
                            backgroundColor: AppColors.success500,
                          ),
                        );
                      },
                      child: Text(
                        'Submit',
                        style: TextStyles.bodyMedium.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
