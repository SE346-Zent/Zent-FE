import 'package:flutter/material.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';
import 'package:zent_fe/presentation/common/core/themes/boxshadow.dart';

class AdminDashboardStatCard extends StatelessWidget {
  final String title;
  final String value;
  final String? suffix;
  final IconData trendIcon;
  final Color trendColor;
  final String trendValue;
  final Color leftBarColor;

  const AdminDashboardStatCard({
    super.key,
    required this.title,
    required this.value,
    this.suffix,
    required this.trendIcon,
    required this.trendColor,
    required this.trendValue,
    required this.leftBarColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [BoxShadowStyles.subtle],
      ),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(width: 6.0, color: leftBarColor),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.spaceMd,
                  vertical: 12.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          style: TextStyles.title.copyWith(
                            color: AppColors.secondary500,
                          ),
                        ),
                        const SizedBox(height: AppDimens.spaceSm),
                        if (suffix != null)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                value,
                                style: TextStyles.display.copyWith(
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                suffix!,
                                style: TextStyles.title.copyWith(
                                  color: AppColors.secondary300,
                                ),
                              ),
                            ],
                          )
                        else
                          Text(
                            value,
                            style: TextStyles.display.copyWith(
                              color: Colors.black,
                            ),
                          ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(trendIcon, color: trendColor, size: 16),
                        const SizedBox(width: 4.0),
                        Text(
                          trendValue,
                          style: TextStyles.label.copyWith(color: trendColor),
                        ),
                      ],
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
}
