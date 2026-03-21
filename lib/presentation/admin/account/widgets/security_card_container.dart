import 'package:flutter/material.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';

class SecurityCardContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;

  const SecurityCardContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.surface100, // #FFFFFF
        borderRadius: BorderRadius.circular(AppDimens.boraMd),
        border: Border.all(color: AppColors.secondary100, width: 1.0),
      ),
      padding: const EdgeInsets.all(AppDimens.spaceMd),
      child: child,
    );
  }
}
