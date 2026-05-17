import 'package:flutter/material.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/presentation/common/core/themes/boxshadow.dart';
import '../viewmodels/inventory_assets_viewmodel.dart';

class InventoryAssetCard extends StatelessWidget {
  final InventoryAsset asset;

  const InventoryAssetCard({super.key, required this.asset});

  @override
  Widget build(BuildContext context) {
    final isProduct = asset.type == 'PRODUCT';
    final mainColor = isProduct ? AppColors.tertiary500 : AppColors.error500;
    final bgColor = isProduct ? AppColors.tertiary50 : AppColors.error50;
    final inStock = asset.stockCount > 0;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimens.boraMd),
        boxShadow: [BoxShadowStyles.raised],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppDimens.boraMd),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(width: 6.0, color: mainColor),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      asset.imagePath,
                      height: 100,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(AppDimens.spaceMd),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                  vertical: 4.0,
                                ),
                                decoration: BoxDecoration(
                                  color: bgColor,
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                child: Text(
                                  asset.type,
                                  style: TextStyles.label.copyWith(
                                    color: mainColor,
                                  ),
                                ),
                              ),
                              Text(
                                'MTM: ${asset.mtm}',
                                style: TextStyles.label.copyWith(
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppDimens.spaceMd),
                          Text(
                            asset.title,
                            style: TextStyles.title.copyWith(
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            asset.description,
                            style: TextStyles.bodyMedium.copyWith(
                              color: Colors.black,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: AppDimens.spaceMd,
                            ),
                            child: Divider(
                              color: AppColors.secondary50,
                              height: 1.0,
                              thickness: 1.0,
                            ),
                          ),
                          Row(
                            children: [
                              inStock
                                  ? const Icon(
                                      Icons.assignment_turned_in_outlined,
                                      color: AppColors.success500,
                                      size: 16.0,
                                    )
                                  : Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        const Icon(
                                          Icons.assignment_outlined,
                                          color: AppColors.error500,
                                          size: 16.0,
                                        ),
                                        Container(
                                          width: 8,
                                          height: 8,
                                          color: Colors.white,
                                        ),
                                        const Icon(
                                          Icons.close,
                                          color: AppColors.error500,
                                          size: 10.0,
                                        ),
                                      ],
                                    ),
                              const SizedBox(width: AppDimens.spaceXs),
                              Text(
                                inStock
                                    ? '${asset.stockCount} In Stock'
                                    : 'Out of Stock',
                                style: TextStyles.label.copyWith(
                                  color: inStock
                                      ? AppColors.success500
                                      : AppColors.error500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
