import 'package:flutter/material.dart';
import '../viewmodel/company_settings_viewmodel.dart';
import '../../../common/core/themes/colors.dart';
import '../../../common/core/themes/dimens.dart';
import '../../../common/core/themes/text_styles.dart';

class CompanyInfoBlock extends StatelessWidget {
  final CompanyInfo info;

  const CompanyInfoBlock({super.key, required this.info});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          info.companyName,
          style: TextStyles.headline.copyWith(color: AppColors.primary500),
        ),
        const SizedBox(height: AppDimens.spaceXs),
        Text(
          info.address,
          style: TextStyles.bodyMedium.copyWith(color: AppColors.secondary500),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
