import 'package:flutter/material.dart';
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';

class OtpInputSection extends StatelessWidget {
  const OtpInputSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        6, 
        (index) => _buildOtpBox(''), // TODO: Pass actual state values later
      ),
    );
  }

  Widget _buildOtpBox(String digit) {
    bool hasValue = digit.isNotEmpty;
    return Container(
      width: 48,
      height: 48,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.surface50,
        borderRadius: BorderRadius.circular(AppDimens.boraSm),
        border: Border.all(
          color: hasValue ? AppColors.tertiary500 : AppColors.secondary200,
          width: hasValue ? 1.5 : 1.0,
        ),
      ),
      child: Text(
        digit,
        style: TextStyles.title.copyWith(
          color: AppColors.primary500,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}