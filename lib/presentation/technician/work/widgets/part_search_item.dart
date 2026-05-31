import 'package:flutter/material.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/presentation/common/core/themes/boxshadow.dart';
import '../viewmodels/part_search_viewmodel.dart';

class PartSearchItem extends StatelessWidget {
  final PartSearchItemModel part;
  final VoidCallback onTap;

  const PartSearchItem({super.key, required this.part, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimens.spaceMd),
      decoration: BoxDecoration(
        color: AppColors.surface100,
        borderRadius: BorderRadius.circular(AppDimens.boraSm),
        boxShadow: [BoxShadowStyles.raised],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppDimens.boraSm),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.spaceMd,
              vertical: 12.0,
            ),
            child: Row(
              children: [
                // Part Image
                Container(
                  width: 48.0,
                  height: 48.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppDimens.boraSm),
                    image: DecorationImage(
                      image: NetworkImage(part.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: AppDimens.spaceMd),
                // Part Info
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        part.name,
                        style: TextStyles.middle.copyWith(
                          color: AppColors.primary500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2.0),
                      Text(
                        'Part No: ${part.partNo} | Commodity: ${part.commodity}',
                        style: TextStyles.label.copyWith(
                          color: AppColors.secondary500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                // Part Status
                Text(
                  part.status == PartStatus.available
                      ? 'Available'
                      : 'Unavailable',
                  style: TextStyles.bodyLarge.copyWith(
                    color: part.status == PartStatus.available
                        ? AppColors.success500
                        : AppColors.secondary200,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
