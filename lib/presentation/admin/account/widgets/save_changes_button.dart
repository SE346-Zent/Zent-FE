import 'package:flutter/material.dart';
import '../../../common/core/themes/colors.dart';
import '../../../common/core/themes/dimens.dart';
import '../../../common/core/themes/text_styles.dart';
import '../../../common/core/themes/boxshadow.dart';

class SaveChangesButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SaveChangesButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 364.0,
      height: 49.0,
      decoration: BoxDecoration(
        color: AppColors.tertiary500,
        borderRadius: BorderRadius.circular(AppDimens.boraMd),
        boxShadow: [BoxShadowStyles.subtle],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(AppDimens.boraMd),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.save_outlined,
                color: AppColors.surface100, // #FFFFFF
                size: 22.0,
              ),
              const SizedBox(width: AppDimens.spaceSm),
              Text(
                'Save Changes',
                style: TextStyles.title.copyWith(color: AppColors.surface100),
              ),
              // Balance spacing for text centering if needed, but per design left-aligned to text is fine.
              const SizedBox(width: 22.0 + AppDimens.spaceSm),
            ],
          ),
        ),
      ),
    );
  }
}
