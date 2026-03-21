import 'package:flutter/material.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';

class SecuritySectionTitle extends StatelessWidget {
  final String title;
  final IconData iconData;
  final Color iconColor;
  final double iconSize;

  const SecuritySectionTitle({
    super.key,
    required this.title,
    required this.iconData,
    required this.iconColor,
    this.iconSize = 18.0,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(iconData, color: iconColor, size: iconSize),
        const SizedBox(width: AppDimens.spaceSm),
        Text(
          title,
          style: TextStyles.title.copyWith(color: AppColors.primary500),
        ),
      ],
    );
  }
}
