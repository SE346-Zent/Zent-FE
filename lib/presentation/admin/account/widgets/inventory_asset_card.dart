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
                            style: TextStyles.headline.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
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
