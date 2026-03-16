import 'package:flutter/material.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';

class ChatHeader extends StatelessWidget {
  final VoidCallback onSearchPressed;

  const ChatHeader({
    super.key,
    required this.onSearchPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spaceMd,
        vertical: AppDimens.spaceMd,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Messages',
            style: TextStyles.headline.copyWith(
              color: AppColors.primary500,
            ),
          ),
          InkWell(
            onTap: onSearchPressed,
            borderRadius: BorderRadius.circular(AppDimens.boraSm),
            child: Container(
              width: 35.0,
              height: 35.0,
              decoration: BoxDecoration(
                color: AppColors.tertiary50,
                borderRadius: BorderRadius.circular(AppDimens.boraSm),
              ),
              alignment: Alignment.center,
              child: const SizedBox(
                width: 14.0,
                height: 14.0,
                child: Icon(
                  Icons.search,
                  size: 14.0,
                  color: AppColors.tertiary500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
