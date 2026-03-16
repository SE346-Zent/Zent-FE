import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../common/core/themes/colors.dart';
import '../../../common/core/themes/dimens.dart';
import '../../../common/core/themes/text_styles.dart';

class AccountHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onBackPressed;
  final bool showDivider;
  final double horizontalPadding;
  final double verticalPadding;

  const AccountHeader({
    super.key,
    required this.title,
    this.onBackPressed,
    this.showDivider = true,
    this.horizontalPadding = AppDimens.spaceMd,
    this.verticalPadding = AppDimens.spaceSm,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = Row(
      children: [
        SizedBox(
          width: 40.0,
          height: 40.0,
          child: IconButton(
            padding: EdgeInsets.zero,
            icon: const Icon(Icons.arrow_back, color: AppColors.primary500),
            onPressed:
                onBackPressed ??
                () {
                  context.pop();
                },
          ),
        ),
        Expanded(
          child: Center(
            child: Text(
              title,
              style: TextStyles.headline.copyWith(color: AppColors.primary500),
            ),
          ),
        ),
        const SizedBox(width: 40.0), // Balance the row
      ],
    );

    if (showDivider) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: verticalPadding,
            ),
            child: content,
          ),
          Container(
            width: double.infinity,
            height: 1.0,
            color: AppColors.secondary50,
          ),
        ],
      );
    }

    return content;
  }
}
