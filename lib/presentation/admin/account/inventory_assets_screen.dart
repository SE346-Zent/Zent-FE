import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/presentation/common/core/themes/boxshadow.dart';
import 'package:zent_fe/di/injection_container.dart' as di;

// Widgets
import 'widgets/app_search_bar.dart';
import 'widgets/inventory_asset_card.dart';
import 'viewmodels/inventory_assets_viewmodel.dart';
import 'package:zent_fe/presentation/common/core/ui/account_header.dart';

class InventoryAssetsScreen extends StatelessWidget {
  const InventoryAssetsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => di.sl<InventoryAssetsViewModel>(),
      child: const _InventoryAssetsScreenContent(),
    );
  }
}

class _InventoryAssetsScreenContent extends StatelessWidget {
  const _InventoryAssetsScreenContent();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<InventoryAssetsViewModel>();

    return Scaffold(
      backgroundColor: AppColors.background500,
      body: SafeArea(
        child: Column(
          children: [
            const AccountHeader(
              title: 'Inventory Assets',
              showDivider: true,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppDimens.spaceMd),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AppSearchBar(hintText: 'Search assets by name or ID'),
                    const SizedBox(height: AppDimens.spaceMd),
                    Row(
                      children: [
                        _buildActionButton(Icons.filter_list, 'Filters'),
                        const SizedBox(width: AppDimens.spaceMd),
                        _buildActionButton(Icons.ios_share, 'Export'),
                      ],
                    ),
                    const SizedBox(height: AppDimens.spaceLg),
                    ...viewModel.assets.map(
                      (asset) => Padding(
                        padding:
                            const EdgeInsets.only(bottom: AppDimens.spaceLg),
                        child: InventoryAssetCard(asset: asset),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spaceMd,
        vertical: 8.0,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface600,
        borderRadius: BorderRadius.circular(AppDimens.boraMd),
        boxShadow: [BoxShadowStyles.subtle],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.secondary500, size: 20.0),
          const SizedBox(width: AppDimens.spaceSm),
          Text(
            text,
            style: TextStyles.middle.copyWith(color: AppColors.secondary500),
          ),
        ],
      ),
    );
  }
}
