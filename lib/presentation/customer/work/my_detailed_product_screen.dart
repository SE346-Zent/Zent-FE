import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:zent_fe/routing/route_names.dart';
import 'package:zent_fe/di/injection_container.dart';
import 'package:zent_fe/presentation/common/core/app_assets.dart'
    show AppAssets;
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
      body: SingleChildScrollView(
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
                border: Border.all(color: AppColors.secondary200, width: 1.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppDimens.boraMd),
                    child: Image.asset(
                      viewModel.product?.imagePath ?? AppAssets.laptopA,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(AppDimens.spaceLg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product Info
                        Text(
                          'IdeaPad 5 Pro 16ARH7 - Type 82SN',
                          style: TextStyles.headline.copyWith(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: AppDimens.spaceMd),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'S/N: ${viewModel.product?.serialNumber ?? viewModel.currentSerialNumber ?? 'NA'}',
                              style: TextStyles.bodyLarge.copyWith(
                                color: AppColors.secondary500,
                              ),
                            ),
                            Text(
                              'MTM: abc12345',
                              style: TextStyles.bodyLarge.copyWith(
                                color: AppColors.secondary500,
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

                        // Warranty Status Texts
                        RichText(
                          text: TextSpan(
                            text: 'Warranty Status: ',
                            style: TextStyles.bodyLarge.copyWith(
                              color: AppColors.secondary500,
                            ),
                            children: [
                              TextSpan(
                                text: 'In Warranty',
                                style: TextStyles.bodyLarge.copyWith(
                                  color: AppColors.success500,
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
                              TextSpan(
                                text: '100 days remaining',
                                style: TextStyles.bodyLarge.copyWith(
                                  color: AppColors.success500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppDimens.spaceXl),

                        // Progress Bar
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // 'Today' label
                            Row(
                              children: [
                                Expanded(
                                  flex: 6,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: FractionalTranslation(
                                      translation: const Offset(0.5, 0),
                                      child: Text(
                                        'Today',
                                        style: TextStyles.label.copyWith(
                                          color: AppColors.secondary400,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const Expanded(flex: 4, child: SizedBox()),
                              ],
                            ),
                            const SizedBox(height: 4),
                            // Bar
                            Container(
                              height: 12,
                              decoration: BoxDecoration(
                                color: AppColors.secondary100,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 6, // Green part
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.success300,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                    ),
                                  ),
                                  const Expanded(flex: 4, child: SizedBox()),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Dates
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Nov 10,\n2025',
                                  style: TextStyles.label.copyWith(
                                    color: AppColors.secondary400,
                                  ),
                                ),
                                Text(
                                  (viewModel.product?.warrantyDate ??
                                          'Mar 30, 2026')
                                      .replaceAll(', ', ',\n'),
                                  textAlign: TextAlign.right,
                                  style: TextStyles.label.copyWith(
                                    color: AppColors.secondary400,
                                  ),
                                ),
                              ],
                            ),
                          ],
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
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              AppDimens.boraMd,
                            ),
                            border: Border.all(color: AppColors.secondary100),
                            color: Colors.white,
                            boxShadow: [BoxShadowStyles.subtle],
                          ),
                          child: ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: viewModel.history.length,
                            separatorBuilder: (_, _) => const Divider(
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
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      item.orderNumber,
                                      style: TextStyles.bodyLarge.copyWith(
                                        color: AppColors.secondary500,
                                      ),
                                    ),
                                    Text(
                                      item.date,
                                      style: TextStyles.label.copyWith(
                                        color: AppColors.secondary300,
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
                    context.pushNamed(RouteNames.customerActiveRepairs);
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
