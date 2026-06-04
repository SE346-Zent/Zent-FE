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

import 'package:intl/intl.dart';

class MyProductsScreen extends StatelessWidget {
  const MyProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => sl<ProductsViewModel>()..fetchProducts(),
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
        child: RefreshIndicator(
          onRefresh: () => viewModel.fetchProducts(),
          color: AppColors.tertiary500,
          child: viewModel.isLoading && viewModel.products.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
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
                          boxShadow: [BoxShadowStyles.glowing],
                        ),
                        child: ElevatedButton(
                          onPressed: () async {
                            final result = await context.pushNamed(
                              RouteNames.customerDeviceRegistration,
                            );
                            if (result == true && context.mounted) {
                              viewModel.fetchProducts();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.tertiary500,
                            padding: const EdgeInsets.all(AppDimens.spaceMd),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppDimens.boraMd,
                              ),
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
                                      ),
                                    ),
                                    Text(
                                      'Add a new device to your service profile',
                                      style: TextStyles.label.copyWith(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: AppDimens.spaceMd),
                              Container(
                                width: 28,
                                height: 28,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2.0,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: AppDimens.spaceXl),

                      // Product List
                      if (viewModel.products.isEmpty)
                        const Center(child: Text('No products found'))
                      else
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: viewModel.products.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: AppDimens.spaceLg),
                          itemBuilder: (context, index) {
                            final product = viewModel.products[index];
                            final warrantyDate = product.warrantyUntil != null
                                ? DateFormat(
                                    'MMM dd, yyyy',
                                  ).format(product.warrantyUntil!)
                                : 'No Warranty';

                            return ProductItemCard(
                              name: product.name,
                              serialNumber: product.serialNumber,
                              productId: product.id,
                              model: product.model,
                              warrantyDate: warrantyDate,
                              status: viewModel.getProductStatus(product),
                              imagePath: viewModel.getProductImage(product),
                            );
                          },
                        ),
                      const SizedBox(height: AppDimens.spaceLg),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
