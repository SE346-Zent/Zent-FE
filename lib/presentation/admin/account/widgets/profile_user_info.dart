import 'package:flutter/material.dart';
import '../viewmodel/profile_viewmodel.dart';
import '../../../common/core/themes/colors.dart';
import '../../../common/core/themes/dimens.dart';
import '../../../common/core/themes/text_styles.dart';

class ProfileUserInfo extends StatelessWidget {
  final UserProfileInfo userInfo;

  const ProfileUserInfo({super.key, required this.userInfo});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          userInfo.userName,
          style: TextStyles.headline.copyWith(color: AppColors.primary500),
        ),
        const SizedBox(height: AppDimens.spaceXs),
        Text(
          userInfo.role,
          style: TextStyles.bodyLarge.copyWith(color: AppColors.secondary500),
        ),
      ],
    );
  }
}
