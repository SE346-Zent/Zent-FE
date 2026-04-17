import 'package:flutter/material.dart';
import 'admin_text_field.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';

class RecoveryEmailSection extends StatelessWidget {
  const RecoveryEmailSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Row(
            children: [
              const Icon(
                Icons.mark_email_read_outlined,
                color: AppColors.tertiary500,
                size: 24.0,
              ),
              const SizedBox(width: AppDimens.spaceSm),
              Text(
                'Recovery Email',
                style: TextStyles.title.copyWith(color: AppColors.primary500),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(AppDimens.spaceMd),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppDimens.boraMd),
            border: Border.all(color: AppColors.secondary100),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Update recovery email address',
                style: TextStyles.label.copyWith(color: AppColors.secondary400),
              ),
              const SizedBox(height: AppDimens.spaceXs),
              const AdminTextField(hint: 'name@gmail.com'),
            ],
          ),
        ),
      ],
    );
  }
}
