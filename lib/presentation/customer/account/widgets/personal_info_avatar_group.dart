import 'package:flutter/material.dart';
import 'package:zent_fe/presentation/common/core/themes/dimens.dart';
import 'package:zent_fe/presentation/common/core/ui/avatar.dart';
import 'package:zent_fe/presentation/customer/account/widgets/profile_user_info.dart';

class PersonalInfoAvatarGroup extends StatelessWidget {
  final String fullName;
  final String role;

  const PersonalInfoAvatarGroup({
    super.key,
    required this.fullName,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Avatar(name: fullName),
        const SizedBox(height: AppDimens.spaceMd),
        ProfileUserInfo(name: fullName, role: role),
      ],
    );
  }
}
