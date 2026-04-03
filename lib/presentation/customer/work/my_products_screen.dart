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
import 'widgets/product_item_card.dart';
import 'viewmodels/products_viewmodel.dart';

class MyProductsScreen extends StatelessWidget {
  const MyProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => sl<ProductsViewModel>(),
      child: const _MyProductsView(),
    );
  }
}

class _MyProductsView extends StatelessWidget {
  const _MyProductsView();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ProductsViewModel>();

    return Scaffold(
      backgroundColor: AppColors.background500,
      appBar: const CustomerAppBar(
        title: 'My Products',
        showBackButton: true,
        showBottomDivider: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimens.spaceMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                'Registered Products',
                style: TextStyles.display.copyWith(
                  color: Colors.black,
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Centralized asset management',
                style: TextStyles.bodyLarge.copyWith(
                  color: AppColors.secondary500,
                ),
              ),
              const SizedBox(height: AppDimens.spaceLg),

              // Register Button
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppDimens.boraMd),
                  boxShadow: [BoxShadowStyles.raised],
                ),
                child: ElevatedButton(
                  onPressed: () {
                    context.pushNamed(RouteNames.customerDeviceRegistration);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.tertiary500,
                    padding: const EdgeInsets.all(AppDimens.spaceMd),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimens.boraMd),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Register a new Device',
                              style: TextStyles.title.copyWith(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Add a new device to your service profile',
                              style: TextStyles.bodyMedium.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppDimens.spaceMd),
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2.5),
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppDimens.spaceXl),

              // Product List
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: viewModel.products.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(height: AppDimens.spaceLg),
                itemBuilder: (context, index) {
                  final product = viewModel.products[index];
                  return ProductItemCard(
                    name: product.name,
                    serialNumber: product.serialNumber,
                    warrantyDate: product.warrantyDate,
                    status: product.status,
                    imagePath: product.imagePath,
                  );
                },
              ),
              const SizedBox(height: AppDimens.spaceLg),
            ],
          ),
        ),
      ),
    );
  }
}
