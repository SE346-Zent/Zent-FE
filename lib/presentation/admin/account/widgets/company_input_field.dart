import 'package:flutter/material.dart';
import '../../../common/core/themes/colors.dart';
import '../../../common/core/themes/dimens.dart';
import '../../../common/core/themes/text_styles.dart';

class CompanyInputField extends StatelessWidget {
  final String label;
  final String hintText;
  final IconData? icon;

  const CompanyInputField({
    super.key,
    required this.label,
    required this.hintText,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyles.middle.copyWith(color: AppColors.primary500),
        ),
        const SizedBox(height: AppDimens.spaceXs),
        Container(
          width: 364.0,
          height: 48.0, // standard input height
          decoration: BoxDecoration(
            color: AppColors.surface100, // white background for input
            borderRadius: BorderRadius.circular(AppDimens.boraMd),
            border: Border.all(color: AppColors.secondary100, width: 1.0),
          ),
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceMd),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, color: AppColors.secondary200, size: 20.0),
                const SizedBox(width: AppDimens.spaceSm),
              ],
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: hintText,
                    hintStyle: TextStyles.bodyLarge.copyWith(
                      color: AppColors.secondary300,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  style: TextStyles.bodyLarge.copyWith(
                    color: AppColors.primary500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
