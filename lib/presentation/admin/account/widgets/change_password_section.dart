import 'package:flutter/material.dart';
import '../../../common/core/themes/colors.dart';
import '../../../common/core/themes/dimens.dart';
import 'password_input_field.dart';
import 'security_card_container.dart';
import 'security_section_title.dart';

class ChangePasswordSection extends StatelessWidget {
  const ChangePasswordSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        SecuritySectionTitle(
          title: 'Change Password',
          iconData: Icons.lock_outline,
          iconColor: AppColors.tertiary400,
          iconSize: 18.0,
        ),
        SizedBox(height: AppDimens.spaceMd),
        SecurityCardContainer(
          child: Column(
            children: [
              PasswordInputField(label: 'Current Password'),
              SizedBox(height: AppDimens.spaceMd),
              PasswordInputField(label: 'New Password'),
              SizedBox(height: AppDimens.spaceMd),
              PasswordInputField(label: 'Confirm New Password'),
            ],
          ),
        ),
      ],
    );
  }
}
