import 'package:flutter/material.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/presentation/common/core/themes/boxshadow.dart';
import 'package:go_router/go_router.dart';
import 'package:zent_fe/routing/route_names.dart';
import 'package:zent_fe/presentation/common/core/ui/app_network_image.dart';

class ProductItemCard extends StatelessWidget {
  final String name;
  final String serialNumber;
  final String productId;
  final String model;
  final String warrantyDate;
  final String status;
  final String imagePath;

  const ProductItemCard({
    super.key,
    required this.name,
    required this.serialNumber,
    required this.productId,
    required this.model,
    required this.warrantyDate,
    required this.status,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    final isExpiring = status.toLowerCase() == 'expiring';
    final badgeColor = isExpiring ? AppColors.error50 : AppColors.success50;
    final badgeTextColor = isExpiring
        ? AppColors.error500
        : AppColors.success500;

    return GestureDetector(
      onTap: () {
        context.goNamed(
          RouteNames.customerDetailedProduct,
          pathParameters: {'serialNumber': serialNumber},
          queryParameters: {'productId': productId},
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppDimens.boraMd),
          boxShadow: [BoxShadowStyles.raised],
          border: Border.all(color: AppColors.secondary100, width: 1.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            AppNetworkImage(
              url: imagePath,
              width: double.infinity,
              height: 140,
              fit: BoxFit.cover,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppDimens.boraMd),
                topRight: Radius.circular(AppDimens.boraMd),
              ),
            ),

            // Details
            Padding(
              padding: const EdgeInsets.all(AppDimens.spaceMd),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: badgeColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      status,
                      style: TextStyles.label.copyWith(
                        color: badgeTextColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDimens.spaceSm),

                  // Name
                  Text(
                    name,
                    style: TextStyles.headline.copyWith(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppDimens.spaceXs),

                  // Serial Number
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Serial Number',
                        style: TextStyles.bodyLarge.copyWith(
                          color: AppColors.secondary500,
                        ),
                      ),
                      Text(
                        serialNumber,
                        style: TextStyles.bodyMedium.copyWith(
                          color: AppColors.secondary700,
                        ),
                      ),
                    ],
                  ),

                  // Model
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Model',
                        style: TextStyles.bodyLarge.copyWith(
                          color: AppColors.secondary500,
                        ),
                      ),
                      Text(
                        model.isNotEmpty ? model : 'N/A',
                        style: TextStyles.bodyMedium.copyWith(
                          color: AppColors.secondary700,
                        ),
                      ),
                    ],
                  ),

                  // Warranty Ends
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Warranty Ends',
                        style: TextStyles.bodyLarge.copyWith(
                          color: AppColors.secondary500,
                        ),
                      ),
                      Text(
                        warrantyDate,
                        style: TextStyles.bodyMedium.copyWith(
                          color: AppColors.secondary700,
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
    );
  }
}
