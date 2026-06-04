import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/presentation/common/core/themes/boxshadow.dart';
import 'package:zent_fe/di/injection_container.dart' as di;

import 'package:zent_fe/core/services/file_manager_service.dart';

import 'package:zent_fe/presentation/common/core/ui/zent_error_popup.dart';

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
      create: (_) => di.sl<InventoryAssetsViewModel>()..loadAssets(),
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
            const AccountHeader(title: 'Inventory Assets', showDivider: true),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => viewModel.loadAssets(),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(AppDimens.spaceMd),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppSearchBar(
                        hintText: 'Search assets by name or ID',
                        onChanged: (val) {
                          viewModel.updateSearchQuery(val);
                        },
                      ),
                      const SizedBox(height: AppDimens.spaceMd),
                      Row(
                        children: [
                          PopupMenuButton<String>(
                            offset: const Offset(0, 40),
                            onSelected: (value) {
                              viewModel.updateTypeFilter(value);
                            },
                            itemBuilder: (BuildContext context) =>
                                <PopupMenuEntry<String>>[
                                  const PopupMenuItem<String>(
                                    value: 'ALL',
                                    child: Text('All Types'),
                                  ),
                                  const PopupMenuItem<String>(
                                    value: 'PRODUCT',
                                    child: Text('Products only'),
                                  ),
                                  const PopupMenuItem<String>(
                                    value: 'PART',
                                    child: Text('Parts only'),
                                  ),
                                ],
                            child: _buildActionButton(
                              Icons.filter_list,
                              'Type: ${viewModel.typeFilter}',
                            ),
                          ),
                          const SizedBox(width: AppDimens.spaceMd),
                          GestureDetector(
                            onTap: viewModel.isExporting
                                ? null
                                : () async {
                                    final filePath = await viewModel
                                        .exportAssets();
                                    if (filePath != null) {
                                      // Extract the directory part of the saved path
                                      final lastSeparator = filePath
                                          .lastIndexOf('/');
                                      final dirPath = lastSeparator != -1
                                          ? filePath.substring(0, lastSeparator)
                                          : filePath;
                                      // Open the folder in the system file manager
                                      await FileManagerService.openFolder(
                                        dirPath,
                                      );
                                    } else {
                                      if (context.mounted) {
                                        ZentErrorPopup.show(
                                          context,
                                          'Failed to export inventory assets.',
                                        );
                                      }
                                    }
                                  },
                            child: _buildActionButton(
                              viewModel.isExporting
                                  ? Icons.hourglass_empty
                                  : Icons.ios_share,
                              viewModel.isExporting ? 'Exporting…' : 'Export',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppDimens.spaceLg),
                      if (viewModel.isLoading)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 40.0),
                            child: CircularProgressIndicator(
                              color: AppColors.tertiary500,
                            ),
                          ),
                        )
                      else if (viewModel.assets.isEmpty)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 40.0),
                            child: Text(
                              'No inventory assets found.',
                              style: TextStyle(color: AppColors.secondary400),
                            ),
                          ),
                        )
                      else
                        ...viewModel.assets.map(
                          (asset) => Padding(
                            padding: const EdgeInsets.only(
                              bottom: AppDimens.spaceLg,
                            ),
                            child: InventoryAssetCard(asset: asset),
                          ),
                        ),
                    ],
                  ),
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
