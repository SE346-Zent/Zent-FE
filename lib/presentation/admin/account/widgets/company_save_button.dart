import 'package:flutter/material.dart';
import '../../../common/core/themes/colors.dart';
import '../../../common/core/themes/dimens.dart';
import '../../../common/core/themes/text_styles.dart';

class CompanySaveButton extends StatelessWidget {
  final VoidCallback onPressed;

  const CompanySaveButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppDimens.spaceMd,
        right: AppDimens.spaceMd,
        bottom: AppDimens.spaceLg,
        top: AppDimens.spaceSm,
      ),
      child: SizedBox(
        width: 364.0,
        height: 49.0,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.tertiary500,
            foregroundColor: AppColors.surface100, // #FFFFFF
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimens.boraMd),
            ),
            elevation: 0,
          ),
          child: Text(
            'Update Company Info',
            style: TextStyles.title.copyWith(color: AppColors.surface100),
          ),
        ),
      ),
    );
  }
}
