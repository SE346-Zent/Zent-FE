import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:zent_fe/routing/route_names.dart';
import 'package:zent_fe/di/injection_container.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/presentation/common/core/themes/boxshadow.dart';
import 'package:zent_fe/presentation/common/core/ui/app_network_image.dart';
import '../account/widgets/customer_app_bar.dart';
import 'viewmodels/detailed_product_viewmodel.dart';
import 'package:zent_fe/domain/entities/product_detail.dart';
import 'package:intl/intl.dart';

class MyDetailedProductScreen extends StatefulWidget {
  final String serialNumber;
  final String productId;
  const MyDetailedProductScreen({
    super.key,
    required this.serialNumber,
    required this.productId,
  });

  @override
  State<MyDetailedProductScreen> createState() =>
      _MyDetailedProductScreenState();
}

class _MyDetailedProductScreenState extends State<MyDetailedProductScreen> {
  late DetailedProductViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = sl<DetailedProductViewModel>();
    _viewModel.init(widget.productId);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: const _DetailedProductView(),
    );
  }
}

class _DetailedProductView extends StatelessWidget {
  const _DetailedProductView();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<DetailedProductViewModel>();
    final detail = viewModel.productDetail;

    return Scaffold(
      backgroundColor: AppColors.surface100,
      appBar: CustomerAppBar(
        title: detail?.title ?? 'Detail',
        showBackButton: true,
        showBottomDivider: true,
      ),
      body: viewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : detail == null
          ? const Center(child: Text('Product not found'))
          : SingleChildScrollView(
              padding: const EdgeInsets.only(
                left: AppDimens.spaceMd,
                right: AppDimens.spaceMd,
                top: AppDimens.spaceMd,
                bottom: AppDimens.spaceMd,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppDimens.boraMd),
                      boxShadow: [BoxShadowStyles.raised],
                      border: Border.all(
                        color: AppColors.secondary200,
                        width: 1.0,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product Image
                        AppNetworkImage(
                          url: viewModel.imagePath,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          borderRadius: BorderRadius.circular(AppDimens.boraMd),
                          enableViewer: true,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(AppDimens.spaceLg),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Product Name
                              Container(
                                margin: const EdgeInsets.only(right: 16.0),
                                child: Text(
                                  detail.title,
                                  style: TextStyles.headline.copyWith(
                                    color: Colors.black,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    height: 1.3,
                                  ),
                                ),
                              ),
                              const SizedBox(height: AppDimens.spaceMd),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      'S/N: ${detail.serialNumber}',
                                      style: TextStyles.bodyLarge.copyWith(
                                        color: AppColors.secondary500,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: AppDimens.spaceSm),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      'MTM: ${detail.modelCode}',
                                      textAlign: TextAlign.right,
                                      style: TextStyles.bodyLarge.copyWith(
                                        color: AppColors.secondary500,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),

                              const Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: AppDimens.spaceMd,
                                ),
                                child: Divider(
                                  height: 1,
                                  color: AppColors.secondary50,
                                ),
                              ),

                              // Warranty Section Title
                              Row(
                                children: [
                                  const Icon(
                                    Icons.verified_user_outlined,
                                    color: Colors.black,
                                    size: 24,
                                  ),
                                  const SizedBox(width: AppDimens.spaceSm),
                                  Text(
                                    'Warranty',
                                    style: TextStyles.headline.copyWith(
                                      color: AppColors.primary500,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppDimens.spaceMd),

                              // Warranty Status & Support Status
                              Builder(
                                builder: (context) {
                                  final endDate = detail.warranty?.endDate;
                                  final isInWarranty =
                                      endDate != null &&
                                      endDate.isAfter(DateTime.now());
                                  final remainingDays = endDate != null
                                      ? endDate
                                            .difference(DateTime.now())
                                            .inDays
                                      : -1;

                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          text: 'Warranty Status: ',
                                          style: TextStyles.bodyLarge.copyWith(
                                            color: AppColors.secondary500,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: endDate != null
                                                  ? (isInWarranty
                                                        ? 'In Warranty'
                                                        : 'Out of Warranty')
                                                  : 'No Data',
                                              style: TextStyles.bodyLarge
                                                  .copyWith(
                                                    color: endDate != null
                                                        ? (isInWarranty
                                                              ? AppColors
                                                                    .success500
                                                              : AppColors
                                                                    .error500)
                                                        : AppColors
                                                              .secondary300,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: AppDimens.spaceXs),
                                      RichText(
                                        text: TextSpan(
                                          text: 'Support Status: ',
                                          style: TextStyles.bodyLarge.copyWith(
                                            color: AppColors.secondary500,
                                          ),
                                          children: [
                                            if (endDate != null)
                                              TextSpan(
                                                text: remainingDays > 0
                                                    ? '$remainingDays days remaining'
                                                    : 'Expired',
                                                style: TextStyles.bodyLarge
                                                    .copyWith(
                                                      color: remainingDays > 0
                                                          ? AppColors.success500
                                                          : AppColors.error500,
                                                    ),
                                              )
                                            else
                                              TextSpan(
                                                text: 'No Data',
                                                style: TextStyles.bodyLarge
                                                    .copyWith(
                                                      color: AppColors
                                                          .secondary300,
                                                    ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                              const SizedBox(height: AppDimens.spaceXl),

                              // Progress Bar
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  final width = constraints.maxWidth;
                                  final startDate = detail.warranty?.startDate;
                                  final endDate = detail.warranty?.endDate;

                                  double progress = 0.0;
                                  double elapsedProportion = 0.0;
                                  bool isWarrantyAvailable = false;

                                  if (startDate != null && endDate != null) {
                                    isWarrantyAvailable = true;
                                    final totalDays = endDate
                                        .difference(startDate)
                                        .inDays;
                                    final remainingDays = endDate
                                        .difference(DateTime.now())
                                        .inDays;
                                    final elapsedDays = DateTime.now()
                                        .difference(startDate)
                                        .inDays;
                                    if (totalDays > 0) {
                                      progress = (remainingDays / totalDays)
                                          .clamp(0.0, 1.0);
                                      elapsedProportion =
                                          (elapsedDays / totalDays).clamp(
                                            0.0,
                                            1.0,
                                          );
                                    }
                                  } else if (endDate != null) {
                                    isWarrantyAvailable = true;
                                    final remainingDays = endDate
                                        .difference(DateTime.now())
                                        .inDays;
                                    const totalDays =
                                        365 * 3; // 3-year fallback
                                    progress = (remainingDays / totalDays)
                                        .clamp(0.0, 1.0);
                                    elapsedProportion = 1.0 - progress;
                                  }

                                  final todayOffset = width * elapsedProportion;

                                  return Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          const SizedBox(height: 20),
                                          Container(
                                            height: 12,
                                            decoration: BoxDecoration(
                                              color: AppColors.secondary100,
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  flex: (progress * 100)
                                                      .toInt(),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color:
                                                          AppColors.success300,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            6,
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: ((1 - progress) * 100)
                                                      .toInt(),
                                                  child: const SizedBox(),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Purchase Date\n${viewModel.purchaseDate}',
                                                style: TextStyles.label
                                                    .copyWith(
                                                      color: AppColors
                                                          .secondary400,
                                                    ),
                                              ),
                                              Text(
                                                viewModel.warrantyEndDate
                                                    .replaceAll(', ', ',\n'),
                                                textAlign: TextAlign.right,
                                                style: TextStyles.label
                                                    .copyWith(
                                                      color: AppColors
                                                          .secondary400,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      if (isWarrantyAvailable &&
                                          elapsedProportion > 0 &&
                                          elapsedProportion < 1)
                                        Positioned(
                                          left: todayOffset - 10,
                                          top: 0,
                                          child: SizedBox(
                                            width: 40,
                                            child: Text(
                                              'Today',
                                              textAlign: TextAlign.center,
                                              style: TextStyles.label.copyWith(
                                                color: AppColors.secondary400,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  );
                                },
                              ),
                              const SizedBox(height: AppDimens.spaceXl),

                              // Warranty History
                              Text(
                                'Warranty History',
                                style: TextStyles.bodyLarge.copyWith(
                                  color: AppColors.secondary500,
                                ),
                              ),
                              const SizedBox(height: AppDimens.spaceSm),
                              _buildHistorySection(detail),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppDimens.spaceXl),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: _buildBottomButton('Repair Status', () {
                          final activeId = viewModel.activeWorkOrderId;
                          context.pushNamed(
                            RouteNames.customerActiveRepairs,
                            queryParameters: {
                              if (activeId != null && activeId.isNotEmpty)
                                'workOrderId': activeId,
                            },
                          );
                        }),
                      ),
                      const SizedBox(width: AppDimens.spaceMd),
                      Expanded(
                        child: _buildBottomButton('Parts', () {
                          context.goNamed(
                            RouteNames.customerDetailedProductParts,
                            pathParameters: {
                              'serialNumber': detail.serialNumber,
                            },
                            queryParameters: {'modelCode': detail.modelCode},
                          );
                        }),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildHistorySection(ProductDetail productDetail) {
    final history = productDetail.workOrderHistory;
    if (history.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppDimens.spaceLg),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimens.boraMd),
          border: Border.all(color: AppColors.secondary100),
          color: Colors.white,
          boxShadow: [BoxShadowStyles.subtle],
        ),
        child: Center(
          child: Text(
            'This product has no repair history.',
            style: TextStyles.bodyMedium.copyWith(
              color: AppColors.secondary400,
            ),
          ),
        ),
      );
    }
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimens.boraMd),
        border: Border.all(color: AppColors.secondary100),
        color: Colors.white,
        boxShadow: [BoxShadowStyles.subtle],
      ),
      child: ListView.separated(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: history.length,
        separatorBuilder: (_, _) =>
            const Divider(height: 1, color: AppColors.secondary100),
        itemBuilder: (context, index) {
          final item = history[index];
          final orderNum = '#${item.workOrderNumber}';
          String dateStr;
          try {
            dateStr = DateFormat('MMM dd').format(DateTime.parse(item.date));
          } catch (_) {
            dateStr = item.date;
          }
          return Padding(
            padding: const EdgeInsets.all(AppDimens.spaceMd),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  orderNum,
                  style: TextStyles.bodyLarge.copyWith(
                    color: AppColors.secondary500,
                  ),
                ),
                Text(
                  dateStr,
                  style: TextStyles.label.copyWith(
                    color: AppColors.secondary300,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBottomButton(String title, VoidCallback onPressed) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.tertiary500,
        borderRadius: BorderRadius.circular(AppDimens.boraMd),
        boxShadow: [BoxShadowStyles.glowing],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.boraMd),
          ),
        ),
        onPressed: onPressed,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            title,
            maxLines: 1,
            style: TextStyles.middle.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
