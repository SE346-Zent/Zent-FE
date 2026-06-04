import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:zent_fe/routing/route_names.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/presentation/common/core/themes/boxshadow.dart';
import 'package:zent_fe/presentation/common/auth/login/widgets/auth_primary_button.dart';
import 'viewmodels/request_service_viewmodel.dart';
import 'viewmodels/products_viewmodel.dart';
import 'widgets/selectable_device_card.dart';

class RequestServiceDiscoveryScreen extends StatefulWidget {
  const RequestServiceDiscoveryScreen({super.key});

  @override
  State<RequestServiceDiscoveryScreen> createState() =>
      _RequestServiceDiscoveryScreenState();
}

class _RequestServiceDiscoveryScreenState
    extends State<RequestServiceDiscoveryScreen> {
  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<RequestServiceViewModel>();
    final productsVM = context.watch<ProductsViewModel>();

    return Column(
      children: [
        Expanded(
          child: RefreshIndicator(
            onRefresh: () => productsVM.fetchProducts(),
            color: AppColors.tertiary500,
            child: productsVM.isLoading && productsVM.products.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(AppDimens.spaceMd),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Step Indicator
                        Text(
                          'Step 1 of 5',
                          style: TextStyles.bodyMedium.copyWith(
                            color: AppColors.tertiary500,
                          ),
                        ),
                        const SizedBox(height: AppDimens.spaceXs),
                        Text(
                          'Discovery',
                          style: TextStyles.display.copyWith(
                            color: AppColors.primary500,
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: AppDimens.spaceXs),
                        Text(
                          'Please provide the selected device to get started',
                          style: TextStyles.bodyLarge.copyWith(
                            color: AppColors.secondary500,
                          ),
                        ),
                        const SizedBox(height: AppDimens.spaceMd),

                        // Title with Register button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                'Registered Devices',
                                style: TextStyles.title.copyWith(
                                  color: Colors.black,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () async {
                                final result = await context.pushNamed(
                                  RouteNames.customerDeviceRegistration,
                                );
                                if (result == true && context.mounted) {
                                  productsVM.fetchProducts();
                                }
                              },
                              icon: const Icon(Icons.add, size: 18),
                              label: const Text('Register New'),
                              style: TextButton.styleFrom(
                                foregroundColor: AppColors.tertiary500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppDimens.spaceSm),

                        // List
                        if (productsVM.products.isEmpty)
                          const Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: AppDimens.spaceXl,
                            ),
                            child: Center(child: Text('No registered devices')),
                          )
                        else
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: productsVM.products.length,
                            separatorBuilder: (_, _) =>
                                const SizedBox(height: AppDimens.spaceMd),
                            itemBuilder: (context, index) {
                              final product = productsVM.products[index];
                              return SelectableDeviceCard(
                                imagePath: productsVM.getProductImage(product),
                                name: product.name,
                                serialNumber: product.serialNumber,
                                mtm: product.model,
                                status: productsVM.getProductStatus(product),
                                isSelected:
                                    viewModel.selectedSerialNumber ==
                                    product.serialNumber,
                                onTap: () => viewModel.selectDevice(
                                  product.id,
                                  product.serialNumber,
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                  ),
          ),
        ),
        _buildBottomBar(viewModel),
      ],
    );
  }

  Widget _buildBottomBar(RequestServiceViewModel viewModel) {
    final bool isNextEnabled = viewModel.selectedSerialNumber != null;

    return Container(
      padding: const EdgeInsets.all(AppDimens.spaceMd),
      child: SafeArea(
        top: false,
        child: AuthPrimaryButton(
          text: 'Next',
          boxShadow: [BoxShadowStyles.raised],
          onPressed: isNextEnabled ? () => viewModel.nextStep() : null,
        ),
      ),
    );
  }
}
