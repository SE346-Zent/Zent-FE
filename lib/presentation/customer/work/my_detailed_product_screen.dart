import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:zent_fe/routing/route_names.dart';
import 'package:zent_fe/di/injection_container.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/presentation/common/core/themes/boxshadow.dart';
import '../account/widgets/customer_app_bar.dart';
import 'viewmodels/detailed_product_viewmodel.dart';

class MyDetailedProductScreen extends StatefulWidget {
  final String serialNumber;
  const MyDetailedProductScreen({super.key, required this.serialNumber});

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
    _viewModel.init(widget.serialNumber);
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

    return Scaffold(
      backgroundColor: AppColors.surface100,
      appBar: CustomerAppBar(
        title: viewModel.product?.name ?? 'Detail',
        showBackButton: true,
        showBottomDivider: true,
      ),
      body: viewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
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
                        ClipRRect(
                          borderRadius: BorderRadius.circular(AppDimens.boraMd),
                          child:
                              viewModel.imagePath.startsWith('http') ||
                                  viewModel.imagePath.startsWith('https')
                              ? Image.network(
                                  viewModel.imagePath,
                                  height: 200,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    debugPrint(
                                      '=== [DetailedProductImage] Network Image Error for ${viewModel.imagePath}: $error ===',
                                    );
                                    return Container(
                                      height: 200,
                                      width: double.infinity,
                                      color: AppColors.secondary50,
                                      child: const Icon(
                                        Icons.broken_image,
                                        color: AppColors.secondary200,
                                        size: 48,
                                      ),
                                    );
                                  },
                                )
                              : viewModel.imagePath.isNotEmpty
                              ? Image.asset(
                                  viewModel.imagePath,
                                  height: 200,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      height: 200,
                                      width: double.infinity,
                                      color: AppColors.secondary50,
                                      child: const Icon(
                                        Icons.broken_image,
                                        color: AppColors.secondary200,
                                        size: 48,
                                      ),
                                    );
                                  },
                                )
                              : Container(
                                  height: 200,
                                  width: double.infinity,
                                  color: AppColors.secondary50,
                                  child: const Icon(
                                    Icons.image_not_supported,
                                    color: AppColors.secondary200,
                                    size: 48,
                                  ),
                                ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(AppDimens.spaceLg),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Product Info
                              Container(
                                margin: const EdgeInsets.only(right: 16.0),
                                child: Text(
                                  viewModel.product?.name ?? 'Unknown Product',
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
                                      'S/N: ${viewModel.product?.serialNumber ?? viewModel.currentSerialNumber ?? 'NA'}',
                                      style: TextStyles.bodyLarge.copyWith(
                                        color: AppColors.secondary500,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: AppDimens.spaceSm),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      'MTM: ${viewModel.product?.model ?? 'NA'}',
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

                              // Warranty Status & Support Status Calculation
                              Builder(
                                builder: (context) {
                                  final endDate =
                                      viewModel
                                          .productDetail
                                          ?.warranty
                                          ?.endDate ??
                                      viewModel.product?.warrantyUntil;
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
                                  DateTime? startDate = viewModel
                                      .productDetail
                                      ?.warranty
                                      ?.startDate;
                                  DateTime? endDate =
                                      viewModel
                                          .productDetail
                                          ?.warranty
                                          ?.endDate ??
                                      viewModel.product?.warrantyUntil;

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
                                    final totalDays = 365 * 3; // 3 years mock
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
                                          // Spacing for Today label
                                          const SizedBox(height: 20),
                                          // Bar
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
                                          // Dates
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
                                                viewModel.warrantyDate
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
                                      // Today Pin
                                      if (isWarrantyAvailable &&
                                          elapsedProportion > 0 &&
                                          elapsedProportion < 1)
                                        Positioned(
                                          left:
                                              todayOffset -
                                              10, // Center the 40px wide column over the point
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
                              viewModel.history.isEmpty
                                  ? Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(
                                        AppDimens.spaceLg,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          AppDimens.boraMd,
                                        ),
                                        border: Border.all(
                                          color: AppColors.secondary100,
                                        ),
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
                                    )
                                  : Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          AppDimens.boraMd,
                                        ),
                                        border: Border.all(
                                          color: AppColors.secondary100,
                                        ),
                                        color: Colors.white,
                                        boxShadow: [BoxShadowStyles.subtle],
                                      ),
                                      child: ListView.separated(
                                        padding: EdgeInsets.zero,
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: viewModel.history.length,
                                        separatorBuilder: (_, _) =>
                                            const Divider(
                                              height: 1,
                                              color: AppColors.secondary100,
                                            ),
                                        itemBuilder: (context, index) {
                                          final item = viewModel.history[index];
                                          return Padding(
                                            padding: const EdgeInsets.all(
                                              AppDimens.spaceMd,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  item.orderNumber,
                                                  style: TextStyles.bodyLarge
                                                      .copyWith(
                                                        color: AppColors
                                                            .secondary500,
                                                      ),
                                                ),
                                                Text(
                                                  item.date,
                                                  style: TextStyles.label
                                                      .copyWith(
                                                        color: AppColors
                                                            .secondary300,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
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
                          context.pushNamed(
                            RouteNames.customerActiveRepairs,
                            queryParameters: {
                              if (viewModel.activeWorkOrderForProduct?.id !=
                                  null)
                                'workOrderId':
                                    viewModel.activeWorkOrderForProduct!.id,
                            },
                          );
                        }),
                      ),
                      const SizedBox(width: AppDimens.spaceMd),
                      Expanded(
                        child: _buildBottomButton('Parts', () {
                          context.pushNamed(
                            RouteNames.customerDetailedProductParts,
                            pathParameters: {
                              'serialNumber':
                                  viewModel.product?.serialNumber ??
                                  viewModel.currentSerialNumber ??
                                  'NA',
                            },
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
