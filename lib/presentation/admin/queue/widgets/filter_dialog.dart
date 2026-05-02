import 'package:flutter/material.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/presentation/common/core/themes/boxshadow.dart';

class FilterDialog extends StatelessWidget {
  const FilterDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      alignment: Alignment.topCenter,
      insetPadding: const EdgeInsets.only(top: 130.0, left: 16.0, right: 16.0),
      child: Container(
        padding: const EdgeInsets.all(AppDimens.spaceMd),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppDimens.boraMd),
          boxShadow: [BoxShadowStyles.overlay],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Filtering',
              style: TextStyles.middle.copyWith(color: Colors.black),
            ),
            const SizedBox(height: AppDimens.spaceSm),
            const Divider(color: AppColors.secondary50, height: 1),
            const SizedBox(height: AppDimens.spaceMd),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Appointment',
                  style: TextStyles.bodyLarge.copyWith(color: Colors.black),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 6.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppDimens.boraSm),
                    border: Border.all(color: AppColors.secondary200),
                  ),
                  child: Row(
                    children: [
                      Text(
                        'None',
                        style: TextStyles.bodyMedium.copyWith(
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 4.0),
                      const Icon(
                        Icons.keyboard_arrow_down,
                        size: 16,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
