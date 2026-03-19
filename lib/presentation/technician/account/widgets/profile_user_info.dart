import 'package:flutter/material.dart';

// Themes
import 'package:zent_fe/presentation/common/core/themes/colors.dart';
import 'package:zent_fe/presentation/common/core/themes/text_styles.dart';

// ViewModel
import '../view_models/tech_profile_viewmodel.dart';

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
        Text(
          userInfo.role,
          style: TextStyles.bodyLarge.copyWith(color: AppColors.secondary500),
        ),
      ],
    );
  }
}
